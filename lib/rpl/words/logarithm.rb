# frozen_string_literal: true

module RplLang
  module Words
    module Logarithm
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

        # @dictionary.add_word( ['ln'],
        #                       'Logs on reals and complexes',
        #                       'logarithm base e',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['lnp1'],
        #                       'Logs on reals and complexes',
        #                       'ln(1+x) which is useful when x is close to 0',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['exp'],
        #                       'Logs on reals and complexes',
        #                       'exponential',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['expm'],
        #                       'Logs on reals and complexes',
        #                       'exp(x)-1 which is useful when x is close to 0',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['log10'],
        #                       'Logs on reals and complexes',
        #                       'logarithm base 10',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['alog10'],
        #                       'Logs on reals and complexes',
        #                       'exponential base 10',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['log2'],
        #                       'Logs on reals and complexes',
        #                       'logarithm base 2',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['alog2'],
        #                       'Logs on reals and complexes',
        #                       'exponential base 2',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['sinh'],
        #                       'Logs on reals and complexes',
        #                       'hyperbolic sine',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['asinh'],
        #                       'Logs on reals and complexes',
        #                       'inverse hyperbolic sine',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['cosh'],
        #                       'Logs on reals and complexes',
        #                       'hyperbolic cosine',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['acosh'],
        #                       'Logs on reals and complexes',
        #                       'inverse hyperbolic cosine',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['tanh'],
        #                       'Logs on reals and complexes',
        #                       'hyperbolic tangent',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['atanh'],
        #                       'Logs on reals and complexes',
        #                       'inverse hyperbolic tangent',
        #                       proc do

        #                       end )
      end
    end
  end
end
