# frozen_string_literal: true

module RplLang
  module Core
    module Logs
      def populate_dictionary
        super

        @dictionary.add_word( ['ℇ', 'e'],
                              'Logs on reals and complexes',
                              '( … -- ℇ ) push ℇ',
                              proc do
                                     @stack << { type: :numeric,
                                                 base: 10,
                                                 value: BigMath.E( @precision ) }
                                   end )
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

      end
    end
  end
end
