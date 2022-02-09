# frozen_string_literal: true

require './lib/core'
require './lib/dictionary'

module Rpl
  class Interpreter
    attr_reader :stack,
                :dictionary# ,
    #             :version

    # attr_accessor :precision

    def initialize( stack = [], dictionary = Rpl::Lang::Dictionary.new )
      # @version = 0.1

      # @precision = 12

      @dictionary = dictionary
      @stack = stack

      populate_dictionary if @dictionary.words.empty?
    end

    def self.parse( input )
      is_numeric = lambda do |elt|
        begin
          !Float(elt).nil?
        rescue ArgumentError
          begin
            !Integer(elt).nil?
          rescue ArgumentError
            false
          end
        end
      end

      splitted_input = input.split(' ')

      # 2-passes:
      # 1. regroup strings and programs
      opened_programs = 0
      closed_programs = 0
      string_delimiters = 0
      name_delimiters = 0
      regrouping = false

      regrouped_input = []
      splitted_input.each do |elt|
        if elt[0] == '«'
          opened_programs += 1
          elt.gsub!( '«', '« ') if elt.length > 1 && elt[1] != ' '
        end
        string_delimiters += 1 if elt[0] == '"' && elt.length > 1
        name_delimiters += 1 if elt[0] == "'" && elt.length > 1

        elt = "#{regrouped_input.pop} #{elt}".strip if regrouping

        regrouped_input << elt

        if elt[-1] == '»'
          closed_programs += 1
          elt.gsub!( '»', ' »') if elt.length > 1 && elt[-2] != ' '
        end
        string_delimiters += 1 if elt[-1] == '"'
        name_delimiters += 1 if elt[-1] == "'"

        regrouping = string_delimiters.odd? || name_delimiters.odd? || (opened_programs > closed_programs )
      end

      # 2. parse
      # TODO: parse ∞, <NaN> as numerics
      parsed_tree = []
      regrouped_input.each do |elt|
        parsed_entry = { value: elt }

        parsed_entry[:type] = case elt[0]
                              when '«'
                                :program
                              when '"'
                                :string
                              when "'"
                                :name # TODO: check for forbidden space
                              else
                                if is_numeric.call( elt )
                                  :numeric
                                else
                                  :word
                                end
                              end

        if %I[string name].include?( parsed_entry[:type] )
          parsed_entry[:value] = parsed_entry[:value][1..-2]
        elsif parsed_entry[:type] == :program
          parsed_entry[:value] = parsed_entry[:value][2..-3]
        elsif parsed_entry[:type] == :numeric
          parsed_entry[:base] = 10 # TODO: parse others possible bases 0x...

          begin
            parsed_entry[:value] = Float( parsed_entry[:value] )
            parsed_entry[:value] = parsed_entry[:value].to_i if (parsed_entry[:value] % 1).zero? && elt.index('.').nil?
          rescue ArgumentError
            parsed_entry[:value] = Integer( parsed_entry[:value] )
          end

          parsed_entry[:value] = BigDecimal( parsed_entry[:value], Rpl::Lang.precision )
        end

        parsed_tree << parsed_entry
      end

      parsed_tree
    end

    def run( input )
      @dictionary.add_local_vars_layer

      Interpreter.parse( input ).each do |elt|
        case elt[:type]
        when :word
          break if %w[break quit exit].include?( elt[:value] )

          command = @dictionary.lookup( elt[:value] )

          if command.nil?
            # if there isn't a command by that name then it's a name
            elt[:type] = :name

            @stack << elt
          else
            @stack, @dictionary = command.call( @stack, @dictionary )
          end
        else
          @stack << elt
        end
      end

      @dictionary.remove_local_vars_layer

      [@stack, @dictionary]
    end

    def populate_dictionary
      # GENERAL
      @dictionary.add( 'nop',
                       proc { |stack, dictionary| Rpl::Lang::Core.nop( stack, dictionary ) } )
      # @dictionary.add( 'help',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # this help message
      # @dictionary.add( 'quit',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # quit software
      # @dictionary.add( 'version',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # show rpn version
      # @dictionary.add( 'uname',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # show rpn complete identification string
      # @dictionary.add( 'history',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # see commands history
      @dictionary.add( '__ppstack',
                       proc { |stack, dictionary| Rpl::Lang.__pp_stack( stack, dictionary ) } )

      # STACK
      @dictionary.add( 'swap',
                       proc { |stack, dictionary| Rpl::Lang::Core.swap( stack, dictionary ) } )
      @dictionary.add( 'drop',
                       proc { |stack, dictionary| Rpl::Lang::Core.drop( stack, dictionary ) } )
      @dictionary.add( 'drop2',
                       proc { |stack, dictionary| Rpl::Lang::Core.drop2( stack, dictionary ) } )
      @dictionary.add( 'dropn',
                       proc { |stack, dictionary| Rpl::Lang::Core.dropn( stack, dictionary ) } )
      @dictionary.add( 'del',
                       proc { |stack, dictionary| Rpl::Lang::Core.del( stack, dictionary ) } )
      @dictionary.add( 'rot',
                       proc { |stack, dictionary| Rpl::Lang::Core.rot( stack, dictionary ) } )
      @dictionary.add( 'dup',
                       proc { |stack, dictionary| Rpl::Lang::Core.dup( stack, dictionary ) } )
      @dictionary.add( 'dup2',
                       proc { |stack, dictionary| Rpl::Lang::Core.dup2( stack, dictionary ) } )
      @dictionary.add( 'dupn',
                       proc { |stack, dictionary| Rpl::Lang::Core.dupn( stack, dictionary ) } )
      @dictionary.add( 'pick',
                       proc { |stack, dictionary| Rpl::Lang::Core.pick( stack, dictionary ) } )
      @dictionary.add( 'depth',
                       proc { |stack, dictionary| Rpl::Lang::Core.depth( stack, dictionary ) } )
      @dictionary.add( 'roll',
                       proc { |stack, dictionary| Rpl::Lang::Core.roll( stack, dictionary ) } )
      @dictionary.add( 'rolld',
                       proc { |stack, dictionary| Rpl::Lang::Core.rolld( stack, dictionary ) } )
      @dictionary.add( 'over',
                       proc { |stack, dictionary| Rpl::Lang::Core.over( stack, dictionary ) } )

      # USUAL OPERATIONS ON REALS AND COMPLEXES
      @dictionary.add( '+',
                       proc { |stack, dictionary| Rpl::Lang::Core.add( stack, dictionary ) } )
      @dictionary.add( '-',
                       proc { |stack, dictionary| Rpl::Lang::Core.subtract( stack, dictionary ) } )
      @dictionary.add( 'chs',
                       proc { |stack, dictionary| Rpl::Lang::Core.negate( stack, dictionary ) } )
      @dictionary.add( '*',
                       proc { |stack, dictionary| Rpl::Lang::Core.multiply( stack, dictionary ) } ) # alias
      @dictionary.add( '×',
                       proc { |stack, dictionary| Rpl::Lang::Core.multiply( stack, dictionary ) } )
      @dictionary.add( '/',
                       proc { |stack, dictionary| Rpl::Lang::Core.divide( stack, dictionary ) } ) # alias
      @dictionary.add( '÷',
                       proc { |stack, dictionary| Rpl::Lang::Core.divide( stack, dictionary ) } )
      @dictionary.add( 'inv',
                       proc { |stack, dictionary| Rpl::Lang::Core.inverse( stack, dictionary ) } )
      @dictionary.add( '^',
                       proc { |stack, dictionary| Rpl::Lang::Core.power( stack, dictionary ) } )
      @dictionary.add( 'sqrt',
                       proc { |stack, dictionary| Rpl::Lang::Core.sqrt( stack, dictionary ) } ) # alias
      @dictionary.add( '√',
                       proc { |stack, dictionary| Rpl::Lang::Core.sqrt( stack, dictionary ) } )
      @dictionary.add( 'sq',
                       proc { |stack, dictionary| Rpl::Lang::Core.sq( stack, dictionary ) } )
      @dictionary.add( 'abs',
                       proc { |stack, dictionary| Rpl::Lang::Core.abs( stack, dictionary ) } )
      @dictionary.add( 'dec',
                       proc { |stack, dictionary| Rpl::Lang::Core.dec( stack, dictionary ) } )
      @dictionary.add( 'hex',
                       proc { |stack, dictionary| Rpl::Lang::Core.hex( stack, dictionary ) } )
      @dictionary.add( 'bin',
                       proc { |stack, dictionary| Rpl::Lang::Core.bin( stack, dictionary ) } )
      @dictionary.add( 'base',
                       proc { |stack, dictionary| Rpl::Lang::Core.base( stack, dictionary ) } )
      @dictionary.add( 'sign',
                       proc { |stack, dictionary| Rpl::Lang::Core.sign( stack, dictionary ) } )

      # OPERATIONS ON REALS
      @dictionary.add( '%',
                       proc { |stack, dictionary| Rpl::Lang::Core.percent( stack, dictionary ) } )
      @dictionary.add( '%CH',
                       proc { |stack, dictionary| Rpl::Lang::Core.inverse_percent( stack, dictionary ) } )
      @dictionary.add( 'mod',
                       proc { |stack, dictionary| Rpl::Lang::Core.mod( stack, dictionary ) } )
      @dictionary.add( 'fact',
                       proc { |stack, dictionary| Rpl::Lang::Core.fact( stack, dictionary ) } )
      @dictionary.add( '!',
                       proc { |stack, dictionary| Rpl::Lang::Core.fact( stack, dictionary ) } ) # alias
      @dictionary.add( 'floor',
                       proc { |stack, dictionary| Rpl::Lang::Core.floor( stack, dictionary ) } )
      @dictionary.add( 'ceil',
                       proc { |stack, dictionary| Rpl::Lang::Core.ceil( stack, dictionary ) } )
      @dictionary.add( 'min',
                       proc { |stack, dictionary| Rpl::Lang::Core.min( stack, dictionary ) } )
      @dictionary.add( 'max',
                       proc { |stack, dictionary| Rpl::Lang::Core.max( stack, dictionary ) } )
      # @dictionary.add( 'mant',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # mantissa of a real number
      # @dictionary.add( 'xpon',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exponant of a real number
      # @dictionary.add( 'ip',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # integer part
      # @dictionary.add( 'fp',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # fractional part

      # OPERATIONS ON COMPLEXES
      # @dictionary.add( 're',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # complex real part
      # @dictionary.add( 'im',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # complex imaginary part
      # @dictionary.add( 'conj',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # complex conjugate
      # @dictionary.add( 'arg',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # complex argument in radians
      # @dictionary.add( 'c->r',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # transform a complex in 2 reals
      # @dictionary.add( 'c→r',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias
      # @dictionary.add( 'r->c',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # transform 2 reals in a complex
      # @dictionary.add( 'r→c',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias
      # @dictionary.add( 'p->r',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # cartesian to polar
      # @dictionary.add( 'p→r',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias
      # @dictionary.add( 'r->p',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # polar to cartesian
      # @dictionary.add( 'r→p',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias

      # MODE
      @dictionary.add( 'prec',
                       proc { |stack, dictionary| Rpl::Lang::Core.prec( stack, dictionary ) } )
      @dictionary.add( 'default',
                       proc { |stack, dictionary| Rpl::Lang::Core.default( stack, dictionary ) } )
      @dictionary.add( 'type',
                       proc { |stack, dictionary| Rpl::Lang::Core.type( stack, dictionary ) } )
      # @dictionary.add( 'std',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # standard floating numbers representation. ex: std
      # @dictionary.add( 'fix',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # fixed point representation. ex: 6 fix
      # @dictionary.add( 'sci',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # scientific floating point representation. ex: 20 sci
      # @dictionary.add( 'round',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # set float rounding mode. ex: ["nearest", "toward zero", "toward +inf", "toward -inf", "away from zero"] round

      # TEST
      @dictionary.add( '>',
                       proc { |stack, dictionary| Rpl::Lang::Core.greater_than( stack, dictionary ) } )
      @dictionary.add( '>=',
                       proc { |stack, dictionary| Rpl::Lang::Core.greater_than_or_equal( stack, dictionary ) } ) # alias
      @dictionary.add( '≥',
                       proc { |stack, dictionary| Rpl::Lang::Core.greater_than_or_equal( stack, dictionary ) } )
      @dictionary.add( '<',
                       proc { |stack, dictionary| Rpl::Lang::Core.less_than( stack, dictionary ) } )
      @dictionary.add( '<=',
                       proc { |stack, dictionary| Rpl::Lang::Core.less_than_or_equal( stack, dictionary ) } ) # alias
      @dictionary.add( '≤',
                       proc { |stack, dictionary| Rpl::Lang::Core.less_than_or_equal( stack, dictionary ) } )
      @dictionary.add( '!=',
                       proc { |stack, dictionary| Rpl::Lang::Core.different( stack, dictionary ) } ) # alias
      @dictionary.add( '≠',
                       proc { |stack, dictionary| Rpl::Lang::Core.different( stack, dictionary ) } )
      @dictionary.add( '==',
                       proc { |stack, dictionary| Rpl::Lang::Core.same( stack, dictionary ) } )
      @dictionary.add( 'and',
                       proc { |stack, dictionary| Rpl::Lang::Core.and( stack, dictionary ) } )
      @dictionary.add( 'or',
                       proc { |stack, dictionary| Rpl::Lang::Core.or( stack, dictionary ) } )
      @dictionary.add( 'xor',
                       proc { |stack, dictionary| Rpl::Lang::Core.xor( stack, dictionary ) } )
      @dictionary.add( 'not',
                       proc { |stack, dictionary| Rpl::Lang::Core.not( stack, dictionary ) } )
      @dictionary.add( 'same',
                       proc { |stack, dictionary| Rpl::Lang::Core.same( stack, dictionary ) } ) # alias
      @dictionary.add( 'true',
                       proc { |stack, dictionary| Rpl::Lang::Core.true( stack, dictionary ) } ) # specific
      @dictionary.add( 'false',
                       proc { |stack, dictionary| Rpl::Lang::Core.false( stack, dictionary ) } ) # specific

      # STRING
      @dictionary.add( '->str',
                       proc { |stack, dictionary| Rpl::Lang::Core.to_string( stack, dictionary ) } ) # alias
      @dictionary.add( '→str',
                       proc { |stack, dictionary| Rpl::Lang::Core.to_string( stack, dictionary ) } )
      @dictionary.add( 'str->',
                       proc { |stack, dictionary| Rpl::Lang::Core.from_string( stack, dictionary ) } ) # alias
      @dictionary.add( 'str→',
                       proc { |stack, dictionary| Rpl::Lang::Core.from_string( stack, dictionary ) } )
      @dictionary.add( 'chr',
                       proc { |stack, dictionary| Rpl::Lang::Core.chr( stack, dictionary ) } )
      @dictionary.add( 'num',
                       proc { |stack, dictionary| Rpl::Lang::Core.num( stack, dictionary ) } )
      @dictionary.add( 'size',
                       proc { |stack, dictionary| Rpl::Lang::Core.size( stack, dictionary ) } )
      @dictionary.add( 'pos',
                       proc { |stack, dictionary| Rpl::Lang::Core.pos( stack, dictionary ) } )
      @dictionary.add( 'sub',
                       proc { |stack, dictionary| Rpl::Lang::Core.sub( stack, dictionary ) } )
      @dictionary.add( 'rev',
                       proc { |stack, dictionary| Rpl::Lang::Core.rev( stack, dictionary ) } ) # specific
      @dictionary.add( 'split',
                       proc { |stack, dictionary| Rpl::Lang::Core.split( stack, dictionary ) } ) # specific

      # BRANCH
      @dictionary.add( 'ift',
                       proc { |stack, dictionary| Rpl::Lang::Core.ift( stack, dictionary ) } )
      @dictionary.add( 'ifte',
                       proc { |stack, dictionary| Rpl::Lang::Core.ifte( stack, dictionary ) } )
      @dictionary.add( 'times',
                       proc { |stack, dictionary| Rpl::Lang::Core.times( stack, dictionary ) } ) # specific
      @dictionary.add( 'loop',
                       proc { |stack, dictionary| Rpl::Lang::Core.loop( stack, dictionary ) } ) # specific
      # @dictionary.add( 'if',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # if <test-instruction> then <true-instructions> else <false-instructions> end
      # @dictionary.add( 'then',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with if
      # @dictionary.add( 'else',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with if
      # @dictionary.add( 'end',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with various branch instructions
      # @dictionary.add( 'start',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # <start> <end> start <instructions> next|<step> step
      # @dictionary.add( 'for',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # <start> <end> for <variable> <instructions> next|<step> step
      # @dictionary.add( 'next',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with start and for
      # @dictionary.add( 'step',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with start and for
      # @dictionary.add( 'do',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # do <instructions> until <condition> end
      # @dictionary.add( 'until',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with do
      # @dictionary.add( 'while',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # while <test-instruction> repeat <loop-instructions> end
      # @dictionary.add( 'repeat',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with while

      # STORE
      @dictionary.add( 'sto',
                       proc { |stack, dictionary| Rpl::Lang::Core.sto( stack, dictionary ) } )
      @dictionary.add( '▶',
                       proc { |stack, dictionary| Rpl::Lang::Core.sto( stack, dictionary ) } ) # alias
      @dictionary.add( 'rcl',
                       proc { |stack, dictionary| Rpl::Lang::Core.rcl( stack, dictionary ) } )
      @dictionary.add( 'purge',
                       proc { |stack, dictionary| Rpl::Lang::Core.purge( stack, dictionary ) } )
      @dictionary.add( 'vars',
                       proc { |stack, dictionary| Rpl::Lang::Core.vars( stack, dictionary ) } )
      @dictionary.add( 'clusr',
                       proc { |stack, dictionary| Rpl::Lang::Core.clusr( stack, dictionary ) } )
      @dictionary.add( 'sto+',
                       proc { |stack, dictionary| Rpl::Lang::Core.sto_add( stack, dictionary ) } )
      @dictionary.add( 'sto-',
                       proc { |stack, dictionary| Rpl::Lang::Core.sto_subtract( stack, dictionary ) } )
      @dictionary.add( 'sto*',
                       proc { |stack, dictionary| Rpl::Lang::Core.sto_multiply( stack, dictionary ) } ) # alias
      @dictionary.add( 'sto×',
                       proc { |stack, dictionary| Rpl::Lang::Core.sto_multiply( stack, dictionary ) } )
      @dictionary.add( 'sto/',
                       proc { |stack, dictionary| Rpl::Lang::Core.sto_divide( stack, dictionary ) } ) # alias
      @dictionary.add( 'sto÷',
                       proc { |stack, dictionary| Rpl::Lang::Core.sto_divide( stack, dictionary ) } )
      @dictionary.add( 'sneg',
                       proc { |stack, dictionary| Rpl::Lang::Core.sto_negate( stack, dictionary ) } )
      @dictionary.add( 'sinv',
                       proc { |stack, dictionary| Rpl::Lang::Core.sto_inverse( stack, dictionary ) } )
      # @dictionary.add( 'edit',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # edit a variable content
      @dictionary.add( 'lsto',
                       proc { |stack, dictionary| Rpl::Lang::Core.lsto( stack, dictionary ) } ) # store to local variable
      @dictionary.add( '↴',
                       proc { |stack, dictionary| Rpl::Lang::Core.lsto( stack, dictionary ) } ) # alias

      # PROGRAM
      @dictionary.add( 'eval',
                       proc { |stack, dictionary| Rpl::Lang::Core.eval( stack, dictionary ) } )
      # @dictionary.add( '->',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # load program local variables. ex: « → n m « 0 n m for i i + next » »
      # @dictionary.add( '→',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias

      # TRIG ON REALS AND COMPLEXES
      @dictionary.add( 'pi',
                       proc { |stack, dictionary| Rpl::Lang::Core.pi( stack, dictionary ) } )
      @dictionary.add( '𝛑',
                       proc { |stack, dictionary| Rpl::Lang::Core.pi( stack, dictionary ) } ) # alias
      @dictionary.add( 'sin',
                       proc { |stack, dictionary| Rpl::Lang::Core.sinus( stack, dictionary ) } ) # sinus
      @dictionary.add( 'asin',
                       proc { |stack, dictionary| Rpl::Lang::Core.arg_sinus( stack, dictionary ) } ) # arg sinus
      @dictionary.add( 'cos',
                       proc { |stack, dictionary| Rpl::Lang::Core.cosinus( stack, dictionary ) } ) # cosinus
      @dictionary.add( 'acos',
                       proc { |stack, dictionary| Rpl::Lang::Core.arg_cosinus( stack, dictionary ) } ) # arg cosinus
      @dictionary.add( 'tan',
                       proc { |stack, dictionary| Rpl::Lang::Core.tangent( stack, dictionary ) } ) # tangent
      @dictionary.add( 'atan',
                       proc { |stack, dictionary| Rpl::Lang::Core.arg_tangent( stack, dictionary ) } ) # arg tangent
      @dictionary.add( 'd->r',
                       proc { |stack, dictionary| Rpl::Lang::Core.degrees_to_radians( stack, dictionary ) } ) # convert degrees to radians
      @dictionary.add( 'd→r',
                       proc { |stack, dictionary| Rpl::Lang::Core.degrees_to_radians( stack, dictionary ) } ) # alias
      @dictionary.add( 'r->d',
                       proc { |stack, dictionary| Rpl::Lang::Core.radians_to_degrees( stack, dictionary ) } ) # convert radians to degrees
      @dictionary.add( 'r→d',
                       proc { |stack, dictionary| Rpl::Lang::Core.radians_to_degrees( stack, dictionary ) } ) # alias

      # LOGS ON REALS AND COMPLEXES
      @dictionary.add( 'e',
                       proc { |stack, dictionary| Rpl::Lang::Core.e( stack, dictionary ) } ) # alias
      @dictionary.add( 'ℇ',
                       proc { |stack, dictionary| Rpl::Lang::Core.e( stack, dictionary ) } )
      # @dictionary.add( 'ln',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # logarithm base e
      # @dictionary.add( 'lnp1',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # ln(1+x) which is useful when x is close to 0
      # @dictionary.add( 'exp',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exponential
      # @dictionary.add( 'expm',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exp(x)-1 which is useful when x is close to 0
      # @dictionary.add( 'log10',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # logarithm base 10
      # @dictionary.add( 'alog10',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exponential base 10
      # @dictionary.add( 'log2',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # logarithm base 2
      # @dictionary.add( 'alog2',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exponential base 2
      # @dictionary.add( 'sinh',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # hyperbolic sine
      # @dictionary.add( 'asinh',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # inverse hyperbolic sine
      # @dictionary.add( 'cosh',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # hyperbolic cosine
      # @dictionary.add( 'acosh',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # inverse hyperbolic cosine
      # @dictionary.add( 'tanh',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # hyperbolic tangent
      # @dictionary.add( 'atanh',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # inverse hyperbolic tangent

      # TIME AND DATE
      @dictionary.add( 'time',
                       proc { |stack, dictionary| Rpl::Lang::Core.time( stack, dictionary ) } )
      @dictionary.add( 'date',
                       proc { |stack, dictionary| Rpl::Lang::Core.date( stack, dictionary ) } )
      @dictionary.add( 'ticks',
                       proc { |stack, dictionary| Rpl::Lang::Core.ticks( stack, dictionary ) } )

      # Rpl.rb specifics
      # LISTS
      @dictionary.add( '->list',
                       proc { |stack, dictionary| Rpl::Lang::Core.to_list( stack, dictionary ) } )
      @dictionary.add( '→list',
                       proc { |stack, dictionary| Rpl::Lang::Core.to_list( stack, dictionary ) } ) # alias
      @dictionary.add( 'list->',
                       proc { |stack, dictionary| Rpl::Lang::Core.unpack_list( stack, dictionary ) } )
      @dictionary.add( 'list→',
                       proc { |stack, dictionary| Rpl::Lang::Core.unpack_list( stack, dictionary ) } ) # alias

      # FILESYSTEM
      @dictionary.add( 'fread',
                       proc { |stack, dictionary| Rpl::Lang::Core.fread( stack, dictionary ) } )
      @dictionary.add( 'feval',
                       proc { |stack, dictionary| Rpl::Lang::Core.feval( stack, dictionary ) } )
      @dictionary.add( 'fwrite',
                       proc { |stack, dictionary| Rpl::Lang::Core.fwrite( stack, dictionary ) } )

      # GRAPHICS
    end
  end
end
