# frozen_string_literal: true

module Rpl
  module Lang
    class Dictionary
      attr_reader :vars

      def initialize
        @parser = Parser.new
        @words = {}
        @vars = {}

        # GENERAL
        add( 'nop',     proc { |stack, dictionary| Rpl::Lang::Core.nop( stack, dictionary ) } )
        # add( 'help',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # this help message
        # add( 'quit',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # quit software
        # add( 'version', proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # show rpn version
        # add( 'uname',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # show rpn complete identification string
        # add( 'history', proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # see commands history

        # STACK
        add( 'swap',    proc { |stack, dictionary| Rpl::Lang::Core.swap( stack, dictionary ) } )
        add( 'drop',    proc { |stack, dictionary| Rpl::Lang::Core.drop( stack, dictionary ) } )
        add( 'drop2',   proc { |stack, dictionary| Rpl::Lang::Core.drop2( stack, dictionary ) } )
        add( 'dropn',   proc { |stack, dictionary| Rpl::Lang::Core.dropn( stack, dictionary ) } )
        add( 'del',     proc { |stack, dictionary| Rpl::Lang::Core.del( stack, dictionary ) } )
        add( 'rot',     proc { |stack, dictionary| Rpl::Lang::Core.rot( stack, dictionary ) } )
        add( 'dup',     proc { |stack, dictionary| Rpl::Lang::Core.dup( stack, dictionary ) } )
        add( 'dup2',    proc { |stack, dictionary| Rpl::Lang::Core.dup2( stack, dictionary ) } )
        add( 'dupn',    proc { |stack, dictionary| Rpl::Lang::Core.dupn( stack, dictionary ) } )
        add( 'pick',    proc { |stack, dictionary| Rpl::Lang::Core.pick( stack, dictionary ) } )
        add( 'depth',   proc { |stack, dictionary| Rpl::Lang::Core.depth( stack, dictionary ) } )
        add( 'roll',    proc { |stack, dictionary| Rpl::Lang::Core.roll( stack, dictionary ) } )
        add( 'rolld',   proc { |stack, dictionary| Rpl::Lang::Core.rolld( stack, dictionary ) } )
        add( 'over',    proc { |stack, dictionary| Rpl::Lang::Core.over( stack, dictionary ) } )

        # USUAL OPERATIONS ON REALS AND COMPLEXES
        add( '+',       proc { |stack, dictionary| Rpl::Lang::Core.add( stack, dictionary ) } )
        add( '-',       proc { |stack, dictionary| Rpl::Lang::Core.subtract( stack, dictionary ) } )
        add( 'chs',     proc { |stack, dictionary| Rpl::Lang::Core.negate( stack, dictionary ) } )
        add( '*',       proc { |stack, dictionary| Rpl::Lang::Core.multiply( stack, dictionary ) } )
        add( '×',       proc { |stack, dictionary| Rpl::Lang::Core.multiply( stack, dictionary ) } ) # alias
        add( '/',       proc { |stack, dictionary| Rpl::Lang::Core.divide( stack, dictionary ) } )
        add( '÷',       proc { |stack, dictionary| Rpl::Lang::Core.divide( stack, dictionary ) } ) # alias
        add( 'inv',     proc { |stack, dictionary| Rpl::Lang::Core.inverse( stack, dictionary ) } )
        add( '^',       proc { |stack, dictionary| Rpl::Lang::Core.power( stack, dictionary ) } )
        add( 'sqrt',    proc { |stack, dictionary| Rpl::Lang::Core.sqrt( stack, dictionary ) } )
        add( '√',       proc { |stack, dictionary| Rpl::Lang::Core.sqrt( stack, dictionary ) } ) # alias
        add( 'sq',      proc { |stack, dictionary| Rpl::Lang::Core.sq( stack, dictionary ) } )
        add( 'abs',     proc { |stack, dictionary| Rpl::Lang::Core.abs( stack, dictionary ) } )
        add( 'dec',     proc { |stack, dictionary| Rpl::Lang::Core.dec( stack, dictionary ) } )
        add( 'hex',     proc { |stack, dictionary| Rpl::Lang::Core.hex( stack, dictionary ) } )
        add( 'bin',     proc { |stack, dictionary| Rpl::Lang::Core.bin( stack, dictionary ) } )
        add( 'base',    proc { |stack, dictionary| Rpl::Lang::Core.base( stack, dictionary ) } )
        add( 'sign',    proc { |stack, dictionary| Rpl::Lang::Core.sign( stack, dictionary ) } )

        # OPERATIONS ON REALS
        add( '%',       proc { |stack, dictionary| Rpl::Lang::Core.percent( stack, dictionary ) } )
        add( '%CH',     proc { |stack, dictionary| Rpl::Lang::Core.inverse_percent( stack, dictionary ) } )
        add( 'mod',     proc { |stack, dictionary| Rpl::Lang::Core.mod( stack, dictionary ) } )
        add( 'fact',    proc { |stack, dictionary| Rpl::Lang::Core.fact( stack, dictionary ) } )
        add( '!',       proc { |stack, dictionary| Rpl::Lang::Core.fact( stack, dictionary ) } ) # alias
        add( 'floor',   proc { |stack, dictionary| Rpl::Lang::Core.floor( stack, dictionary ) } )
        add( 'ceil',    proc { |stack, dictionary| Rpl::Lang::Core.ceil( stack, dictionary ) } )
        add( 'min',     proc { |stack, dictionary| Rpl::Lang::Core.min( stack, dictionary ) } )
        add( 'max',     proc { |stack, dictionary| Rpl::Lang::Core.max( stack, dictionary ) } )
        # add( 'mant',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # mantissa of a real number
        # add( 'xpon',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exponant of a real number
        # add( 'ip',      proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # integer part
        # add( 'fp',      proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # fractional part

        # OPERATIONS ON COMPLEXES
        # add( 're',      proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # complex real part
        # add( 'im',      proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # complex imaginary part
        # add( 'conj',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # complex conjugate
        # add( 'arg',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # complex argument in radians
        # add( 'c->r',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # transform a complex in 2 reals
        # add( 'c→r',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias
        # add( 'r->c',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # transform 2 reals in a complex
        # add( 'r→c',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias
        # add( 'p->r',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # cartesian to polar
        # add( 'p→r',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias
        # add( 'r->p',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # polar to cartesian
        # add( 'r→p',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias

        # MODE
        add( 'prec',    proc { |stack, dictionary| Rpl::Lang::Core.prec( stack, dictionary ) } )
        add( 'default', proc { |stack, dictionary| Rpl::Lang::Core.default( stack, dictionary ) } )
        add( 'type',    proc { |stack, dictionary| Rpl::Lang::Core.type( stack, dictionary ) } )
        # add( 'std',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # standard floating numbers representation. ex: std
        # add( 'fix',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # fixed point representation. ex: 6 fix
        # add( 'sci',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # scientific floating point representation. ex: 20 sci
        # add( 'round',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # set float rounding mode. ex: ["nearest", "toward zero", "toward +inf", "toward -inf", "away from zero"] round

        # TEST
        add( '>',       proc { |stack, dictionary| Rpl::Lang::Core.greater_than( stack, dictionary ) } )
        add( '>=',      proc { |stack, dictionary| Rpl::Lang::Core.greater_than_or_equal( stack, dictionary ) } )
        add( '≥',       proc { |stack, dictionary| Rpl::Lang::Core.greater_than_or_equal( stack, dictionary ) } ) # alias
        add( '<',       proc { |stack, dictionary| Rpl::Lang::Core.less_than( stack, dictionary ) } )
        add( '<=',      proc { |stack, dictionary| Rpl::Lang::Core.less_than_or_equal( stack, dictionary ) } )
        add( '≤',       proc { |stack, dictionary| Rpl::Lang::Core.less_than_or_equal( stack, dictionary ) } ) # alias
        add( '!=',      proc { |stack, dictionary| Rpl::Lang::Core.different( stack, dictionary ) } )
        add( '≠',       proc { |stack, dictionary| Rpl::Lang::Core.different( stack, dictionary ) } ) # alias
        add( '==',      proc { |stack, dictionary| Rpl::Lang::Core.same( stack, dictionary ) } ) # alias
        add( 'and',     proc { |stack, dictionary| Rpl::Lang::Core.and( stack, dictionary ) } )
        add( 'or',      proc { |stack, dictionary| Rpl::Lang::Core.or( stack, dictionary ) } )
        add( 'xor',     proc { |stack, dictionary| Rpl::Lang::Core.xor( stack, dictionary ) } )
        add( 'not',     proc { |stack, dictionary| Rpl::Lang::Core.not( stack, dictionary ) } )
        add( 'same',    proc { |stack, dictionary| Rpl::Lang::Core.same( stack, dictionary ) } )
        add( 'true',    proc { |stack, dictionary| Rpl::Lang::Core.true( stack, dictionary ) } ) # specific
        add( 'false',   proc { |stack, dictionary| Rpl::Lang::Core.false( stack, dictionary ) } ) # specific

        # STRING
        add( '->str',   proc { |stack, dictionary| Rpl::Lang::Core.to_string( stack, dictionary ) } )
        add( '→str',    proc { |stack, dictionary| Rpl::Lang::Core.to_string( stack, dictionary ) } ) # alias
        add( 'str->',   proc { |stack, dictionary| Rpl::Lang::Core.from_string( stack, dictionary ) } )
        add( 'str→',    proc { |stack, dictionary| Rpl::Lang::Core.from_string( stack, dictionary ) } ) # alias
        add( 'chr',     proc { |stack, dictionary| Rpl::Lang::Core.chr( stack, dictionary ) } )
        add( 'num',     proc { |stack, dictionary| Rpl::Lang::Core.num( stack, dictionary ) } )
        add( 'size',    proc { |stack, dictionary| Rpl::Lang::Core.size( stack, dictionary ) } )
        add( 'pos',     proc { |stack, dictionary| Rpl::Lang::Core.pos( stack, dictionary ) } )
        add( 'sub',     proc { |stack, dictionary| Rpl::Lang::Core.sub( stack, dictionary ) } )
        # add( 'rev',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # reverse string
        # add( 'split',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # split string

        # BRANCH
        add( 'ift',     proc { |stack, dictionary| Rpl::Lang::Core.ift( stack, dictionary ) } )
        add( 'ifte',    proc { |stack, dictionary| Rpl::Lang::Core.ifte( stack, dictionary ) } )
        add( 'times',   proc { |stack, dictionary| Rpl::Lang::Core.times( stack, dictionary ) } ) # specific
        add( 'loop',    proc { |stack, dictionary| Rpl::Lang::Core.loop( stack, dictionary ) } ) # specific
        # add( 'if',      proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # if <test-instruction> then <true-instructions> else <false-instructions> end
        # add( 'then',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with if
        # add( 'else',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with if
        # add( 'end',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with various branch instructions
        # add( 'start',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # <start> <end> start <instructions> next|<step> step
        # add( 'for',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # <start> <end> for <variable> <instructions> next|<step> step
        # add( 'next',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with start and for
        # add( 'step',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with start and for
        # add( 'do',      proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # do <instructions> until <condition> end
        # add( 'until',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with do
        # add( 'while',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # while <test-instruction> repeat <loop-instructions> end
        # add( 'repeat',  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with while

        # STORE
        add( 'sto',     proc { |stack, dictionary| Rpl::Lang::Core.sto( stack, dictionary ) } )
        add( '▶',       proc { |stack, dictionary| Rpl::Lang::Core.sto( stack, dictionary ) } ) # alias
        add( 'rcl',     proc { |stack, dictionary| Rpl::Lang::Core.rcl( stack, dictionary ) } )
        add( 'purge',   proc { |stack, dictionary| Rpl::Lang::Core.purge( stack, dictionary ) } )
        add( 'vars',    proc { |stack, dictionary| Rpl::Lang::Core.vars( stack, dictionary ) } )
        add( 'clusr',   proc { |stack, dictionary| Rpl::Lang::Core.clusr( stack, dictionary ) } )
        add( 'sto+',    proc { |stack, dictionary| Rpl::Lang::Core.sto_add( stack, dictionary ) } )
        add( 'sto-',    proc { |stack, dictionary| Rpl::Lang::Core.sto_subtract( stack, dictionary ) } )
        add( 'sto*',    proc { |stack, dictionary| Rpl::Lang::Core.sto_multiply( stack, dictionary ) } )
        add( 'sto×',    proc { |stack, dictionary| Rpl::Lang::Core.sto_multiply( stack, dictionary ) } ) # alias
        add( 'sto/',    proc { |stack, dictionary| Rpl::Lang::Core.sto_divide( stack, dictionary ) } )
        add( 'sto÷',    proc { |stack, dictionary| Rpl::Lang::Core.sto_divide( stack, dictionary ) } ) # alias
        add( 'sneg',    proc { |stack, dictionary| Rpl::Lang::Core.sto_negate( stack, dictionary ) } )
        add( 'sinv',    proc { |stack, dictionary| Rpl::Lang::Core.sto_inverse( stack, dictionary ) } )
        # add( 'edit',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # edit a variable content

        # PROGRAM
        add( 'eval',    proc { |stack, dictionary| Rpl::Lang::Core.eval( stack, dictionary ) } )
        # add( '->',      proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # load program local variables. ex: « → n m « 0 n m for i i + next » »
        # add( '→',       proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias

        # TRIG ON REALS AND COMPLEXES
        add( 'pi',      proc { |stack, dictionary| Rpl::Lang::Core.pi( stack, dictionary ) } )
        add( '𝛑',       proc { |stack, dictionary| Rpl::Lang::Core.pi( stack, dictionary ) } ) # alias
        add( 'sin',     proc { |stack, dictionary| Rpl::Lang::Core.sinus( stack, dictionary ) } )
        add( 'asin',    proc { |stack, dictionary| Rpl::Lang::Core.arg_sinus( stack, dictionary ) } )
        add( 'cos',     proc { |stack, dictionary| Rpl::Lang::Core.cosinus( stack, dictionary ) } )
        add( 'acos',    proc { |stack, dictionary| Rpl::Lang::Core.arg_cosinus( stack, dictionary ) } )
        add( 'tan',     proc { |stack, dictionary| Rpl::Lang::Core.tangent( stack, dictionary ) } )
        add( 'atan',    proc { |stack, dictionary| Rpl::Lang::Core.arg_tangent( stack, dictionary ) } )
        add( 'd->r',    proc { |stack, dictionary| Rpl::Lang::Core.degrees_to_radians( stack, dictionary ) } )
        add( 'd→r',     proc { |stack, dictionary| Rpl::Lang::Core.degrees_to_radians( stack, dictionary ) } ) # alias
        add( 'r->d',    proc { |stack, dictionary| Rpl::Lang::Core.radians_to_degrees( stack, dictionary ) } )
        add( 'r→d',     proc { |stack, dictionary| Rpl::Lang::Core.radians_to_degrees( stack, dictionary ) } ) # alias

        # LOGS ON REALS AND COMPLEXES
        add( 'e',       proc { |stack, dictionary| Rpl::Lang::Core.e( stack, dictionary ) } )
        add( 'ℇ',       proc { |stack, dictionary| Rpl::Lang::Core.e( stack, dictionary ) } ) # alias
        # add( 'ln',      proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # logarithm base e
        # add( 'lnp1',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # ln(1+x) which is useful when x is close to 0
        # add( 'exp',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exponential
        # add( 'expm',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exp(x)-1 which is useful when x is close to 0
        # add( 'log10',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # logarithm base 10
        # add( 'alog10',  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exponential base 10
        # add( 'log2',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # logarithm base 2
        # add( 'alog2',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exponential base 2
        # add( 'sinh',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # hyperbolic sine
        # add( 'asinh',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # inverse hyperbolic sine
        # add( 'cosh',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # hyperbolic cosine
        # add( 'acosh',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # inverse hyperbolic cosine
        # add( 'tanh',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # hyperbolic tangent
        # add( 'atanh',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # inverse hyperbolic tangent

        # TIME AND DATE
        add( 'time',    proc { |stack, dictionary| Rpl::Lang::Core.time( stack, dictionary ) } )
        add( 'date',    proc { |stack, dictionary| Rpl::Lang::Core.date( stack, dictionary ) } )
        add( 'ticks',   proc { |stack, dictionary| Rpl::Lang::Core.ticks( stack, dictionary ) } )

        # Rpl.rb specifics
        # LISTS
        # add( '->LIST',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # ( … x -- […] ) pack x stacks levels into a list
        # add( '→LIST',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias
        # add( 'LIST->',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # ( […] -- … ) unpack list on stack
        # add( 'LIST→',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias

        # FILES
        # add( 'fread',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # ( filename -- content ) read file and put content on stack as string
        # add( 'fload',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # ( filename -- … ) « FREAD EVAL »
        # add( 'fwrite',  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # ( content filename mode -- ) write content into filename using mode (w, a, …)
      end

      def add( name, implementation )
        @words[ name ] = implementation
      end

      def add_var( name, implementation )
        @vars[ name ] = implementation
      end

      def remove_var( name )
        @vars.delete( name )
      end

      def remove_all_vars
        @vars = {}
      end

      def lookup( name )
        word = @words[ name ]
        word ||= @vars[ name ]

        word
      end
    end
  end
end
