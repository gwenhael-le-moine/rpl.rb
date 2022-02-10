# frozen_string_literal: true

require './lib/core'
require './lib/dictionary'

module Rpl
  class Interpreter
    attr_reader :stack,
                :dictionary # , :version

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
      @dictionary.add_word( ['nop'],
                            'General',
                            '( -- ) no operation',
                            proc { |stack, dictionary| Rpl::Lang::Core.nop( stack, dictionary ) } )
      @dictionary.add_word( ['help'],
                            'General',
                            '( w -- s ) pop help string of the given word',
                            proc { |stack, dictionary| Rpl::Lang::Core.help( stack, dictionary ) } )
      @dictionary.add_word( ['quit'],
                            'General',
                            '( -- ) Stop and quit interpreter',
                            proc { |stack, dictionary| } )
      @dictionary.add_word( ['version'],
                            'General',
                            '( -- n ) Pop the interpreter\'s version number',
                            proc { |stack, dictionary| Rpl::Lang::Core.version( stack, dictionary ) } )
      @dictionary.add_word( ['uname'],
                            'General',
                            '( -- s ) Pop the interpreter\'s complete indentification string',
                            proc { |stack, dictionary| Rpl::Lang::Core.uname( stack, dictionary ) } )
      @dictionary.add_word( ['history'],
                            'REPL',
                            '',
                            proc { |stack, dictionary| } )
      @dictionary.add_word( ['__ppstack'],
                            'REPL',
                            'DEBUG',
                            proc { |stack, dictionary| Rpl::Lang.__pp_stack( stack, dictionary ) } )

      # STACK
      @dictionary.add_word( ['swap'],
                            'Stack',
                            '( a b -- b a ) swap 2 first stack elements',
                            proc { |stack, dictionary| Rpl::Lang::Core.swap( stack, dictionary ) } )
      @dictionary.add_word( ['drop'],
                            'Stack',
                            '( a -- ) drop first stack element',
                            proc { |stack, dictionary| Rpl::Lang::Core.drop( stack, dictionary ) } )
      @dictionary.add_word( ['drop2'],
                            'Stack',
                            '( a b -- ) drop first two stack elements',
                            proc { |stack, dictionary| Rpl::Lang::Core.drop2( stack, dictionary ) } )
      @dictionary.add_word( ['dropn'],
                            'Stack',
                            '( a b … n -- ) drop first n stack elements',
                            proc { |stack, dictionary| Rpl::Lang::Core.dropn( stack, dictionary ) } )
      @dictionary.add_word( ['del'],
                            'Stack',
                            '( a b … -- ) drop all stack elements',
                            proc { |stack, dictionary| Rpl::Lang::Core.del( stack, dictionary ) } )
      @dictionary.add_word( ['rot'],
                            'Stack',
                            '( a b c -- b c a ) rotate 3 first stack elements',
                            proc { |stack, dictionary| Rpl::Lang::Core.rot( stack, dictionary ) } )
      @dictionary.add_word( ['dup'],
                            'Stack',
                            '( a -- a a ) duplicate first stack element',
                            proc { |stack, dictionary| Rpl::Lang::Core.dup( stack, dictionary ) } )
      @dictionary.add_word( ['dup2'],
                            'Stack',
                            '( a b -- a b a b ) duplicate first two stack elements',
                            proc { |stack, dictionary| Rpl::Lang::Core.dup2( stack, dictionary ) } )
      @dictionary.add_word( ['dupn'],
                            'Stack',
                            '( a b … n -- a b … a b … ) duplicate first n stack elements',
                            proc { |stack, dictionary| Rpl::Lang::Core.dupn( stack, dictionary ) } )
      @dictionary.add_word( ['pick'],
                            'Stack',
                            '( … b … n -- … b … b ) push a copy of the given stack level onto the stack',
                            proc { |stack, dictionary| Rpl::Lang::Core.pick( stack, dictionary ) } )
      @dictionary.add_word( ['depth'],
                            'Stack',
                            '( … -- … n ) push stack depth onto the stack',
                            proc { |stack, dictionary| Rpl::Lang::Core.depth( stack, dictionary ) } )
      @dictionary.add_word( ['roll'],
                            'Stack',
                            '( … a -- a … ) move a stack element to the top of the stack',
                            proc { |stack, dictionary| Rpl::Lang::Core.roll( stack, dictionary ) } )
      @dictionary.add_word( ['rolld'],
                            'Stack',
                            '( a … -- … a ) move the element on top of the stack to a higher stack position',
                            proc { |stack, dictionary| Rpl::Lang::Core.rolld( stack, dictionary ) } )
      @dictionary.add_word( ['over'],
                            'Stack',
                            '( a b -- a b a ) push a copy of the element in stack level 2 onto the stack',
                            proc { |stack, dictionary| Rpl::Lang::Core.over( stack, dictionary ) } )

      # Usual operations on reals and complexes
      @dictionary.add_word( ['+'],
                            'Usual operations on reals and complexes',
                            '( a b -- c ) addition',
                            proc { |stack, dictionary| Rpl::Lang::Core.add( stack, dictionary ) } )
      @dictionary.add_word( ['-'],
                            'Usual operations on reals and complexes',
                            '( a b -- c ) subtraction',
                            proc { |stack, dictionary| Rpl::Lang::Core.subtract( stack, dictionary ) } )
      @dictionary.add_word( ['chs'],
                            'Usual operations on reals and complexes',
                            '( a -- b ) negate',
                            proc { |stack, dictionary| Rpl::Lang::Core.negate( stack, dictionary ) } )
      @dictionary.add_word( ['×', '*'],
                            'Usual operations on reals and complexes',
                            '( a b -- c ) multiplication',
                            proc { |stack, dictionary| Rpl::Lang::Core.multiply( stack, dictionary ) } ) # alias
      @dictionary.add_word( ['÷', '/'],
                            'Usual operations on reals and complexes',
                            '( a b -- c ) division',
                            proc { |stack, dictionary| Rpl::Lang::Core.divide( stack, dictionary ) } ) # alias
      @dictionary.add_word( ['inv'],
                            'Usual operations on reals and complexes',
                            '( a -- b ) invert numeric',
                            proc { |stack, dictionary| Rpl::Lang::Core.inverse( stack, dictionary ) } )
      @dictionary.add_word( ['^'],
                            'Usual operations on reals and complexes',
                            '( a b -- c ) a to the power of b',
                            proc { |stack, dictionary| Rpl::Lang::Core.power( stack, dictionary ) } )
      @dictionary.add_word( ['√', 'sqrt'],
                            'Usual operations on reals and complexes',
                            '( a -- b ) square root',
                            proc { |stack, dictionary| Rpl::Lang::Core.sqrt( stack, dictionary ) } ) # alias
      @dictionary.add_word( ['²', 'sq'],
                            'Usual operations on reals and complexes',
                            '( a -- b ) square',
                            proc { |stack, dictionary| Rpl::Lang::Core.sq( stack, dictionary ) } )
      @dictionary.add_word( ['abs'],
                            'Usual operations on reals and complexes',
                            '( a -- b ) absolute value',
                            proc { |stack, dictionary| Rpl::Lang::Core.abs( stack, dictionary ) } )
      @dictionary.add_word( ['dec'],
                            'Usual operations on reals and complexes',
                            '( a -- a ) set numeric\'s base to 10',
                            proc { |stack, dictionary| Rpl::Lang::Core.dec( stack, dictionary ) } )
      @dictionary.add_word( ['hex'],
                            'Usual operations on reals and complexes',
                            '( a -- a ) set numeric\'s base to 16',
                            proc { |stack, dictionary| Rpl::Lang::Core.hex( stack, dictionary ) } )
      @dictionary.add_word( ['bin'],
                            'Usual operations on reals and complexes',
                            '( a -- a ) set numeric\'s base to 2',
                            proc { |stack, dictionary| Rpl::Lang::Core.bin( stack, dictionary ) } )
      @dictionary.add_word( ['base'],
                            'Usual operations on reals and complexes',
                            '( a b -- a ) set numeric\'s base to b',
                            proc { |stack, dictionary| Rpl::Lang::Core.base( stack, dictionary ) } )
      @dictionary.add_word( ['sign'],
                            'Usual operations on reals and complexes',
                            '( a -- b ) sign of element',
                            proc { |stack, dictionary| Rpl::Lang::Core.sign( stack, dictionary ) } )

      # Operations on reals
      @dictionary.add_word( ['%'],
                            'Operations on reals',
                            '( a b -- c ) b% of a',
                            proc { |stack, dictionary| Rpl::Lang::Core.percent( stack, dictionary ) } )
      @dictionary.add_word( ['%CH'],
                            'Operations on reals',
                            '( a b -- c ) b is c% of a',
                            proc { |stack, dictionary| Rpl::Lang::Core.inverse_percent( stack, dictionary ) } )
      @dictionary.add_word( ['mod'],
                            'Operations on reals',
                            '( a b -- c ) modulo',
                            proc { |stack, dictionary| Rpl::Lang::Core.mod( stack, dictionary ) } )
      @dictionary.add_word( ['!', 'fact'],
                            'Operations on reals',
                            '( a -- b ) factorial',
                            proc { |stack, dictionary| Rpl::Lang::Core.fact( stack, dictionary ) } )
      @dictionary.add_word( ['floor'],
                            'Operations on reals',
                            '( a -- b ) highest integer under a',
                            proc { |stack, dictionary| Rpl::Lang::Core.floor( stack, dictionary ) } )
      @dictionary.add_word( ['ceil'],
                            'Operations on reals',
                            '( a -- b ) highest integer over a',
                            proc { |stack, dictionary| Rpl::Lang::Core.ceil( stack, dictionary ) } )
      @dictionary.add_word( ['min'],
                            'Operations on reals',
                            '( a b -- a/b ) leave lowest of a or b',
                            proc { |stack, dictionary| Rpl::Lang::Core.min( stack, dictionary ) } )
      @dictionary.add_word( ['max'],
                            'Operations on reals',
                            '( a b -- a/b ) leave highest of a or b',
                            proc { |stack, dictionary| Rpl::Lang::Core.max( stack, dictionary ) } )
      # @dictionary.add_word( ['mant'],
      # 'Operations on reals',
      # '',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # mantissa of a real number
      # @dictionary.add_word( ['xpon'],
      # 'Operations on reals',
      # '',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exponant of a real number
      # @dictionary.add_word( ['ip'],
      # 'Operations on reals',
      # '',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # integer part
      # @dictionary.add_word( ['fp'],
      # 'Operations on reals',
      # '',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # fractional part

      # OPERATIONS ON COMPLEXES
      # @dictionary.add_word( ['re'],
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # complex real part
      # @dictionary.add_word( 'im',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # complex imaginary part
      # @dictionary.add_word( ['conj'],
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # complex conjugate
      # @dictionary.add_word( 'arg',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # complex argument in radians
      # @dictionary.add_word( ['c->r'],
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # transform a complex in 2 reals
      # @dictionary.add_word( 'c→r',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias
      # @dictionary.add_word( ['r->c'],
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # transform 2 reals in a complex
      # @dictionary.add_word( 'r→c',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias
      # @dictionary.add_word( ['p->r'],
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # cartesian to polar
      # @dictionary.add_word( 'p→r',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias
      # @dictionary.add_word( ['r->p'],
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # polar to cartesian
      # @dictionary.add_word( 'r→p',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias

      # Mode
      @dictionary.add_word( ['prec'],
                            'Mode',
                            '( a -- ) set precision to a',
                            proc { |stack, dictionary| Rpl::Lang::Core.prec( stack, dictionary ) } )
      @dictionary.add_word( ['default'],
                            'Mode',
                            '( -- ) set default precision',
                            proc { |stack, dictionary| Rpl::Lang::Core.default( stack, dictionary ) } )
      @dictionary.add_word( ['type'],
                            'Mode',
                            '( a -- s ) type of a as a string',
                            proc { |stack, dictionary| Rpl::Lang::Core.type( stack, dictionary ) } )
      # @dictionary.add_word( ['std'],
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # standard floating numbers representation. ex: std
      # @dictionary.add_word( ['fix'],
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # fixed point representation. ex: 6 fix
      # @dictionary.add_word( ['sci'],
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # scientific floating point representation. ex: 20 sci
      # @dictionary.add_word( ['round'],
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # set float rounding mode. ex: ["nearest", "toward zero", "toward +inf", "toward -inf", "away from zero"] round

      # Test
      @dictionary.add_word( ['>'],
                            'Test',
                            '( a b -- t ) is a greater than b?',
                            proc { |stack, dictionary| Rpl::Lang::Core.greater_than( stack, dictionary ) } )
      @dictionary.add_word( ['≥', '>='],
                            'Test',
                            '( a b -- t ) is a greater than or equal to b?',
                            proc { |stack, dictionary| Rpl::Lang::Core.greater_than_or_equal( stack, dictionary ) } ) # alias
      @dictionary.add_word( ['<'],
                            'Test',
                            '( a b -- t ) is a less than b?',
                            proc { |stack, dictionary| Rpl::Lang::Core.less_than( stack, dictionary ) } )
      @dictionary.add_word( ['≤', '<='],
                            'Test',
                            '( a b -- t ) is a less than or equal to b?',
                            proc { |stack, dictionary| Rpl::Lang::Core.less_than_or_equal( stack, dictionary ) } ) # alias
      @dictionary.add_word( ['≠', '!='],
                            'Test',
                            '( a b -- t ) is a not equal to b',
                            proc { |stack, dictionary| Rpl::Lang::Core.different( stack, dictionary ) } ) # alias
      @dictionary.add_word( ['==', 'same'],
                            'Test',
                            '( a b -- t ) is a equal to b',
                            proc { |stack, dictionary| Rpl::Lang::Core.same( stack, dictionary ) } )
      @dictionary.add_word( ['and'],
                            'Test',
                            '( a b -- t ) boolean and',
                            proc { |stack, dictionary| Rpl::Lang::Core.and( stack, dictionary ) } )
      @dictionary.add_word( ['or'],
                            'Test',
                            '( a b -- t ) boolean or',
                            proc { |stack, dictionary| Rpl::Lang::Core.or( stack, dictionary ) } )
      @dictionary.add_word( ['xor'],
                            'Test',
                            '( a b -- t ) boolean xor',
                            proc { |stack, dictionary| Rpl::Lang::Core.xor( stack, dictionary ) } )
      @dictionary.add_word( ['not'],
                            'Test',
                            '( a -- t ) invert boolean value',
                            proc { |stack, dictionary| Rpl::Lang::Core.not( stack, dictionary ) } )
      @dictionary.add_word( ['true'],
                            'Test',
                            '( -- t ) push true onto stack',
                            proc { |stack, dictionary| Rpl::Lang::Core.true( stack, dictionary ) } ) # specific
      @dictionary.add_word( ['false'],
                            'Test',
                            '( -- t ) push false onto stack',
                            proc { |stack, dictionary| Rpl::Lang::Core.false( stack, dictionary ) } ) # specific

      # String
      @dictionary.add_word( ['→str', '->str'],
                            'String',
                            '( a -- s ) convert element to string',
                            proc { |stack, dictionary| Rpl::Lang::Core.to_string( stack, dictionary ) } ) # alias
      @dictionary.add_word( ['str→', 'str->'],
                            'String',
                            '( s -- a ) convert string to element',
                            proc { |stack, dictionary| Rpl::Lang::Core.from_string( stack, dictionary ) } )
      @dictionary.add_word( ['chr'],
                            'String',
                            '( n -- c ) convert ASCII character code in stack level 1 into a string',
                            proc { |stack, dictionary| Rpl::Lang::Core.chr( stack, dictionary ) } )
      @dictionary.add_word( ['num'],
                            'String',
                            '( s -- n ) return ASCII code of the first character of the string in stack level 1 as a real number',
                            proc { |stack, dictionary| Rpl::Lang::Core.num( stack, dictionary ) } )
      @dictionary.add_word( ['size'],
                            'String',
                            '( s -- n ) return the length of the string',
                            proc { |stack, dictionary| Rpl::Lang::Core.size( stack, dictionary ) } )
      @dictionary.add_word( ['pos'],
                            'String',
                            '( s s -- n ) search for the string in level 1 within the string in level 2',
                            proc { |stack, dictionary| Rpl::Lang::Core.pos( stack, dictionary ) } )
      @dictionary.add_word( ['sub'],
                            'String',
                            '( s n n -- s ) return a substring of the string in level 3',
                            proc { |stack, dictionary| Rpl::Lang::Core.sub( stack, dictionary ) } )
      @dictionary.add_word( ['rev'],
                            'String',
                            '( s -- s ) reverse string',
                            proc { |stack, dictionary| Rpl::Lang::Core.rev( stack, dictionary ) } ) # specific
      @dictionary.add_word( ['split'],
                            'String',
                            '( s c -- … ) split string s on character c',
                            proc { |stack, dictionary| Rpl::Lang::Core.split( stack, dictionary ) } ) # specific

      # Branch
      @dictionary.add_word( ['ift'],
                            'Branch',
                            '( t pt -- … ) eval pt or not based on the value of boolean t',
                            proc { |stack, dictionary| Rpl::Lang::Core.ift( stack, dictionary ) } )
      @dictionary.add_word( ['ifte'],
                            'Branch',
                            '( t pt pf -- … ) eval pt or pf based on the value of boolean t',
                            proc { |stack, dictionary| Rpl::Lang::Core.ifte( stack, dictionary ) } )
      @dictionary.add_word( ['times'],
                            'Branch',
                            '( n p -- … ) eval p n times while pushing counter on stack before',
                            proc { |stack, dictionary| Rpl::Lang::Core.times( stack, dictionary ) } ) # specific
      @dictionary.add_word( ['loop'],
                            'Branch',
                            '( n1 n2 p -- … ) eval p looping from n1 to n2 while pushing counter on stack before',
                            proc { |stack, dictionary| Rpl::Lang::Core.loop( stack, dictionary ) } ) # specific
      # @dictionary.add_word( 'if',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # if <test-instruction> then <true-instructions> else <false-instructions> end
      # @dictionary.add_word( 'then',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with if
      # @dictionary.add_word( 'else',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with if
      # @dictionary.add_word( 'end',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with various branch instructions
      # @dictionary.add_word( 'start',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # <start> <end> start <instructions> next|<step> step
      # @dictionary.add_word( 'for',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # <start> <end> for <variable> <instructions> next|<step> step
      # @dictionary.add_word( 'next',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with start and for
      # @dictionary.add_word( 'step',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with start and for
      # @dictionary.add_word( 'do',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # do <instructions> until <condition> end
      # @dictionary.add_word( 'until',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with do
      # @dictionary.add_word( 'while',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # while <test-instruction> repeat <loop-instructions> end
      # @dictionary.add_word( 'repeat',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with while

      # Store
      @dictionary.add_word( ['▶', 'sto'],
                            'Store',
                            '',
                            proc { |stack, dictionary| Rpl::Lang::Core.sto( stack, dictionary ) } )
      @dictionary.add_word( ['rcl'],
                            'Store',
                            '',
                            proc { |stack, dictionary| Rpl::Lang::Core.rcl( stack, dictionary ) } )
      @dictionary.add_word( ['purge'],
                            'Store',
                            '',
                            proc { |stack, dictionary| Rpl::Lang::Core.purge( stack, dictionary ) } )
      @dictionary.add_word( ['vars'],
                            'Store',
                            '',
                            proc { |stack, dictionary| Rpl::Lang::Core.vars( stack, dictionary ) } )
      @dictionary.add_word( ['clusr'],
                            'Store',
                            '',
                            proc { |stack, dictionary| Rpl::Lang::Core.clusr( stack, dictionary ) } )
      @dictionary.add_word( ['sto+'],
                            'Store',
                            '',
                            proc { |stack, dictionary| Rpl::Lang::Core.sto_add( stack, dictionary ) } )
      @dictionary.add_word( ['sto-'],
                            'Store',
                            '',
                            proc { |stack, dictionary| Rpl::Lang::Core.sto_subtract( stack, dictionary ) } )
      @dictionary.add_word( ['sto×', 'sto*'],
                            'Store',
                            '',
                            proc { |stack, dictionary| Rpl::Lang::Core.sto_multiply( stack, dictionary ) } ) # alias
      @dictionary.add_word( ['sto÷', 'sto/'],
                            'Store',
                            '',
                            proc { |stack, dictionary| Rpl::Lang::Core.sto_divide( stack, dictionary ) } ) # alias
      @dictionary.add_word( ['sneg'],
                            'Store',
                            '',
                            proc { |stack, dictionary| Rpl::Lang::Core.sto_negate( stack, dictionary ) } )
      @dictionary.add_word( ['sinv'],
                            'Store',
                            '',
                            proc { |stack, dictionary| Rpl::Lang::Core.sto_inverse( stack, dictionary ) } )
      # @dictionary.add_word( 'edit',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # edit a variable content
      @dictionary.add_word( ['↴', 'lsto'],
                            'Store',
                            '',
                            proc { |stack, dictionary| Rpl::Lang::Core.lsto( stack, dictionary ) } ) # store to local variable

      # Program
      @dictionary.add_word( ['eval'],
                            'Program',
                            '',
                            proc { |stack, dictionary| Rpl::Lang::Core.eval( stack, dictionary ) } )
      # @dictionary.add_word( '->',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # load program local variables. ex: « → n m « 0 n m for i i + next » »
      # @dictionary.add_word( '→',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias

      # Trig on reals and complexes
      @dictionary.add_word( ['𝛑', 'pi'],
                            'Trig on reals and complexes',
                            '( … -- 𝛑 ) push 𝛑',
                            proc { |stack, dictionary| Rpl::Lang::Core.pi( stack, dictionary ) } )
      @dictionary.add_word( ['sin'],
                            'Trig on reals and complexes',
                            '( n -- m ) compute sinus of n',
                            proc { |stack, dictionary| Rpl::Lang::Core.sinus( stack, dictionary ) } ) # sinus
      @dictionary.add_word( ['asin'],
                            'Trig on reals and complexes',
                            '( n -- m ) compute arg-sinus of n',
                            proc { |stack, dictionary| Rpl::Lang::Core.arg_sinus( stack, dictionary ) } ) # arg sinus
      @dictionary.add_word( ['cos'],
                            'Trig on reals and complexes',
                            '( n -- m ) compute cosinus of n',
                            proc { |stack, dictionary| Rpl::Lang::Core.cosinus( stack, dictionary ) } ) # cosinus
      @dictionary.add_word( ['acos'],
                            'Trig on reals and complexes',
                            '( n -- m ) compute arg-cosinus of n',
                            proc { |stack, dictionary| Rpl::Lang::Core.arg_cosinus( stack, dictionary ) } ) # arg cosinus
      @dictionary.add_word( ['tan'],
                            'Trig on reals and complexes',
                            '( n -- m ) compute tangent of n',
                            proc { |stack, dictionary| Rpl::Lang::Core.tangent( stack, dictionary ) } ) # tangent
      @dictionary.add_word( ['atan'],
                            'Trig on reals and complexes',
                            '( n -- m ) compute arc-tangent of n',
                            proc { |stack, dictionary| Rpl::Lang::Core.arg_tangent( stack, dictionary ) } ) # arg tangent
      @dictionary.add_word( ['d→r', 'd->r'],
                            'Trig on reals and complexes',
                            '( n -- m ) convert degree to radian',
                            proc { |stack, dictionary| Rpl::Lang::Core.degrees_to_radians( stack, dictionary ) } ) # convert degrees to radians
      @dictionary.add_word( ['r→d', 'r->d'],
                            'Trig on reals and complexes',
                            '( n -- m ) convert radian to degree',
                            proc { |stack, dictionary| Rpl::Lang::Core.radians_to_degrees( stack, dictionary ) } ) # convert radians to degrees

      # Logs on reals and complexes
      @dictionary.add_word( ['ℇ', 'e'],
                            'Logs on reals and complexes',
                            '( … -- ℇ ) push ℇ',
                            proc { |stack, dictionary| Rpl::Lang::Core.e( stack, dictionary ) } ) # alias
      # @dictionary.add_word( 'ln',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # logarithm base e
      # @dictionary.add_word( 'lnp1',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # ln(1+x) which is useful when x is close to 0
      # @dictionary.add_word( 'exp',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exponential
      # @dictionary.add_word( 'expm',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exp(x)-1 which is useful when x is close to 0
      # @dictionary.add_word( 'log10',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # logarithm base 10
      # @dictionary.add_word( 'alog10',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exponential base 10
      # @dictionary.add_word( 'log2',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # logarithm base 2
      # @dictionary.add_word( 'alog2',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exponential base 2
      # @dictionary.add_word( 'sinh',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # hyperbolic sine
      # @dictionary.add_word( 'asinh',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # inverse hyperbolic sine
      # @dictionary.add_word( 'cosh',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # hyperbolic cosine
      # @dictionary.add_word( 'acosh',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # inverse hyperbolic cosine
      # @dictionary.add_word( 'tanh',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # hyperbolic tangent
      # @dictionary.add_word( 'atanh',
      #                  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # inverse hyperbolic tangent

      # Time and date
      @dictionary.add_word( ['time'],
                            'Time and date',
                            '( -- t ) push current time',
                            proc { |stack, dictionary| Rpl::Lang::Core.time( stack, dictionary ) } )
      @dictionary.add_word( ['date'],
                            'Time and date',
                            '( -- d ) push current date',
                            proc { |stack, dictionary| Rpl::Lang::Core.date( stack, dictionary ) } )
      @dictionary.add_word( ['ticks'],
                            'Time and date',
                            '( -- t ) push datetime as ticks',
                            proc { |stack, dictionary| Rpl::Lang::Core.ticks( stack, dictionary ) } )

      # Rpl.rb specifics
      # Lists
      @dictionary.add_word( ['→list', '->list'],
                            'Lists',
                            '( … x -- […] ) pack x stacks levels into a list',
                            proc { |stack, dictionary| Rpl::Lang::Core.to_list( stack, dictionary ) } )
      @dictionary.add_word( ['list→', 'list->'],
                            'Lists',
                            '( […] -- … ) unpack list on stack',
                            proc { |stack, dictionary| Rpl::Lang::Core.unpack_list( stack, dictionary ) } )

      # Filesystem
      @dictionary.add_word( ['fread'],
                            'Filesystem',
                            '( filename -- content ) read file and put content on stack as string',
                            proc { |stack, dictionary| Rpl::Lang::Core.fread( stack, dictionary ) } )
      @dictionary.add_word( ['feval'],
                            'Filesystem',
                            '( filename -- … ) read and run file',
                            proc { |stack, dictionary| Rpl::Lang::Core.feval( stack, dictionary ) } )
      @dictionary.add_word( ['fwrite'],
                            'Filesystem',
                            '( content filename -- ) write content into filename',
                            proc { |stack, dictionary| Rpl::Lang::Core.fwrite( stack, dictionary ) } )

      # Graphics
    end
  end
end
