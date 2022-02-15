# frozen_string_literal: true

# https://rosettacode.org/wiki/Trigonometric_functions#Ruby

module RplLang
  module Core
    module Trig
      def populate_dictionary
        super

        @dictionary.add_word( ['𝛑', 'pi'],
                              'Trig on reals and complexes',
                              '( … -- 𝛑 ) push 𝛑',
                              proc do
                                @stack << { type: :numeric,
                                            base: 10,
                                            value: BigMath.PI( precision ) }
                              end )

        @dictionary.add_word( ['sin'],
                              'Trig on reals and complexes',
                              '( n -- m ) compute sinus of n',
                              proc do
                                args = stack_extract( [%i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: BigMath.sin( BigDecimal( args[0][:value], precision ), precision ) }
                              end )

        @dictionary.add_word( ['asin'],
                              'Trig on reals and complexes',
                              '( n -- m ) compute arg-sinus of n',
                              proc do
                                run( '
  dup abs 1 ==
  « 𝛑 2 / * »
  « dup sq 1 swap - sqrt / atan »
  ifte' )
                              end )

        @dictionary.add_word( ['cos'],
                              'Trig on reals and complexes',
                              '( n -- m ) compute cosinus of n',
                              proc do
                                args = stack_extract( [%i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: BigMath.cos( BigDecimal( args[0][:value], precision ), precision ) }
                              end )
        @dictionary.add_word( ['acos'],
                              'Trig on reals and complexes',
                              '( n -- m ) compute arg-cosinus of n',
                              proc do
                                run( '
  dup 0 ==
  « drop 𝛑 2 / »
  «
    dup sq 1 swap - sqrt / atan
    dup 0 <
    « 𝛑 + »
    ift
  »
  ifte' )
                              end )

        @dictionary.add_word( ['tan'],
                              'Trig on reals and complexes',
                              '( n -- m ) compute tangent of n',
                              proc do
                                run( 'dup sin swap cos /' )
                              end )

        @dictionary.add_word( ['atan'],
                              'Trig on reals and complexes',
                              '( n -- m ) compute arc-tangent of n',
                              proc do
                                args = stack_extract( [%i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: BigMath.atan( BigDecimal( args[0][:value], precision ), precision ) }
                              end)
        @dictionary.add_word( ['d→r', 'd->r'],
                              'Trig on reals and complexes',
                              '( n -- m ) convert degree to radian',
                              proc do
                                run( '180 / 𝛑 *' )
                              end )
        @dictionary.add_word( ['r→d', 'r->d'],
                              'Trig on reals and complexes',
                              '( n -- m ) convert radian to degree',
                              proc do
                                run( '𝛑 180 / /' )
                              end)
      end
    end
  end
end
