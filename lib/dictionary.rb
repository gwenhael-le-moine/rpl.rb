# coding: utf-8

module Rpl
  class Dictionary
    def initialize
      @parser = Parser.new
      @words = {}

      # GENERAL
      add( 'nop',     proc { |stack| Rpl::Core.nop( stack ) } )
      add( 'help',    proc { |stack| Rpl::Core.__todo( stack ) } ) # this help message
      add( 'quit',    proc { |stack| Rpl::Core.__todo( stack ) } ) # quit software
      add( 'version', proc { |stack| Rpl::Core.__todo( stack ) } ) # show rpn version
      add( 'uname',   proc { |stack| Rpl::Core.__todo( stack ) } ) # show rpn complete identification string
      add( 'history', proc { |stack| Rpl::Core.__todo( stack ) } ) # see commands history

      # STACK
      add( 'swap',    proc { |stack| Rpl::Core.swap( stack ) } )
      add( 'drop',    proc { |stack| Rpl::Core.drop( stack ) } )
      add( 'drop2',   proc { |stack| Rpl::Core.drop2( stack ) } )
      add( 'dropn',   proc { |stack| Rpl::Core.dropn( stack ) } )
      add( 'del',     proc { |stack| Rpl::Core.del( stack ) } )
      add( 'rot',     proc { |stack| Rpl::Core.rot( stack ) } )
      add( 'dup',     proc { |stack| Rpl::Core.dup( stack ) } )
      add( 'dup2',    proc { |stack| Rpl::Core.dup2( stack ) } )
      add( 'dupn',    proc { |stack| Rpl::Core.dupn( stack ) } )
      add( 'pick',    proc { |stack| Rpl::Core.pick( stack ) } )
      add( 'depth',   proc { |stack| Rpl::Core.depth( stack ) } )
      add( 'roll',    proc { |stack| Rpl::Core.roll( stack ) } )
      add( 'rolld',   proc { |stack| Rpl::Core.rolld( stack ) } )
      add( 'over',    proc { |stack| Rpl::Core.over( stack ) } )

      # USUAL OPERATIONS ON REALS AND COMPLEXES
      add( '+',       proc { |stack| Rpl::Core.add( stack ) } )
      add( '-',       proc { |stack| Rpl::Core.subtract( stack ) } )
      add( 'chs',     proc { |stack| Rpl::Core.negate( stack ) } )
      add( '*',       proc { |stack| Rpl::Core.multiply( stack ) } )
      add( '×',       proc { |stack| Rpl::Core.multiply( stack ) } ) # alias
      add( '/',       proc { |stack| Rpl::Core.divide( stack ) } )
      add( '÷',       proc { |stack| Rpl::Core.divide( stack ) } ) # alias
      add( 'inv',     proc { |stack| Rpl::Core.inverse( stack ) } )
      add( '^',       proc { |stack| Rpl::Core.power( stack ) } )
      add( 'sqrt',    proc { |stack| Rpl::Core.sqrt( stack ) } )
      add( 'sq',      proc { |stack| Rpl::Core.sq( stack ) } )
      add( 'abs',     proc { |stack| Rpl::Core.abs( stack ) } )
      add( 'dec',     proc { |stack| Rpl::Core.dec( stack ) } )
      add( 'hex',     proc { |stack| Rpl::Core.hex( stack ) } )
      add( 'bin',     proc { |stack| Rpl::Core.bin( stack ) } )
      add( 'base',    proc { |stack| Rpl::Core.base( stack ) } )
      add( 'sign',    proc { |stack| Rpl::Core.sign( stack ) } )

      # OPERATIONS ON REALS
      add( '%',       proc { |stack| Rpl::Core.__todo( stack ) } ) # percent
      add( '%CH',     proc { |stack| Rpl::Core.__todo( stack ) } ) # inverse percent
      add( 'mod',     proc { |stack| Rpl::Core.__todo( stack ) } ) # modulo
      add( 'fact',    proc { |stack| Rpl::Core.__todo( stack ) } ) # n! for integer n or Gamma(x+1) for fractional x
      add( 'mant',    proc { |stack| Rpl::Core.__todo( stack ) } ) # mantissa of a real number
      add( 'xpon',    proc { |stack| Rpl::Core.__todo( stack ) } ) # exponant of a real number
      add( 'floor',   proc { |stack| Rpl::Core.__todo( stack ) } ) # largest number <=
      add( 'ceil',    proc { |stack| Rpl::Core.__todo( stack ) } ) # smallest number >=
      add( 'ip',      proc { |stack| Rpl::Core.__todo( stack ) } ) # integer part
      add( 'fp',      proc { |stack| Rpl::Core.__todo( stack ) } ) # fractional part
      add( 'min',     proc { |stack| Rpl::Core.__todo( stack ) } ) # min of 2 real numbers
      add( 'max',     proc { |stack| Rpl::Core.__todo( stack ) } ) # max of 2 real numbers

      # OPERATIONS ON COMPLEXES
      add( 're',      proc { |stack| Rpl::Core.__todo( stack ) } ) # complex real part
      add( 'im',      proc { |stack| Rpl::Core.__todo( stack ) } ) # complex imaginary part
      add( 'conj',    proc { |stack| Rpl::Core.__todo( stack ) } ) # complex conjugate
      add( 'arg',     proc { |stack| Rpl::Core.__todo( stack ) } ) # complex argument in radians
      add( 'c->r',    proc { |stack| Rpl::Core.__todo( stack ) } ) # transform a complex in 2 reals
      add( 'c→r',     proc { |stack| Rpl::Core.__todo( stack ) } ) # alias
      add( 'r->c',    proc { |stack| Rpl::Core.__todo( stack ) } ) # transform 2 reals in a complex
      add( 'r→c',     proc { |stack| Rpl::Core.__todo( stack ) } ) # alias
      add( 'p->r',    proc { |stack| Rpl::Core.__todo( stack ) } ) # cartesian to polar
      add( 'p→r',     proc { |stack| Rpl::Core.__todo( stack ) } ) # alias
      add( 'r->p',    proc { |stack| Rpl::Core.__todo( stack ) } ) # polar to cartesian
      add( 'r→p',     proc { |stack| Rpl::Core.__todo( stack ) } ) # alias

      # MODE
      add( 'std',     proc { |stack| Rpl::Core.__todo( stack ) } ) # standard floating numbers representation. ex: std
      add( 'fix',     proc { |stack| Rpl::Core.__todo( stack ) } ) # fixed point representation. ex: 6 fix
      add( 'sci',     proc { |stack| Rpl::Core.__todo( stack ) } ) # scientific floating point representation. ex: 20 sci
      add( 'prec',    proc { |stack| Rpl::Core.prec( stack ) } )
      add( 'round',   proc { |stack| Rpl::Core.__todo( stack ) } ) # set float rounding mode. ex: ["nearest", "toward zero", "toward +inf", "toward -inf", "away from zero"] round
      add( 'default', proc { |stack| Rpl::Core.default( stack ) } )
      add( 'type',    proc { |stack| Rpl::Core.type( stack ) } )

      # TEST
      add( '>',       proc { |stack| Rpl::Core.greater_than( stack ) } )
      add( '>=',      proc { |stack| Rpl::Core.greater_or_equal_than( stack ) } )
      add( '≥',       proc { |stack| Rpl::Core.greater_or_equal_than( stack ) } ) # alias
      add( '<',       proc { |stack| Rpl::Core.less_than( stack ) } )
      add( '<=',      proc { |stack| Rpl::Core.less_or_equal_than( stack ) } )
      add( '≤',       proc { |stack| Rpl::Core.less_or_equal_than( stack ) } ) # alias
      add( '!=',      proc { |stack| Rpl::Core.different( stack ) } )
      add( '≠',       proc { |stack| Rpl::Core.different( stack ) } ) # alias
      add( '==',      proc { |stack| Rpl::Core.same( stack ) } ) # alias
      add( 'and',     proc { |stack| Rpl::Core.and( stack ) } )
      add( 'or',      proc { |stack| Rpl::Core.or( stack ) } )
      add( 'xor',     proc { |stack| Rpl::Core.xor( stack ) } )
      add( 'not',     proc { |stack| Rpl::Core.not( stack ) } )
      add( 'same',    proc { |stack| Rpl::Core.same( stack ) } )
      add( 'true',    proc { |stack| Rpl::Core.true( stack ) } )
      add( 'false',   proc { |stack| Rpl::Core.false( stack ) } )

      # STRING
      add( '->str',   proc { |stack| Rpl::Core.to_string( stack ) } )
      add( '→str',    proc { |stack| Rpl::Core.to_string( stack ) } ) # alias
      add( 'str->',   proc { |stack| Rpl::Core.from_string( stack ) } )
      add( 'str→',    proc { |stack| Rpl::Core.from_string( stack ) } ) # alias
      add( 'chr',     proc { |stack| Rpl::Core.chr( stack ) } )
      add( 'num',     proc { |stack| Rpl::Core.num( stack ) } )
      add( 'size',    proc { |stack| Rpl::Core.size( stack ) } )
      add( 'pos',     proc { |stack| Rpl::Core.pos( stack ) } )
      add( 'sub',     proc { |stack| Rpl::Core.sub( stack ) } )

      # BRANCH
      add( 'if',      proc { |stack| Rpl::Core.__todo( stack ) } ) # if <test-instruction> then <true-instructions> else <false-instructions> end
      add( 'then',    proc { |stack| Rpl::Core.__todo( stack ) } ) # used with if
      add( 'else',    proc { |stack| Rpl::Core.__todo( stack ) } ) # used with if
      add( 'end',     proc { |stack| Rpl::Core.__todo( stack ) } ) # used with various branch instructions
      add( 'start',   proc { |stack| Rpl::Core.__todo( stack ) } ) # <start> <end> start <instructions> next|<step> step
      add( 'for',     proc { |stack| Rpl::Core.__todo( stack ) } ) # <start> <end> for <variable> <instructions> next|<step> step
      add( 'next',    proc { |stack| Rpl::Core.__todo( stack ) } ) # used with start and for
      add( 'step',    proc { |stack| Rpl::Core.__todo( stack ) } ) # used with start and for
      add( 'ift',     proc { |stack| Rpl::Core.__todo( stack ) } ) # similar to if-then-end, <test-instruction> <true-instruction> ift
      add( 'ifte',    proc { |stack| Rpl::Core.__todo( stack ) } ) # similar to if-then-else-end, <test-instruction> <true-instruction> <false-instruction> ifte
      add( 'do',      proc { |stack| Rpl::Core.__todo( stack ) } ) # do <instructions> until <condition> end
      add( 'until',   proc { |stack| Rpl::Core.__todo( stack ) } ) # used with do
      add( 'while',   proc { |stack| Rpl::Core.__todo( stack ) } ) # while <test-instruction> repeat <loop-instructions> end
      add( 'repeat',  proc { |stack| Rpl::Core.__todo( stack ) } ) # used with while

      # STORE
      add( 'sto',     proc { |stack| Rpl::Core.__todo( stack ) } ) # store a variable. ex: 1 'name' sto
      add( 'rcl',     proc { |stack| Rpl::Core.__todo( stack ) } ) # recall a variable. ex: 'name' rcl
      add( 'purge',   proc { |stack| Rpl::Core.__todo( stack ) } ) # delete a variable. ex: 'name' purge
      add( 'vars',    proc { |stack| Rpl::Core.__todo( stack ) } ) # list all variables
      add( 'clusr',   proc { |stack| Rpl::Core.__todo( stack ) } ) # erase all variables
      add( 'edit',    proc { |stack| Rpl::Core.__todo( stack ) } ) # edit a variable content
      add( 'sto+',    proc { |stack| Rpl::Core.__todo( stack ) } ) # add to a stored variable. ex: 1 'name' sto+ 'name' 2 sto+
      add( 'sto-',    proc { |stack| Rpl::Core.__todo( stack ) } ) # substract to a stored variable. ex: 1 'name' sto- 'name' 2 sto-
      add( 'sto*',    proc { |stack| Rpl::Core.__todo( stack ) } ) # multiply a stored variable. ex: 3 'name' sto* 'name' 2 sto*
      add( 'sto/',    proc { |stack| Rpl::Core.__todo( stack ) } ) # divide a stored variable. ex: 3 'name' sto/ 'name' 2 sto/
      add( 'sneg',    proc { |stack| Rpl::Core.__todo( stack ) } ) # negate a variable. ex: 'name' sneg
      add( 'sinv',    proc { |stack| Rpl::Core.__todo( stack ) } ) # inverse a variable. ex: 1 'name' sinv

      # PROGRAM
      add( 'eval',    proc { |stack| Rpl::Core.eval( stack, self ) } )
      add( '->',      proc { |stack| Rpl::Core.__todo( stack ) } ) # load program local variables. ex: << -> n m << 0 n m for i i + next >> >>
      add( '→',       proc { |stack| Rpl::Core.__todo( stack ) } ) # alias

      # TRIG ON REALS AND COMPLEXES
      add( 'pi',      proc { |stack| Rpl::Core.__todo( stack ) } ) # pi constant
      add( 'sin',     proc { |stack| Rpl::Core.__todo( stack ) } ) # sinus
      add( 'asin',    proc { |stack| Rpl::Core.__todo( stack ) } ) # arg sinus
      add( 'cos',     proc { |stack| Rpl::Core.__todo( stack ) } ) # cosinus
      add( 'acos',    proc { |stack| Rpl::Core.__todo( stack ) } ) # arg cosinus
      add( 'tan',     proc { |stack| Rpl::Core.__todo( stack ) } ) # tangent
      add( 'atan',    proc { |stack| Rpl::Core.__todo( stack ) } ) # arg tangent
      add( 'd->r',    proc { |stack| Rpl::Core.__todo( stack ) } ) # convert degrees to radians
      add( 'd→r',     proc { |stack| Rpl::Core.__todo( stack ) } ) # alias
      add( 'r->d',    proc { |stack| Rpl::Core.__todo( stack ) } ) # convert radians to degrees
      add( 'r→d',     proc { |stack| Rpl::Core.__todo( stack ) } ) # alias

      # LOGS ON REALS AND COMPLEXES
      add( 'e',       proc { |stack| Rpl::Core.__todo( stack ) } ) # Euler constant
      add( 'ln',      proc { |stack| Rpl::Core.__todo( stack ) } ) # logarithm base e
      add( 'lnp1',    proc { |stack| Rpl::Core.__todo( stack ) } ) # ln(1+x) which is useful when x is close to 0
      add( 'exp',     proc { |stack| Rpl::Core.__todo( stack ) } ) # exponential
      add( 'expm',    proc { |stack| Rpl::Core.__todo( stack ) } ) # exp(x)-1 which is useful when x is close to 0
      add( 'log10',   proc { |stack| Rpl::Core.__todo( stack ) } ) # logarithm base 10
      add( 'alog10',  proc { |stack| Rpl::Core.__todo( stack ) } ) # exponential base 10
      add( 'log2',    proc { |stack| Rpl::Core.__todo( stack ) } ) # logarithm base 2
      add( 'alog2',   proc { |stack| Rpl::Core.__todo( stack ) } ) # exponential base 2
      add( 'sinh',    proc { |stack| Rpl::Core.__todo( stack ) } ) # hyperbolic sine
      add( 'asinh',   proc { |stack| Rpl::Core.__todo( stack ) } ) # inverse hyperbolic sine
      add( 'cosh',    proc { |stack| Rpl::Core.__todo( stack ) } ) # hyperbolic cosine
      add( 'acosh',   proc { |stack| Rpl::Core.__todo( stack ) } ) # inverse hyperbolic cosine
      add( 'tanh',    proc { |stack| Rpl::Core.__todo( stack ) } ) # hyperbolic tangent
      add( 'atanh',   proc { |stack| Rpl::Core.__todo( stack ) } ) # inverse hyperbolic tangent

      # TIME AND DATE
      add( 'time',    proc { |stack| Rpl::Core.time( stack ) } )
      add( 'date',    proc { |stack| Rpl::Core.date( stack ) } )
      add( 'ticks',   proc { |stack| Rpl::Core.ticks( stack ) } )
    end

    def add( name, implementation )
      @words[ name ] = implementation
    end

    def lookup( name )
      @words[ name ] if @words.include?( name )
    end

    # TODO: alias
  end
end
