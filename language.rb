# frozen_string_literal: true

require './lib/core'
require './lib/dictionary'
require './lib/parser'
require './lib/runner'

module Rpl
  class Language
    attr_reader :stack, :dictionary

    def initialize( stack = [] )
      @stack = stack
      @dictionary = Rpl::Lang::Dictionary.new
      @parser = Rpl::Lang::Parser.new
      @runner = Rpl::Lang::Runner.new

      load_core
    end

    def load_core
      # GENERAL
      @dictionary.add( 'nop',     proc { |stack, dictionary| Rpl::Lang::Core.nop( stack, dictionary ) } )
      # @dictionary.add( 'help',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # this help message
      # @dictionary.add( 'quit',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # quit software
      # @dictionary.add( 'version', proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # show rpn version
      # @dictionary.add( 'uname',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # show rpn complete identification string
      # @dictionary.add( 'history', proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # see commands history

      # STACK
      @dictionary.add( 'swap',    proc { |stack, dictionary| Rpl::Lang::Core.swap( stack, dictionary ) } )
      @dictionary.add( 'drop',    proc { |stack, dictionary| Rpl::Lang::Core.drop( stack, dictionary ) } )
      @dictionary.add( 'drop2',   proc { |stack, dictionary| Rpl::Lang::Core.drop2( stack, dictionary ) } )
      @dictionary.add( 'dropn',   proc { |stack, dictionary| Rpl::Lang::Core.dropn( stack, dictionary ) } )
      @dictionary.add( 'del',     proc { |stack, dictionary| Rpl::Lang::Core.del( stack, dictionary ) } )
      @dictionary.add( 'rot',     proc { |stack, dictionary| Rpl::Lang::Core.rot( stack, dictionary ) } )
      @dictionary.add( 'dup',     proc { |stack, dictionary| Rpl::Lang::Core.dup( stack, dictionary ) } )
      @dictionary.add( 'dup2',    proc { |stack, dictionary| Rpl::Lang::Core.dup2( stack, dictionary ) } )
      @dictionary.add( 'dupn',    proc { |stack, dictionary| Rpl::Lang::Core.dupn( stack, dictionary ) } )
      @dictionary.add( 'pick',    proc { |stack, dictionary| Rpl::Lang::Core.pick( stack, dictionary ) } )
      @dictionary.add( 'depth',   proc { |stack, dictionary| Rpl::Lang::Core.depth( stack, dictionary ) } )
      @dictionary.add( 'roll',    proc { |stack, dictionary| Rpl::Lang::Core.roll( stack, dictionary ) } )
      @dictionary.add( 'rolld',   proc { |stack, dictionary| Rpl::Lang::Core.rolld( stack, dictionary ) } )
      @dictionary.add( 'over',    proc { |stack, dictionary| Rpl::Lang::Core.over( stack, dictionary ) } )

      # USUAL OPERATIONS ON REALS AND COMPLEXES
      @dictionary.add( '+',       proc { |stack, dictionary| Rpl::Lang::Core.add( stack, dictionary ) } )
      @dictionary.add( '-',       proc { |stack, dictionary| Rpl::Lang::Core.subtract( stack, dictionary ) } )
      @dictionary.add( 'chs',     proc { |stack, dictionary| Rpl::Lang::Core.negate( stack, dictionary ) } )
      @dictionary.add( '*',       proc { |stack, dictionary| Rpl::Lang::Core.multiply( stack, dictionary ) } )
      @dictionary.add( '×',       proc { |stack, dictionary| Rpl::Lang::Core.multiply( stack, dictionary ) } ) # alias
      @dictionary.add( '/',       proc { |stack, dictionary| Rpl::Lang::Core.divide( stack, dictionary ) } )
      @dictionary.add( '÷',       proc { |stack, dictionary| Rpl::Lang::Core.divide( stack, dictionary ) } ) # alias
      @dictionary.add( 'inv',     proc { |stack, dictionary| Rpl::Lang::Core.inverse( stack, dictionary ) } )
      @dictionary.add( '^',       proc { |stack, dictionary| Rpl::Lang::Core.power( stack, dictionary ) } )
      @dictionary.add( 'sqrt',    proc { |stack, dictionary| Rpl::Lang::Core.sqrt( stack, dictionary ) } )
      @dictionary.add( '√',       proc { |stack, dictionary| Rpl::Lang::Core.sqrt( stack, dictionary ) } ) # alias
      @dictionary.add( 'sq',      proc { |stack, dictionary| Rpl::Lang::Core.sq( stack, dictionary ) } )
      @dictionary.add( 'abs',     proc { |stack, dictionary| Rpl::Lang::Core.abs( stack, dictionary ) } )
      @dictionary.add( 'dec',     proc { |stack, dictionary| Rpl::Lang::Core.dec( stack, dictionary ) } )
      @dictionary.add( 'hex',     proc { |stack, dictionary| Rpl::Lang::Core.hex( stack, dictionary ) } )
      @dictionary.add( 'bin',     proc { |stack, dictionary| Rpl::Lang::Core.bin( stack, dictionary ) } )
      @dictionary.add( 'base',    proc { |stack, dictionary| Rpl::Lang::Core.base( stack, dictionary ) } )
      @dictionary.add( 'sign',    proc { |stack, dictionary| Rpl::Lang::Core.sign( stack, dictionary ) } )

      # OPERATIONS ON REALS
      @dictionary.add( '%',       proc { |stack, dictionary| Rpl::Lang::Core.percent( stack, dictionary ) } )
      @dictionary.add( '%CH',     proc { |stack, dictionary| Rpl::Lang::Core.inverse_percent( stack, dictionary ) } )
      @dictionary.add( 'mod',     proc { |stack, dictionary| Rpl::Lang::Core.mod( stack, dictionary ) } )
      @dictionary.add( 'fact',    proc { |stack, dictionary| Rpl::Lang::Core.fact( stack, dictionary ) } )
      @dictionary.add( '!',       proc { |stack, dictionary| Rpl::Lang::Core.fact( stack, dictionary ) } ) # alias
      @dictionary.add( 'floor',   proc { |stack, dictionary| Rpl::Lang::Core.floor( stack, dictionary ) } )
      @dictionary.add( 'ceil',    proc { |stack, dictionary| Rpl::Lang::Core.ceil( stack, dictionary ) } )
      @dictionary.add( 'min',     proc { |stack, dictionary| Rpl::Lang::Core.min( stack, dictionary ) } )
      @dictionary.add( 'max',     proc { |stack, dictionary| Rpl::Lang::Core.max( stack, dictionary ) } )
      # @dictionary.add( 'mant',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # mantissa of a real number
      # @dictionary.add( 'xpon',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exponant of a real number
      # @dictionary.add( 'ip',      proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # integer part
      # @dictionary.add( 'fp',      proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # fractional part

      # OPERATIONS ON COMPLEXES
      # @dictionary.add( 're',      proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # complex real part
      # @dictionary.add( 'im',      proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # complex imaginary part
      # @dictionary.add( 'conj',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # complex conjugate
      # @dictionary.add( 'arg',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # complex argument in radians
      # @dictionary.add( 'c->r',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # transform a complex in 2 reals
      # @dictionary.add( 'c→r',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias
      # @dictionary.add( 'r->c',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # transform 2 reals in a complex
      # @dictionary.add( 'r→c',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias
      # @dictionary.add( 'p->r',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # cartesian to polar
      # @dictionary.add( 'p→r',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias
      # @dictionary.add( 'r->p',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # polar to cartesian
      # @dictionary.add( 'r→p',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias

      # MODE
      @dictionary.add( 'prec',    proc { |stack, dictionary| Rpl::Lang::Core.prec( stack, dictionary ) } )
      @dictionary.add( 'default', proc { |stack, dictionary| Rpl::Lang::Core.default( stack, dictionary ) } )
      @dictionary.add( 'type',    proc { |stack, dictionary| Rpl::Lang::Core.type( stack, dictionary ) } )
      # @dictionary.add( 'std',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # standard floating numbers representation. ex: std
      # @dictionary.add( 'fix',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # fixed point representation. ex: 6 fix
      # @dictionary.add( 'sci',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # scientific floating point representation. ex: 20 sci
      # @dictionary.add( 'round',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # set float rounding mode. ex: ["nearest", "toward zero", "toward +inf", "toward -inf", "away from zero"] round

      # TEST
      @dictionary.add( '>',       proc { |stack, dictionary| Rpl::Lang::Core.greater_than( stack, dictionary ) } )
      @dictionary.add( '>=',      proc { |stack, dictionary| Rpl::Lang::Core.greater_than_or_equal( stack, dictionary ) } )
      @dictionary.add( '≥',       proc { |stack, dictionary| Rpl::Lang::Core.greater_than_or_equal( stack, dictionary ) } ) # alias
      @dictionary.add( '<',       proc { |stack, dictionary| Rpl::Lang::Core.less_than( stack, dictionary ) } )
      @dictionary.add( '<=',      proc { |stack, dictionary| Rpl::Lang::Core.less_than_or_equal( stack, dictionary ) } )
      @dictionary.add( '≤',       proc { |stack, dictionary| Rpl::Lang::Core.less_than_or_equal( stack, dictionary ) } ) # alias
      @dictionary.add( '!=',      proc { |stack, dictionary| Rpl::Lang::Core.different( stack, dictionary ) } )
      @dictionary.add( '≠',       proc { |stack, dictionary| Rpl::Lang::Core.different( stack, dictionary ) } ) # alias
      @dictionary.add( '==',      proc { |stack, dictionary| Rpl::Lang::Core.same( stack, dictionary ) } ) # alias
      @dictionary.add( 'and',     proc { |stack, dictionary| Rpl::Lang::Core.and( stack, dictionary ) } )
      @dictionary.add( 'or',      proc { |stack, dictionary| Rpl::Lang::Core.or( stack, dictionary ) } )
      @dictionary.add( 'xor',     proc { |stack, dictionary| Rpl::Lang::Core.xor( stack, dictionary ) } )
      @dictionary.add( 'not',     proc { |stack, dictionary| Rpl::Lang::Core.not( stack, dictionary ) } )
      @dictionary.add( 'same',    proc { |stack, dictionary| Rpl::Lang::Core.same( stack, dictionary ) } )
      @dictionary.add( 'true',    proc { |stack, dictionary| Rpl::Lang::Core.true( stack, dictionary ) } ) # specific
      @dictionary.add( 'false',   proc { |stack, dictionary| Rpl::Lang::Core.false( stack, dictionary ) } ) # specific

      # STRING
      @dictionary.add( '->str',   proc { |stack, dictionary| Rpl::Lang::Core.to_string( stack, dictionary ) } )
      @dictionary.add( '→str',    proc { |stack, dictionary| Rpl::Lang::Core.to_string( stack, dictionary ) } ) # alias
      @dictionary.add( 'str->',   proc { |stack, dictionary| Rpl::Lang::Core.from_string( stack, dictionary ) } )
      @dictionary.add( 'str→',    proc { |stack, dictionary| Rpl::Lang::Core.from_string( stack, dictionary ) } ) # alias
      @dictionary.add( 'chr',     proc { |stack, dictionary| Rpl::Lang::Core.chr( stack, dictionary ) } )
      @dictionary.add( 'num',     proc { |stack, dictionary| Rpl::Lang::Core.num( stack, dictionary ) } )
      @dictionary.add( 'size',    proc { |stack, dictionary| Rpl::Lang::Core.size( stack, dictionary ) } )
      @dictionary.add( 'pos',     proc { |stack, dictionary| Rpl::Lang::Core.pos( stack, dictionary ) } )
      @dictionary.add( 'sub',     proc { |stack, dictionary| Rpl::Lang::Core.sub( stack, dictionary ) } )
      @dictionary.add( 'rev',     proc { |stack, dictionary| Rpl::Lang::Core.rev( stack, dictionary ) } ) # specific
      @dictionary.add( 'split',   proc { |stack, dictionary| Rpl::Lang::Core.split( stack, dictionary ) } ) # specific

      # BRANCH
      @dictionary.add( 'ift',     proc { |stack, dictionary| Rpl::Lang::Core.ift( stack, dictionary ) } )
      @dictionary.add( 'ifte',    proc { |stack, dictionary| Rpl::Lang::Core.ifte( stack, dictionary ) } )
      @dictionary.add( 'times',   proc { |stack, dictionary| Rpl::Lang::Core.times( stack, dictionary ) } ) # specific
      @dictionary.add( 'loop',    proc { |stack, dictionary| Rpl::Lang::Core.loop( stack, dictionary ) } ) # specific
      # @dictionary.add( 'if',      proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # if <test-instruction> then <true-instructions> else <false-instructions> end
      # @dictionary.add( 'then',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with if
      # @dictionary.add( 'else',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with if
      # @dictionary.add( 'end',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with various branch instructions
      # @dictionary.add( 'start',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # <start> <end> start <instructions> next|<step> step
      # @dictionary.add( 'for',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # <start> <end> for <variable> <instructions> next|<step> step
      # @dictionary.add( 'next',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with start and for
      # @dictionary.add( 'step',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with start and for
      # @dictionary.add( 'do',      proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # do <instructions> until <condition> end
      # @dictionary.add( 'until',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with do
      # @dictionary.add( 'while',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # while <test-instruction> repeat <loop-instructions> end
      # @dictionary.add( 'repeat',  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # used with while

      # STORE
      @dictionary.add( 'sto',     proc { |stack, dictionary| Rpl::Lang::Core.sto( stack, dictionary ) } )
      @dictionary.add( '▶',       proc { |stack, dictionary| Rpl::Lang::Core.sto( stack, dictionary ) } ) # alias
      @dictionary.add( 'rcl',     proc { |stack, dictionary| Rpl::Lang::Core.rcl( stack, dictionary ) } )
      @dictionary.add( 'purge',   proc { |stack, dictionary| Rpl::Lang::Core.purge( stack, dictionary ) } )
      @dictionary.add( 'vars',    proc { |stack, dictionary| Rpl::Lang::Core.vars( stack, dictionary ) } )
      @dictionary.add( 'clusr',   proc { |stack, dictionary| Rpl::Lang::Core.clusr( stack, dictionary ) } )
      @dictionary.add( 'sto+',    proc { |stack, dictionary| Rpl::Lang::Core.sto_add( stack, dictionary ) } )
      @dictionary.add( 'sto-',    proc { |stack, dictionary| Rpl::Lang::Core.sto_subtract( stack, dictionary ) } )
      @dictionary.add( 'sto*',    proc { |stack, dictionary| Rpl::Lang::Core.sto_multiply( stack, dictionary ) } )
      @dictionary.add( 'sto×',    proc { |stack, dictionary| Rpl::Lang::Core.sto_multiply( stack, dictionary ) } ) # alias
      @dictionary.add( 'sto/',    proc { |stack, dictionary| Rpl::Lang::Core.sto_divide( stack, dictionary ) } )
      @dictionary.add( 'sto÷',    proc { |stack, dictionary| Rpl::Lang::Core.sto_divide( stack, dictionary ) } ) # alias
      @dictionary.add( 'sneg',    proc { |stack, dictionary| Rpl::Lang::Core.sto_negate( stack, dictionary ) } )
      @dictionary.add( 'sinv',    proc { |stack, dictionary| Rpl::Lang::Core.sto_inverse( stack, dictionary ) } )
      # @dictionary.add( 'edit',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # edit a variable content

      # PROGRAM
      @dictionary.add( 'eval',    proc { |stack, dictionary| Rpl::Lang::Core.eval( stack, dictionary ) } )
      # @dictionary.add( '->',      proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # load program local variables. ex: « → n m « 0 n m for i i + next » »
      # @dictionary.add( '→',       proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias

      # TRIG ON REALS AND COMPLEXES
      @dictionary.add( 'pi',      proc { |stack, dictionary| Rpl::Lang::Core.pi( stack, dictionary ) } )
      @dictionary.add( '𝛑',       proc { |stack, dictionary| Rpl::Lang::Core.pi( stack, dictionary ) } ) # alias
      # @dictionary.add( 'sin',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # sinus
      # @dictionary.add( 'asin',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # arg sinus
      # @dictionary.add( 'cos',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # cosinus
      # @dictionary.add( 'acos',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # arg cosinus
      # @dictionary.add( 'tan',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # tangent
      # @dictionary.add( 'atan',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # arg tangent
      # @dictionary.add( 'd->r',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # convert degrees to radians
      # @dictionary.add( 'd→r',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias
      # @dictionary.add( 'r->d',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # convert radians to degrees
      # @dictionary.add( 'r→d',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias

      # LOGS ON REALS AND COMPLEXES
      @dictionary.add( 'e',       proc { |stack, dictionary| Rpl::Lang::Core.e( stack, dictionary ) } )
      @dictionary.add( 'ℇ',       proc { |stack, dictionary| Rpl::Lang::Core.e( stack, dictionary ) } ) # alias
      # @dictionary.add( 'ln',      proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # logarithm base e
      # @dictionary.add( 'lnp1',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # ln(1+x) which is useful when x is close to 0
      # @dictionary.add( 'exp',     proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exponential
      # @dictionary.add( 'expm',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exp(x)-1 which is useful when x is close to 0
      # @dictionary.add( 'log10',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # logarithm base 10
      # @dictionary.add( 'alog10',  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exponential base 10
      # @dictionary.add( 'log2',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # logarithm base 2
      # @dictionary.add( 'alog2',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # exponential base 2
      # @dictionary.add( 'sinh',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # hyperbolic sine
      # @dictionary.add( 'asinh',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # inverse hyperbolic sine
      # @dictionary.add( 'cosh',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # hyperbolic cosine
      # @dictionary.add( 'acosh',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # inverse hyperbolic cosine
      # @dictionary.add( 'tanh',    proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # hyperbolic tangent
      # @dictionary.add( 'atanh',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # inverse hyperbolic tangent

      # TIME AND DATE
      @dictionary.add( 'time',    proc { |stack, dictionary| Rpl::Lang::Core.time( stack, dictionary ) } )
      @dictionary.add( 'date',    proc { |stack, dictionary| Rpl::Lang::Core.date( stack, dictionary ) } )
      @dictionary.add( 'ticks',   proc { |stack, dictionary| Rpl::Lang::Core.ticks( stack, dictionary ) } )

      # Rpl.rb specifics
      # LISTS
      # @dictionary.add( '->LIST',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # ( … x -- […] ) pack x stacks levels into a list
      # @dictionary.add( '→LIST',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias
      # @dictionary.add( 'LIST->',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # ( […] -- … ) unpack list on stack
      # @dictionary.add( 'LIST→',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # alias

      # FILESYSTEM
      @dictionary.add( 'fread',   proc { |stack, dictionary| Rpl::Lang::Core.fread( stack, dictionary ) } )
      # @dictionary.add( 'fload',   proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # ( filename -- … ) « FREAD EVAL »
      # @dictionary.add( 'fwrite',  proc { |stack, dictionary| Rpl::Lang::Core.__todo( stack, dictionary ) } ) # ( content filename mode -- ) write content into filename using mode (w, a, …)

      # GRAPHICS
    end

    def run( input )
      @stack, @dictionary = @runner.run_input( @parser.parse_input( input ),
                                               @stack, @dictionary )
    end
  end
end
