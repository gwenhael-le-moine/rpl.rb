# frozen_string_literal: true

module RplLang
  module Words
    module OperationsComplexes
      include Types

      def populate_dictionary
        super

        category = 'Operations on complexes'
        # Operations on complexes
        # @dictionary.add_word( ['re'],
        #                       category,
        #                       '( c -- n ) complex real part',
        #                       proc do

        #                       end )

        # @dictionary.add_word( 'im',
        #                       category,
        #                       '( c -- n ) complex imaginary part',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['conj'],
        #                       category,
        #                       '( c -- c ) complex conjugate',
        #                       proc do

        #                       end )

        # @dictionary.add_word( 'arg',
        #                       category,
        #                       'complex argument in radians',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['c→r', 'c->r'],
        #                       category,
        #                       '( c -- n n ) transform a complex in 2 reals',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['r→c', 'r->c'],
        #                       category,
        #                       '( n n -- c ) transform 2 reals in a complex',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['p→r', 'p->r'],
        #                       category,
        #                       'cartesian to polar',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['r→p', 'r->p'],
        #                       category,
        #                       'polar to cartesian',
        #                       proc do

        #                       end )
      end
    end
  end
end
