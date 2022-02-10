module Rpl
  module Lang
    module Core
      module_function

      # pi constant
      def pi
        @stack << { type: :numeric,
                    base: 10,
                    value: BigMath.PI( precision ) }
      end

      # sinus
      def sinus
        args = stack_extract( [%i[numeric]] )

        @stack << { type: :numeric,
                    base: infer_resulting_base( args ),
                    value: BigMath.sin( BigDecimal( args[0][:value], precision ), precision ) }
      end

      # https://rosettacode.org/wiki/Trigonometric_functions#Ruby
      # arg sinus
      def arg_sinus
        run( '
  dup abs 1 ==
  « 𝛑 2 / * »
  « dup sq 1 swap - sqrt / atan »
  ifte' )
      end

      # cosinus
      def cosinus
        args = stack_extract( [%i[numeric]] )

        @stack << { type: :numeric,
                    base: infer_resulting_base( args ),
                    value: BigMath.cos( BigDecimal( args[0][:value], precision ), precision ) }
      end

      # arg cosinus
      def arg_cosinus
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
      end

      # tangent
      def tangent
        run( 'dup sin swap cos /' )
      end

      # arg tangent
      def arg_tangent
        args = stack_extract( [%i[numeric]] )

        @stack << { type: :numeric,
                    base: infer_resulting_base( args ),
                    value: BigMath.atan( BigDecimal( args[0][:value], precision ), precision ) }
      end

      # convert degrees to radians
      def degrees_to_radians
        run( '180 / 𝛑 *' )
      end

      # convert radians to degrees
      def radians_to_degrees
        run( '𝛑 180 / /' )
      end
    end
  end
end
