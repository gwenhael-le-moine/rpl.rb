# frozen_string_literal: true

# https://rosettacode.org/wiki/Trigonometric_functions#Ruby

module RplLang
  module Words
    module Trig
      include Types

      def populate_dictionary
        super

        @dictionary.add_word( ['𝛑', 'pi'],
                              'Trig on reals and complexes',
                              '( … -- 𝛑 ) push 𝛑',
                              proc do
                                @stack << Types.new_object( RplNumeric, BigMath.PI( RplNumeric.precision ) )
                              end )

        @dictionary.add_word( ['sin'],
                              'Trig on reals and complexes',
                              '( n -- m ) compute sinus of n',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                @stack << Types.new_object( RplNumeric, BigMath.sin( BigDecimal( args[0].value, RplNumeric.precision ), RplNumeric.precision ) )
                              end )

        @dictionary.add_word( ['asin'],
                              'Trig on reals and complexes',
                              '( n -- m ) compute arg-sinus of n',
                              Types.new_object( RplProgram, '« dup abs 1 ==
  « 𝛑 2 / * »
  « dup sq 1 swap - sqrt / atan »
  ifte »' ) )

        @dictionary.add_word( ['cos'],
                              'Trig on reals and complexes',
                              '( n -- m ) compute cosinus of n',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                @stack << Types.new_object( RplNumeric, BigMath.cos( BigDecimal( args[0].value, RplNumeric.precision ), RplNumeric.precision ) )
                              end )
        @dictionary.add_word( ['acos'],
                              'Trig on reals and complexes',
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

        @dictionary.add_word( ['tan'],
                              'Trig on reals and complexes',
                              '( n -- m ) compute tangent of n',
                              Types.new_object( RplProgram, '« dup sin swap cos / »' ) )

        @dictionary.add_word( ['atan'],
                              'Trig on reals and complexes',
                              '( n -- m ) compute arc-tangent of n',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                @stack << Types.new_object( RplNumeric, BigMath.atan( BigDecimal( args[0].value, RplNumeric.precision ), RplNumeric.precision ) )
                              end )

        @dictionary.add_word( ['d→r', 'd->r'],
                              'Trig on reals and complexes',
                              '( n -- m ) convert degree to radian',
                              Types.new_object( RplProgram, '« 180 / 𝛑 * »' ) )

        @dictionary.add_word( ['r→d', 'r->d'],
                              'Trig on reals and complexes',
                              '( n -- m ) convert radian to degree',
                              Types.new_object( RplProgram, '« 𝛑 180 / / »' ) )
      end
    end
  end
end
