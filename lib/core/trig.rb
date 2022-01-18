module Rpl
  module Lang
    module Core
      module_function

      # pi constant
      def pi( stack, dictionary )
        stack << { type: :numeric,
                   base: 10,
                   value: BigMath.PI( Rpl::Lang::Core.precision ) }

        [stack, dictionary]
      end

      # sinus
      def sinus( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric,
                   base: infer_resulting_base( args ),
                   value: BigMath.sin( BigDecimal( args[0][:value], Rpl::Lang::Core.precision ), Rpl::Lang::Core.precision ) }

        [stack, dictionary]
      end

      # arg sinus
      def arg_sinus( stack, dictionary )
        # # Handle angles with no tangent.
        # return -PI / 2 if y == -1
        # return PI / 2 if y == 1

        # # Tangent of angle is y / x, where x^2 + y^2 = 1.
        # atan(y / sqrt(1 - y * y, prec), prec)
        stack << { value: '«
  dup abs 1 ==
  « pi 2 / * »
  « dup sq 1 swap - sqrt / atan »
  ifte
»',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end

      # cosinus
      def cosinus( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric,
                   base: infer_resulting_base( args ),
                   value: BigMath.cos( BigDecimal( args[0][:value], Rpl::Lang::Core.precision ), Rpl::Lang::Core.precision ) }

        [stack, dictionary]
      end

      # arg cosinus
      def arg_cosinus( stack, dictionary )
        stack << { value: '« dup 0 == « pi 2 / » « dup sq 1 swap - sqrt / atan dup 0 < « pi + » ift » ifte »',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end

      # tangent
      def tangent( stack, dictionary )
        stack << { value: '« dup sin swap cos / »',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end

      # arg tangent
      def arg_tangent( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric,
                   base: infer_resulting_base( args ),
                   value: BigMath.atan( BigDecimal( args[0][:value], Rpl::Lang::Core.precision ), Rpl::Lang::Core.precision ) }

        [stack, dictionary]
      end

      # convert degrees to radians
      def degrees_to_radians( stack, dictionary )
        stack << { value: '« 𝛑 * 180 / »',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end

      # convert radians to degrees
      def radians_to_degrees( stack, dictionary )
        stack << { value: '« 180 * 𝛑 / »',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end
    end
  end
end
