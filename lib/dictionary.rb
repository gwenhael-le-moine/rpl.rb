# coding: utf-8

module Rpn
  class Dictionary
    def initialize
      @parser = Parser.new
      @words = {}

      # GENERAL
      add( 'nop',     proc { |stack| Rpn::Core::General.nop( stack ) } )
      add( 'help',    proc { |stack| Rpn::Core.__todo( stack ) } ) # this help message
      add( 'quit',    proc { |stack| Rpn::Core.__todo( stack ) } ) # quit software
      add( 'version', proc { |stack| Rpn::Core.__todo( stack ) } ) # show rpn version
      add( 'uname',   proc { |stack| Rpn::Core.__todo( stack ) } ) # show rpn complete identification string
      add( 'history', proc { |stack| Rpn::Core.__todo( stack ) } ) # see commands history

      # STACK
      add( 'swap',    proc { |stack| Rpn::Core::Stack.swap( stack ) } )
      add( 'drop',    proc { |stack| Rpn::Core::Stack.drop( stack ) } )
      add( 'drop2',   proc { |stack| Rpn::Core::Stack.drop2( stack ) } )
      add( 'dropn',   proc { |stack| Rpn::Core::Stack.dropn( stack ) } )
      add( 'del',     proc { |stack| Rpn::Core::Stack.del( stack ) } )
      add( 'rot',     proc { |stack| Rpn::Core::Stack.rot( stack ) } )
      add( 'dup',     proc { |stack| Rpn::Core::Stack.dup( stack ) } )
      add( 'dup2',    proc { |stack| Rpn::Core::Stack.dup2( stack ) } )
      add( 'dupn',    proc { |stack| Rpn::Core::Stack.dupn( stack ) } )
      add( 'pick',    proc { |stack| Rpn::Core::Stack.pick( stack ) } )
      add( 'depth',   proc { |stack| Rpn::Core::Stack.depth( stack ) } )
      add( 'roll',    proc { |stack| Rpn::Core::Stack.roll( stack ) } )
      add( 'rolld',   proc { |stack| Rpn::Core::Stack.rolld( stack ) } )
      add( 'over',    proc { |stack| Rpn::Core::Stack.over( stack ) } )

      # USUAL OPERATIONS ON REALS AND COMPLEXES
      add( '+',       proc { |stack| Rpn::Core::Operations.add( stack ) } )
      add( '-',       proc { |stack| Rpn::Core::Operations.subtract( stack ) } )
      add( 'chs',     proc { |stack| Rpn::Core::Operations.negate( stack ) } )
      add( '*',       proc { |stack| Rpn::Core::Operations.multiply( stack ) } )
      add( '/',       proc { |stack| Rpn::Core::Operations.divide( stack ) } )
      add( 'inv',     proc { |stack| Rpn::Core::Operations.inverse( stack ) } )
      add( '^',       proc { |stack| Rpn::Core::Operations.power( stack ) } )
      add( 'sqrt',    proc { |stack| Rpn::Core.__todo( stack ) } ) # rpn_square root
      add( 'sq',      proc { |stack| Rpn::Core.__todo( stack ) } ) # rpn_square
      add( 'abs',     proc { |stack| Rpn::Core.__todo( stack ) } ) # absolute value
      add( 'dec',     proc { |stack| Rpn::Core.__todo( stack ) } ) # decimal representation
      add( 'hex',     proc { |stack| Rpn::Core.__todo( stack ) } ) # hexadecimal representation
      add( 'bin',     proc { |stack| Rpn::Core.__todo( stack ) } ) # binary representation
      add( 'base',    proc { |stack| Rpn::Core.__todo( stack ) } ) # arbitrary base representation
      add( 'sign',    proc { |stack| Rpn::Core.__todo( stack ) } ) # 1 if number at stack level 1 is > 0, 0 if == 0, -1 if <= 0

      # OPERATIONS ON REALS
      add( '%',       proc { |stack| Rpn::Core.__todo( stack ) } ) # percent
      add( '%CH',     proc { |stack| Rpn::Core.__todo( stack ) } ) # inverse percent
      add( 'mod',     proc { |stack| Rpn::Core.__todo( stack ) } ) # modulo
      add( 'fact',    proc { |stack| Rpn::Core.__todo( stack ) } ) # n! for integer n or Gamma(x+1) for fractional x
      add( 'mant',    proc { |stack| Rpn::Core.__todo( stack ) } ) # mantissa of a real number
      add( 'xpon',    proc { |stack| Rpn::Core.__todo( stack ) } ) # exponant of a real number
      add( 'floor',   proc { |stack| Rpn::Core.__todo( stack ) } ) # largest number <=
      add( 'ceil',    proc { |stack| Rpn::Core.__todo( stack ) } ) # smallest number >=
      add( 'ip',      proc { |stack| Rpn::Core.__todo( stack ) } ) # integer part
      add( 'fp',      proc { |stack| Rpn::Core.__todo( stack ) } ) # fractional part
      add( 'min',     proc { |stack| Rpn::Core.__todo( stack ) } ) # min of 2 real numbers
      add( 'max',     proc { |stack| Rpn::Core.__todo( stack ) } ) # max of 2 real numbers

      # OPERATIONS ON COMPLEXES
      add( 're',      proc { |stack| Rpn::Core.__todo( stack ) } ) # complex real part
      add( 'im',      proc { |stack| Rpn::Core.__todo( stack ) } ) # complex imaginary part
      add( 'conj',    proc { |stack| Rpn::Core.__todo( stack ) } ) # complex conjugate
      add( 'arg',     proc { |stack| Rpn::Core.__todo( stack ) } ) # complex argument in radians
      add( 'c->r',    proc { |stack| Rpn::Core.__todo( stack ) } ) # transform a complex in 2 reals
      add( 'r->c',    proc { |stack| Rpn::Core.__todo( stack ) } ) # transform 2 reals in a complex
      add( 'p->r',    proc { |stack| Rpn::Core.__todo( stack ) } ) # cartesian to polar
      add( 'r->p',    proc { |stack| Rpn::Core.__todo( stack ) } ) # polar to cartesian

      # MODE
      add( 'std',     proc { |stack| Rpn::Core.__todo( stack ) } ) # standard floating numbers representation. ex: std
      add( 'fix',     proc { |stack| Rpn::Core.__todo( stack ) } ) # fixed point representation. ex: 6 fix
      add( 'sci',     proc { |stack| Rpn::Core.__todo( stack ) } ) # scientific floating point representation. ex: 20 sci
      add( 'prec',    proc { |stack| Rpn::Core.__todo( stack ) } ) # set float precision in bits. ex: 256 prec
      add( 'round',   proc { |stack| Rpn::Core.__todo( stack ) } ) # set float rounding mode. ex: ["nearest", "toward zero", "toward +inf", "toward -inf", "away from zero"] round
      add( 'default', proc { |stack| Rpn::Core.__todo( stack ) } ) # set float representation and precision to default
      add( 'type',    proc { |stack| Rpn::Core.__todo( stack ) } ) # show type of stack first entry

      # TEST
      add( '>',       proc { |stack| Rpn::Core.__todo( stack ) } ) # binary operator >
      add( '>=',      proc { |stack| Rpn::Core.__todo( stack ) } ) # binary operator >=
      add( '<',       proc { |stack| Rpn::Core.__todo( stack ) } ) # binary operator <
      add( '<=',      proc { |stack| Rpn::Core.__todo( stack ) } ) # binary operator <=
      add( '!=',      proc { |stack| Rpn::Core.__todo( stack ) } ) # binary operator != (different)
      add( '==',      proc { |stack| Rpn::Core.__todo( stack ) } ) # binary operator == (equal)
      add( 'and',     proc { |stack| Rpn::Core.__todo( stack ) } ) # boolean operator and
      add( 'or',      proc { |stack| Rpn::Core.__todo( stack ) } ) # boolean operator or
      add( 'xor',     proc { |stack| Rpn::Core.__todo( stack ) } ) # boolean operator xor
      add( 'not',     proc { |stack| Rpn::Core.__todo( stack ) } ) # boolean operator not
      add( 'same',    proc { |stack| Rpn::Core.__todo( stack ) } ) # boolean operator same (equal)

      # STRING
      add( '->str',   proc { |stack| Rpn::Core.__todo( stack ) } ) # convert an object into a string
      add( 'str->',   proc { |stack| Rpn::Core.__todo( stack ) } ) # convert a string into an object
      add( 'chr',     proc { |stack| Rpn::Core.__todo( stack ) } ) # convert ASCII character code in stack level 1 into a string
      add( 'num',     proc { |stack| Rpn::Core.__todo( stack ) } ) # return ASCII code of the first character of the string in stack level 1 as a real number
      add( 'size',    proc { |stack| Rpn::Core.__todo( stack ) } ) # return the length of the string
      add( 'pos',     proc { |stack| Rpn::Core.__todo( stack ) } ) # seach for the string in level 1 within the string in level 2
      add( 'sub',     proc { |stack| Rpn::Core.__todo( stack ) } ) # return a substring of the string in level 3

      # BRANCH
      add( 'if',      proc { |stack| Rpn::Core.__todo( stack ) } ) # if <test-instruction> then <true-instructions> else <false-instructions> end
      add( 'then',    proc { |stack| Rpn::Core.__todo( stack ) } ) # used with if
      add( 'else',    proc { |stack| Rpn::Core.__todo( stack ) } ) # used with if
      add( 'end',     proc { |stack| Rpn::Core.__todo( stack ) } ) # used with various branch instructions
      add( 'start',   proc { |stack| Rpn::Core.__todo( stack ) } ) # <start> <end> start <instructions> next|<step> step
      add( 'for',     proc { |stack| Rpn::Core.__todo( stack ) } ) # <start> <end> for <variable> <instructions> next|<step> step
      add( 'next',    proc { |stack| Rpn::Core.__todo( stack ) } ) # used with start and for
      add( 'step',    proc { |stack| Rpn::Core.__todo( stack ) } ) # used with start and for
      add( 'ift',     proc { |stack| Rpn::Core.__todo( stack ) } ) # similar to if-then-end, <test-instruction> <true-instruction> ift
      add( 'ifte',    proc { |stack| Rpn::Core.__todo( stack ) } ) # similar to if-then-else-end, <test-instruction> <true-instruction> <false-instruction> ifte
      add( 'do',      proc { |stack| Rpn::Core.__todo( stack ) } ) # do <instructions> until <condition> end
      add( 'until',   proc { |stack| Rpn::Core.__todo( stack ) } ) # used with do
      add( 'while',   proc { |stack| Rpn::Core.__todo( stack ) } ) # while <test-instruction> repeat <loop-instructions> end
      add( 'repeat',  proc { |stack| Rpn::Core.__todo( stack ) } ) # used with while

      # STORE
      add( 'sto',     proc { |stack| Rpn::Core.__todo( stack ) } ) # store a variable. ex: 1 'name' sto
      add( 'rcl',     proc { |stack| Rpn::Core.__todo( stack ) } ) # recall a variable. ex: 'name' rcl
      add( 'purge',   proc { |stack| Rpn::Core.__todo( stack ) } ) # delete a variable. ex: 'name' purge
      add( 'vars',    proc { |stack| Rpn::Core.__todo( stack ) } ) # list all variables
      add( 'clusr',   proc { |stack| Rpn::Core.__todo( stack ) } ) # erase all variables
      add( 'edit',    proc { |stack| Rpn::Core.__todo( stack ) } ) # edit a variable content
      add( 'sto+',    proc { |stack| Rpn::Core.__todo( stack ) } ) # add to a stored variable. ex: 1 'name' sto+ 'name' 2 sto+
      add( 'sto-',    proc { |stack| Rpn::Core.__todo( stack ) } ) # substract to a stored variable. ex: 1 'name' sto- 'name' 2 sto-
      add( 'sto*',    proc { |stack| Rpn::Core.__todo( stack ) } ) # multiply a stored variable. ex: 3 'name' sto* 'name' 2 sto*
      add( 'sto/',    proc { |stack| Rpn::Core.__todo( stack ) } ) # divide a stored variable. ex: 3 'name' sto/ 'name' 2 sto/
      add( 'sneg',    proc { |stack| Rpn::Core.__todo( stack ) } ) # negate a variable. ex: 'name' sneg
      add( 'sinv',    proc { |stack| Rpn::Core.__todo( stack ) } ) # inverse a variable. ex: 1 'name' sinv

      # PROGRAM
      add( 'eval',    proc { |stack| Rpn::Core.__todo( stack ) } ) # evaluate (run) a program, or recall a variable. ex: 'my_prog' eval
      add( '->',      proc { |stack| Rpn::Core.__todo( stack ) } ) # load program local variables. ex: << -> n m << 0 n m for i i + next >> >>

      # TRIG ON REALS AND COMPLEXES
      add( 'pi',      proc { |stack| Rpn::Core.__todo( stack ) } ) # pi constant
      add( 'sin',     proc { |stack| Rpn::Core.__todo( stack ) } ) # sinus
      add( 'asin',    proc { |stack| Rpn::Core.__todo( stack ) } ) # arg sinus
      add( 'cos',     proc { |stack| Rpn::Core.__todo( stack ) } ) # cosinus
      add( 'acos',    proc { |stack| Rpn::Core.__todo( stack ) } ) # arg cosinus
      add( 'tan',     proc { |stack| Rpn::Core.__todo( stack ) } ) # tangent
      add( 'atan',    proc { |stack| Rpn::Core.__todo( stack ) } ) # arg tangent
      add( 'd->r',    proc { |stack| Rpn::Core.__todo( stack ) } ) # convert degrees to radians
      add( 'r->d',    proc { |stack| Rpn::Core.__todo( stack ) } ) # convert radians to degrees

      # LOGS ON REALS AND COMPLEXES
      add( 'e',       proc { |stack| Rpn::Core.__todo( stack ) } ) # Euler constant
      add( 'ln',      proc { |stack| Rpn::Core.__todo( stack ) } ) # logarithm base e
      add( 'lnp1',    proc { |stack| Rpn::Core.__todo( stack ) } ) # ln(1+x) which is useful when x is close to 0
      add( 'exp',     proc { |stack| Rpn::Core.__todo( stack ) } ) # exponential
      add( 'expm',    proc { |stack| Rpn::Core.__todo( stack ) } ) # exp(x)-1 which is useful when x is close to 0
      add( 'log10',   proc { |stack| Rpn::Core.__todo( stack ) } ) # logarithm base 10
      add( 'alog10',  proc { |stack| Rpn::Core.__todo( stack ) } ) # exponential base 10
      add( 'log2',    proc { |stack| Rpn::Core.__todo( stack ) } ) # logarithm base 2
      add( 'alog2',   proc { |stack| Rpn::Core.__todo( stack ) } ) # exponential base 2
      add( 'sinh',    proc { |stack| Rpn::Core.__todo( stack ) } ) # hyperbolic sine
      add( 'asinh',   proc { |stack| Rpn::Core.__todo( stack ) } ) # inverse hyperbolic sine
      add( 'cosh',    proc { |stack| Rpn::Core.__todo( stack ) } ) # hyperbolic cosine
      add( 'acosh',   proc { |stack| Rpn::Core.__todo( stack ) } ) # inverse hyperbolic cosine
      add( 'tanh',    proc { |stack| Rpn::Core.__todo( stack ) } ) # hyperbolic tangent
      add( 'atanh',   proc { |stack| Rpn::Core.__todo( stack ) } ) # inverse hyperbolic tangent

      # TIME AND DATE
      add( 'time',    proc { |stack| Rpn::Core.__todo( stack ) } ) # time in local format
      add( 'date',    proc { |stack| Rpn::Core.__todo( stack ) } ) # date in local format
      add( 'ticks',   proc { |stack| Rpn::Core.__todo( stack ) } ) # system tick in µs
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
