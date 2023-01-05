# frozen_string_literal: true

# https://rosettacode.org/wiki/Trigonometric_functions#Ruby

module RplLang
  module Words
    module Trig
      include Types

      def populate_dictionary
        super

        category = 'Trig on reals and complexes'

        @dictionary.add_word!( %w[𝛑 pi],
                               category,
                               '( … -- 𝛑 ) push 𝛑',
                               proc do
                                 @stack << Types.new_object( RplNumeric, BigMath.PI( RplNumeric.precision ) )
                               end )

        @dictionary.add_word!( ['sin'],
                               category,
                               '( n -- m ) compute sinus of n',
                               proc do
                                 args = stack_extract( [[RplNumeric]] )

                                 @stack << Types.new_object( RplNumeric, BigMath.sin( BigDecimal( args[0].value, RplNumeric.precision ), RplNumeric.precision ) )
                               end )

        @dictionary.add_word!( ['asin'],
                               category,
                               '( n -- m ) compute arg-sinus of n',
                               Types.new_object( RplProgram, '« dup abs 1 ==
  « 𝛑 2 / * »
  « dup sq 1 swap - sqrt / atan »
  ifte »' ) )

        @dictionary.add_word!( ['cos'],
                               category,
                               '( n -- m ) compute cosinus of n',
                               proc do
                                 args = stack_extract( [[RplNumeric]] )

                                 @stack << Types.new_object( RplNumeric, BigMath.cos( BigDecimal( args[0].value, RplNumeric.precision ), RplNumeric.precision ) )
                               end )
        @dictionary.add_word!( ['acos'],
                               category,
                               '( n -- m ) compute arg-cosinus of n',
                               Types.new_object( RplProgram, '« dup 0 ==
  « drop 𝛑 2 / »
  «
    dup sq 1 swap - sqrt / atan
    dup 0 <
    « 𝛑 + »
    ift
  »
  ifte »' ) )

        @dictionary.add_word!( ['tan'],
                               category,
                               '( n -- m ) compute tangent of n',
                               Types.new_object( RplProgram, '« dup sin swap cos / »' ) )

        @dictionary.add_word!( ['atan'],
                               category,
                               '( n -- m ) compute arc-tangent of n',
                               proc do
                                 args = stack_extract( [[RplNumeric]] )

                                 @stack << Types.new_object( RplNumeric, BigMath.atan( BigDecimal( args[0].value, RplNumeric.precision ), RplNumeric.precision ) )
                               end )

        @dictionary.add_word!( ['d→r', 'd->r'],
                               category,
                               '( n -- m ) convert degree to radian',
                               Types.new_object( RplProgram, '« 180 / 𝛑 * »' ) )

        @dictionary.add_word!( ['r→d', 'r->d'],
                               category,
                               '( n -- m ) convert radian to degree',
                               Types.new_object( RplProgram, '« 𝛑 180 / / »' ) )
      end
    end
  end
end
