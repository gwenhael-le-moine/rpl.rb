# frozen_string_literal: true

module RplLang
  module Words
    module Logarithm
      include Types

      def populate_dictionary
        super

        category = 'Logs on reals and complexes'

        @dictionary.add_word!( ['ℇ', 'e'],
                               category,
                               '( … -- ℇ ) push ℇ',
                               proc do
                                 @stack << Types.new_object( RplNumeric, BigMath.E( RplNumeric.precision ) )
                               end )

        # @dictionary.add_word!( ['ln'],
        #                       category,
        #                       'logarithm base e',
        #                       proc do

        #                       end )

        # @dictionary.add_word!( ['lnp1'],
        #                       category,
        #                       'ln(1+x) which is useful when x is close to 0',
        #                       proc do

        #                       end )

        # @dictionary.add_word!( ['exp'],
        #                       category,
        #                       'exponential',
        #                       proc do

        #                       end )

        # @dictionary.add_word!( ['expm'],
        #                       category,
        #                       'exp(x)-1 which is useful when x is close to 0',
        #                       proc do

        #                       end )

        # @dictionary.add_word!( ['log10'],
        #                       category,
        #                       'logarithm base 10',
        #                       proc do

        #                       end )

        # @dictionary.add_word!( ['alog10'],
        #                       category,
        #                       'exponential base 10',
        #                       proc do

        #                       end )

        # @dictionary.add_word!( ['log2'],
        #                       category,
        #                       'logarithm base 2',
        #                       proc do

        #                       end )

        # @dictionary.add_word!( ['alog2'],
        #                       category,
        #                       'exponential base 2',
        #                       proc do

        #                       end )

        # @dictionary.add_word!( ['sinh'],
        #                       category,
        #                       'hyperbolic sine',
        #                       proc do

        #                       end )

        # @dictionary.add_word!( ['asinh'],
        #                       category,
        #                       'inverse hyperbolic sine',
        #                       proc do

        #                       end )

        # @dictionary.add_word!( ['cosh'],
        #                       category,
        #                       'hyperbolic cosine',
        #                       proc do

        #                       end )

        # @dictionary.add_word!( ['acosh'],
        #                       category,
        #                       'inverse hyperbolic cosine',
        #                       proc do

        #                       end )

        # @dictionary.add_word!( ['tanh'],
        #                       category,
        #                       'hyperbolic tangent',
        #                       proc do

        #                       end )

        # @dictionary.add_word!( ['atanh'],
        #                       category,
        #                       'inverse hyperbolic tangent',
        #                       proc do

        #                       end )
      end
    end
  end
end
