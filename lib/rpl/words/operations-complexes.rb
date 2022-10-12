# frozen_string_literal: true

module RplLang
  module Words
    module OperationsComplexes
      include Types

      def populate_dictionary
        super

        category = 'Operations on complexes'

        @dictionary.add_word!( ['re'],
                               category,
                               '( c -- n ) complex real part',
                               proc do
                                 args = stack_extract( [[RplComplex]] )

                                 @stack << RplNumeric.new( args[0].value.real )
                               end )

        @dictionary.add_word!( ['im'],
                               category,
                               '( c -- n ) complex imaginary part',
                               proc do
                                 args = stack_extract( [[RplComplex]] )

                                 @stack << RplNumeric.new( args[0].value.imaginary )
                               end )

        @dictionary.add_word!( ['conj'],
                               category,
                               '( c -- c ) complex conjugate',
                               proc do
                                 args = stack_extract( [[RplComplex]] )

                                 @stack << RplComplex.new( args[0].value.conjugate )
                               end )

        @dictionary.add_word!( ['arg'],
                               category,
                               '( c -- n ) complex argument in radians',
                               proc do
                                 args = stack_extract( [[RplComplex]] )

                                 @stack << RplNumeric.new( args[0].value.arg )
                               end )

        @dictionary.add_word!( ['c→r', 'c->r'],
                               category,
                               '( c -- n n ) transform a complex in 2 reals',
                               Types.new_object( RplProgram, '« dup re swap im »' ) )

        @dictionary.add_word!( ['r→c', 'r->c'],
                               category,
                               '( n n -- c ) transform 2 reals in a complex',
                               proc do
                                 args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                 complex_as_string = "(#{args[1].value}#{args[0].value.positive? ? '+' : ''}#{args[0].value}i)"
                                 @stack << RplComplex.new( complex_as_string )
                               end )

        # @dictionary.add_word!( ['p→r', 'p->r'],
        #                       category,
        #                       'cartesian to polar',
        #                       proc do

        #                       end )

        # @dictionary.add_word!( ['r→p', 'r->p'],
        #                       category,
        #                       'polar to cartesian',
        #                       proc do

        #                       end )
      end
    end
  end
end
