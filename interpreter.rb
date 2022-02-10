# frozen_string_literal: true

require 'bigdecimal/math'

require_relative './lib/dictionary'

require_relative './lib/core/branch'
require_relative './lib/core/general'
require_relative './lib/core/mode'
require_relative './lib/core/operations'
require_relative './lib/core/program'
require_relative './lib/core/stack'
require_relative './lib/core/store'
require_relative './lib/core/string'
require_relative './lib/core/test'
require_relative './lib/core/time-date'
require_relative './lib/core/trig'
require_relative './lib/core/logs'
require_relative './lib/core/filesystem'
require_relative './lib/core/list'

module Rpl
  class Interpreter
    include BigMath

    include Rpl::Lang::Core

    attr_reader :stack,
                :dictionary,
                :version

    attr_accessor :precision

    def initialize( stack = [], dictionary = Rpl::Lang::Dictionary.new )
      @version = 0.1

      @precision = default_precision

      @dictionary = dictionary
      @stack = stack

      populate_dictionary if @dictionary.words.empty?
    end

    def default_precision
      12
    end

    def parse( input )
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

          parsed_entry[:value] = BigDecimal( parsed_entry[:value], @precision )
        end

        parsed_tree << parsed_entry
      end

      parsed_tree
    end

    def run( input )
      @dictionary.add_local_vars_layer

      parse( input.to_s ).each do |elt|
        case elt[:type]
        when :word
          break if %w[break quit exit].include?( elt[:value] )

          command = @dictionary.lookup( elt[:value] )

          if command.nil?
            # if there isn't a command by that name then it's a name
            elt[:type] = :name

            @stack << elt
          elsif command.is_a?( Proc )
            command.call
          else
            run( command[:value] )
          end
        else
          @stack << elt
        end
      end

      @dictionary.remove_local_vars_layer

      # superfluous but feels nice
      @stack
    end

    def stack_extract( needs )
      raise ArgumentError, 'Not enough elements' if @stack.size < needs.size

      args = []
      needs.each do |need|
        raise ArgumentError, "Type Error, needed #{need} got #{elt[:type]}" unless need == :any || need.include?( @stack.last[:type] )

        args << @stack.pop
      end

      args
    end

    def stringify( elt )
      case elt[:type]
      when :numeric
        prefix = case elt[:base]
                 when 2
                   '0b'
                 when 8
                   '0o'
                 when 10
                   ''
                 when 16
                   '0x'
                 else
                   "0#{elt[:base]}_"
                 end

        if elt[:value].infinite?
          suffix = elt[:value].infinite?.positive? ? '∞' : '-∞'
        elsif elt[:value].nan?
          suffix = '<NaN>'
        else
          suffix = if elt[:value].to_i == elt[:value]
                     elt[:value].to_i
                   else
                     elt[:value].to_s('F')
                   end
          suffix = elt[:value].to_s( elt[:base] ) unless elt[:base] == 10
        end

        "#{prefix}#{suffix}"
      when :list
        "[#{elt[:value].map { |e| stringify( e ) }.join(', ')}]"
      when :program
        "« #{elt[:value]} »"
      when :string
        "\"#{elt[:value]}\""
      when :name
        "'#{elt[:value]}'"
      else
        elt[:value]
      end
    end

    def infer_resulting_base( numerics )
      10 if numerics.length.zero?

      numerics.last[:base]
    end

    def populate_dictionary
      # GENERAL
      @dictionary.add_word( ['nop'],
                            'General',
                            '( -- ) no operation',
                            proc { nop } )
      @dictionary.add_word( ['help'],
                            'General',
                            '( w -- s ) pop help string of the given word',
                            proc { help } )
      @dictionary.add_word( ['quit'],
                            'General',
                            '( -- ) Stop and quit interpreter',
                            proc {} )
      @dictionary.add_word( ['version'],
                            'General',
                            '( -- n ) Pop the interpreter\'s version number',
                            proc { version } )
      @dictionary.add_word( ['uname'],
                            'General',
                            '( -- s ) Pop the interpreter\'s complete indentification string',
                            proc { uname } )
      @dictionary.add_word( ['history'],
                            'REPL',
                            '',
                            proc {} )
      @dictionary.add_word( ['.s'],
                            'REPL',
                            'DEBUG',
                            proc { pp @stack } )

      # STACK
      @dictionary.add_word( ['swap'],
                            'Stack',
                            '( a b -- b a ) swap 2 first stack elements',
                            proc { swap } )
      @dictionary.add_word( ['drop'],
                            'Stack',
                            '( a -- ) drop first stack element',
                            proc { drop } )
      @dictionary.add_word( ['drop2'],
                            'Stack',
                            '( a b -- ) drop first two stack elements',
                            proc { drop2 } )
      @dictionary.add_word( ['dropn'],
                            'Stack',
                            '( a b … n -- ) drop first n stack elements',
                            proc { dropn } )
      @dictionary.add_word( ['del'],
                            'Stack',
                            '( a b … -- ) drop all stack elements',
                            proc { del } )
      @dictionary.add_word( ['rot'],
                            'Stack',
                            '( a b c -- b c a ) rotate 3 first stack elements',
                            proc { rot } )
      @dictionary.add_word( ['dup'],
                            'Stack',
                            '( a -- a a ) duplicate first stack element',
                            proc { dup } )
      @dictionary.add_word( ['dup2'],
                            'Stack',
                            '( a b -- a b a b ) duplicate first two stack elements',
                            proc { dup2 } )
      @dictionary.add_word( ['dupn'],
                            'Stack',
                            '( a b … n -- a b … a b … ) duplicate first n stack elements',
                            proc { dupn } )
      @dictionary.add_word( ['pick'],
                            'Stack',
                            '( … b … n -- … b … b ) push a copy of the given stack level onto the stack',
                            proc { pick } )
      @dictionary.add_word( ['depth'],
                            'Stack',
                            '( … -- … n ) push stack depth onto the stack',
                            proc { depth } )
      @dictionary.add_word( ['roll'],
                            'Stack',
                            '( … a -- a … ) move a stack element to the top of the stack',
                            proc { roll } )
      @dictionary.add_word( ['rolld'],
                            'Stack',
                            '( a … -- … a ) move the element on top of the stack to a higher stack position',
                            proc { rolld } )
      @dictionary.add_word( ['over'],
                            'Stack',
                            '( a b -- a b a ) push a copy of the element in stack level 2 onto the stack',
                            proc { over } )

      # Usual operations on reals and complexes
      @dictionary.add_word( ['+'],
                            'Usual operations on reals and complexes',
                            '( a b -- c ) addition',
                            proc { add } )
      @dictionary.add_word( ['-'],
                            'Usual operations on reals and complexes',
                            '( a b -- c ) subtraction',
                            proc { subtract } )
      @dictionary.add_word( ['chs'],
                            'Usual operations on reals and complexes',
                            '( a -- b ) negate',
                            proc { negate } )
      @dictionary.add_word( ['×', '*'],
                            'Usual operations on reals and complexes',
                            '( a b -- c ) multiplication',
                            proc { multiply } ) # alias
      @dictionary.add_word( ['÷', '/'],
                            'Usual operations on reals and complexes',
                            '( a b -- c ) division',
                            proc { divide } ) # alias
      @dictionary.add_word( ['inv'],
                            'Usual operations on reals and complexes',
                            '( a -- b ) invert numeric',
                            proc { inverse } )
      @dictionary.add_word( ['^'],
                            'Usual operations on reals and complexes',
                            '( a b -- c ) a to the power of b',
                            proc { power } )
      @dictionary.add_word( ['√', 'sqrt'],
                            'Usual operations on reals and complexes',
                            '( a -- b ) square root',
                            proc { sqrt } ) # alias
      @dictionary.add_word( ['²', 'sq'],
                            'Usual operations on reals and complexes',
                            '( a -- b ) square',
                            proc { sq } )
      @dictionary.add_word( ['abs'],
                            'Usual operations on reals and complexes',
                            '( a -- b ) absolute value',
                            proc { abs } )
      @dictionary.add_word( ['dec'],
                            'Usual operations on reals and complexes',
                            '( a -- a ) set numeric\'s base to 10',
                            proc { dec } )
      @dictionary.add_word( ['hex'],
                            'Usual operations on reals and complexes',
                            '( a -- a ) set numeric\'s base to 16',
                            proc { hex } )
      @dictionary.add_word( ['bin'],
                            'Usual operations on reals and complexes',
                            '( a -- a ) set numeric\'s base to 2',
                            proc { bin } )
      @dictionary.add_word( ['base'],
                            'Usual operations on reals and complexes',
                            '( a b -- a ) set numeric\'s base to b',
                            proc { base } )
      @dictionary.add_word( ['sign'],
                            'Usual operations on reals and complexes',
                            '( a -- b ) sign of element',
                            proc { sign } )

      # Operations on reals
      @dictionary.add_word( ['%'],
                            'Operations on reals',
                            '( a b -- c ) b% of a',
                            proc { percent } )
      @dictionary.add_word( ['%CH'],
                            'Operations on reals',
                            '( a b -- c ) b is c% of a',
                            proc { inverse_percent } )
      @dictionary.add_word( ['mod'],
                            'Operations on reals',
                            '( a b -- c ) modulo',
                            proc { mod } )
      @dictionary.add_word( ['!', 'fact'],
                            'Operations on reals',
                            '( a -- b ) factorial',
                            proc { fact } )
      @dictionary.add_word( ['floor'],
                            'Operations on reals',
                            '( a -- b ) highest integer under a',
                            proc { floor } )
      @dictionary.add_word( ['ceil'],
                            'Operations on reals',
                            '( a -- b ) highest integer over a',
                            proc { ceil } )
      @dictionary.add_word( ['min'],
                            'Operations on reals',
                            '( a b -- a/b ) leave lowest of a or b',
                            proc { min } )
      @dictionary.add_word( ['max'],
                            'Operations on reals',
                            '( a b -- a/b ) leave highest of a or b',
                            proc { max } )
      # @dictionary.add_word( ['mant'],
      # 'Operations on reals',
      # '',
      #                  proc { __todo } ) # mantissa of a real number
      # @dictionary.add_word( ['xpon'],
      # 'Operations on reals',
      # '',
      #                  proc { __todo } ) # exponant of a real number
      # @dictionary.add_word( ['ip'],
      # 'Operations on reals',
      # '',
      #                  proc { __todo } ) # integer part
      # @dictionary.add_word( ['fp'],
      # 'Operations on reals',
      # '',
      #                  proc { __todo } ) # fractional part

      # OPERATIONS ON COMPLEXES
      # @dictionary.add_word( ['re'],
      #                  proc { __todo } ) # complex real part
      # @dictionary.add_word( 'im',
      #                  proc { __todo } ) # complex imaginary part
      # @dictionary.add_word( ['conj'],
      #                  proc { __todo } ) # complex conjugate
      # @dictionary.add_word( 'arg',
      #                  proc { __todo } ) # complex argument in radians
      # @dictionary.add_word( ['c->r'],
      #                  proc { __todo } ) # transform a complex in 2 reals
      # @dictionary.add_word( 'c→r',
      #                  proc { __todo } ) # alias
      # @dictionary.add_word( ['r->c'],
      #                  proc { __todo } ) # transform 2 reals in a complex
      # @dictionary.add_word( 'r→c',
      #                  proc { __todo } ) # alias
      # @dictionary.add_word( ['p->r'],
      #                  proc { __todo } ) # cartesian to polar
      # @dictionary.add_word( 'p→r',
      #                  proc { __todo } ) # alias
      # @dictionary.add_word( ['r->p'],
      #                  proc { __todo } ) # polar to cartesian
      # @dictionary.add_word( 'r→p',
      #                  proc { __todo } ) # alias

      # Mode
      @dictionary.add_word( ['prec'],
                            'Mode',
                            '( a -- ) set precision to a',
                            proc { prec } )
      @dictionary.add_word( ['default'],
                            'Mode',
                            '( -- ) set default precision',
                            proc { default } )
      @dictionary.add_word( ['type'],
                            'Mode',
                            '( a -- s ) type of a as a string',
                            proc { type } )
      # @dictionary.add_word( ['std'],
      #                  proc { __todo } ) # standard floating numbers representation. ex: std
      # @dictionary.add_word( ['fix'],
      #                  proc { __todo } ) # fixed point representation. ex: 6 fix
      # @dictionary.add_word( ['sci'],
      #                  proc { __todo } ) # scientific floating point representation. ex: 20 sci
      # @dictionary.add_word( ['round'],
      #                  proc { __todo } ) # set float rounding mode. ex: ["nearest", "toward zero", "toward +inf", "toward -inf", "away from zero"] round

      # Test
      @dictionary.add_word( ['>'],
                            'Test',
                            '( a b -- t ) is a greater than b?',
                            proc { greater_than } )
      @dictionary.add_word( ['≥', '>='],
                            'Test',
                            '( a b -- t ) is a greater than or equal to b?',
                            proc { greater_than_or_equal } ) # alias
      @dictionary.add_word( ['<'],
                            'Test',
                            '( a b -- t ) is a less than b?',
                            proc { less_than } )
      @dictionary.add_word( ['≤', '<='],
                            'Test',
                            '( a b -- t ) is a less than or equal to b?',
                            proc { less_than_or_equal } ) # alias
      @dictionary.add_word( ['≠', '!='],
                            'Test',
                            '( a b -- t ) is a not equal to b',
                            proc { different } ) # alias
      @dictionary.add_word( ['==', 'same'],
                            'Test',
                            '( a b -- t ) is a equal to b',
                            proc { same } )
      @dictionary.add_word( ['and'],
                            'Test',
                            '( a b -- t ) boolean and',
                            proc { boolean_and } )
      @dictionary.add_word( ['or'],
                            'Test',
                            '( a b -- t ) boolean or',
                            proc { boolean_or } )
      @dictionary.add_word( ['xor'],
                            'Test',
                            '( a b -- t ) boolean xor',
                            proc { xor } )
      @dictionary.add_word( ['not'],
                            'Test',
                            '( a -- t ) invert boolean value',
                            proc { boolean_not } )
      @dictionary.add_word( ['true'],
                            'Test',
                            '( -- t ) push true onto stack',
                            proc { boolean_true } ) # specific
      @dictionary.add_word( ['false'],
                            'Test',
                            '( -- t ) push false onto stack',
                            proc { boolean_false } ) # specific

      # String
      @dictionary.add_word( ['→str', '->str'],
                            'String',
                            '( a -- s ) convert element to string',
                            proc { to_string } ) # alias
      @dictionary.add_word( ['str→', 'str->'],
                            'String',
                            '( s -- a ) convert string to element',
                            proc { from_string } )
      @dictionary.add_word( ['chr'],
                            'String',
                            '( n -- c ) convert ASCII character code in stack level 1 into a string',
                            proc { chr } )
      @dictionary.add_word( ['num'],
                            'String',
                            '( s -- n ) return ASCII code of the first character of the string in stack level 1 as a real number',
                            proc { num } )
      @dictionary.add_word( ['size'],
                            'String',
                            '( s -- n ) return the length of the string',
                            proc { size } )
      @dictionary.add_word( ['pos'],
                            'String',
                            '( s s -- n ) search for the string in level 1 within the string in level 2',
                            proc { pos } )
      @dictionary.add_word( ['sub'],
                            'String',
                            '( s n n -- s ) return a substring of the string in level 3',
                            proc { sub } )
      @dictionary.add_word( ['rev'],
                            'String',
                            '( s -- s ) reverse string',
                            proc { rev } ) # specific
      @dictionary.add_word( ['split'],
                            'String',
                            '( s c -- … ) split string s on character c',
                            proc { split } ) # specific

      # Branch
      @dictionary.add_word( ['ift'],
                            'Branch',
                            '( t pt -- … ) eval pt or not based on the value of boolean t',
                            proc { ift } )
      @dictionary.add_word( ['ifte'],
                            'Branch',
                            '( t pt pf -- … ) eval pt or pf based on the value of boolean t',
                            proc { ifte } )
      @dictionary.add_word( ['times'],
                            'Branch',
                            '( n p -- … ) eval p n times while pushing counter on stack before',
                            proc { times } ) # specific
      @dictionary.add_word( ['loop'],
                            'Branch',
                            '( n1 n2 p -- … ) eval p looping from n1 to n2 while pushing counter on stack before',
                            proc { loop } ) # specific

      # Store
      @dictionary.add_word( ['▶', 'sto'],
                            'Store',
                            '( content name -- ) store to variable',
                            proc { sto } )
      @dictionary.add_word( ['rcl'],
                            'Store',
                            '( name -- … ) push content of variable name onto stack',
                            proc { rcl } )
      @dictionary.add_word( ['purge'],
                            'Store',
                            '( name -- ) delete variable',
                            proc { purge } )
      @dictionary.add_word( ['vars'],
                            'Store',
                            '( -- […] ) list variables',
                            proc { vars } )
      @dictionary.add_word( ['clusr'],
                            'Store',
                            '( -- ) delete all variables',
                            proc { clusr } )
      @dictionary.add_word( ['sto+'],
                            'Store',
                            '( a n -- ) add content to variable\'s value',
                            proc { sto_add } )
      @dictionary.add_word( ['sto-'],
                            'Store',
                            '( a n -- ) subtract content to variable\'s value',
                            proc { sto_subtract } )
      @dictionary.add_word( ['sto×', 'sto*'],
                            'Store',
                            '( a n -- ) multiply content of variable\'s value',
                            proc { sto_multiply } ) # alias
      @dictionary.add_word( ['sto÷', 'sto/'],
                            'Store',
                            '( a n -- ) divide content of variable\'s value',
                            proc { sto_divide } ) # alias
      @dictionary.add_word( ['sneg'],
                            'Store',
                            '( a n -- ) negate content of variable\'s value',
                            proc { sto_negate } )
      @dictionary.add_word( ['sinv'],
                            'Store',
                            '( a n -- ) invert content of variable\'s value',
                            proc { sto_inverse } )
      @dictionary.add_word( ['↴', 'lsto'],
                            'Program',
                            '( content name -- ) store to local variable',
                            proc { lsto } )

      # Program
      @dictionary.add_word( ['eval'],
                            'Program',
                            '( a -- … ) interpret',
                            proc { eval } )

      # Trig on reals and complexes
      @dictionary.add_word( ['𝛑', 'pi'],
                            'Trig on reals and complexes',
                            '( … -- 𝛑 ) push 𝛑',
                            proc { pi } )
      @dictionary.add_word( ['sin'],
                            'Trig on reals and complexes',
                            '( n -- m ) compute sinus of n',
                            proc { sinus } ) # sinus
      @dictionary.add_word( ['asin'],
                            'Trig on reals and complexes',
                            '( n -- m ) compute arg-sinus of n',
                            proc { arg_sinus } ) # arg sinus
      @dictionary.add_word( ['cos'],
                            'Trig on reals and complexes',
                            '( n -- m ) compute cosinus of n',
                            proc { cosinus } ) # cosinus
      @dictionary.add_word( ['acos'],
                            'Trig on reals and complexes',
                            '( n -- m ) compute arg-cosinus of n',
                            proc { arg_cosinus } ) # arg cosinus
      @dictionary.add_word( ['tan'],
                            'Trig on reals and complexes',
                            '( n -- m ) compute tangent of n',
                            proc { tangent } ) # tangent
      @dictionary.add_word( ['atan'],
                            'Trig on reals and complexes',
                            '( n -- m ) compute arc-tangent of n',
                            proc { arg_tangent } ) # arg tangent
      @dictionary.add_word( ['d→r', 'd->r'],
                            'Trig on reals and complexes',
                            '( n -- m ) convert degree to radian',
                            proc { degrees_to_radians } ) # convert degrees to radians
      @dictionary.add_word( ['r→d', 'r->d'],
                            'Trig on reals and complexes',
                            '( n -- m ) convert radian to degree',
                            proc { radians_to_degrees } ) # convert radians to degrees

      # Logs on reals and complexes
      @dictionary.add_word( ['ℇ', 'e'],
                            'Logs on reals and complexes',
                            '( … -- ℇ ) push ℇ',
                            proc { e } ) # alias
      # @dictionary.add_word( 'ln',
      #                  proc { __todo } ) # logarithm base e
      # @dictionary.add_word( 'lnp1',
      #                  proc { __todo } ) # ln(1+x) which is useful when x is close to 0
      # @dictionary.add_word( 'exp',
      #                  proc { __todo } ) # exponential
      # @dictionary.add_word( 'expm',
      #                  proc { __todo } ) # exp(x)-1 which is useful when x is close to 0
      # @dictionary.add_word( 'log10',
      #                  proc { __todo } ) # logarithm base 10
      # @dictionary.add_word( 'alog10',
      #                  proc { __todo } ) # exponential base 10
      # @dictionary.add_word( 'log2',
      #                  proc { __todo } ) # logarithm base 2
      # @dictionary.add_word( 'alog2',
      #                  proc { __todo } ) # exponential base 2
      # @dictionary.add_word( 'sinh',
      #                  proc { __todo } ) # hyperbolic sine
      # @dictionary.add_word( 'asinh',
      #                  proc { __todo } ) # inverse hyperbolic sine
      # @dictionary.add_word( 'cosh',
      #                  proc { __todo } ) # hyperbolic cosine
      # @dictionary.add_word( 'acosh',
      #                  proc { __todo } ) # inverse hyperbolic cosine
      # @dictionary.add_word( 'tanh',
      #                  proc { __todo } ) # hyperbolic tangent
      # @dictionary.add_word( 'atanh',
      #                  proc { __todo } ) # inverse hyperbolic tangent

      # Time and date
      @dictionary.add_word( ['time'],
                            'Time and date',
                            '( -- t ) push current time',
                            proc { time } )
      @dictionary.add_word( ['date'],
                            'Time and date',
                            '( -- d ) push current date',
                            proc { date } )
      @dictionary.add_word( ['ticks'],
                            'Time and date',
                            '( -- t ) push datetime as ticks',
                            proc { ticks } )

      # Rpl.rb specifics
      # Lists
      @dictionary.add_word( ['→list', '->list'],
                            'Lists',
                            '( … x -- […] ) pack x stacks levels into a list',
                            proc { to_list } )
      @dictionary.add_word( ['list→', 'list->'],
                            'Lists',
                            '( […] -- … ) unpack list on stack',
                            proc { unpack_list } )

      # Filesystem
      @dictionary.add_word( ['fread'],
                            'Filesystem',
                            '( filename -- content ) read file and put content on stack as string',
                            proc { fread } )
      @dictionary.add_word( ['feval'],
                            'Filesystem',
                            '( filename -- … ) read and run file',
                            proc { feval } )
      @dictionary.add_word( ['fwrite'],
                            'Filesystem',
                            '( content filename -- ) write content into filename',
                            proc { fwrite } )

      # Graphics
    end
  end
end
