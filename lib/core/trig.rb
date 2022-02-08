module Rpl
  module Lang
    module Core
      module_function

      # pi constant
      def pi( stack, dictionary )
        stack << { type: :numeric,
                   base: 10,
                   value: BigMath.PI( Rpl::Lang.precision ) }

        [stack, dictionary]
      end

      # sinus
      def sinus( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric,
                   base: Rpl::Lang.infer_resulting_base( args ),
                   value: BigMath.sin( BigDecimal( args[0][:value], Rpl::Lang.precision ), Rpl::Lang.precision ) }

        [stack, dictionary]
      end

      # https://rosettacode.org/wiki/Trigonometric_functions#Ruby
      # arg sinus
      def arg_sinus( stack, dictionary )
        Rpl::Lang.eval( stack, dictionary, '
  dup abs 1 ==
  « 𝛑 2 / * »
  « dup sq 1 swap - sqrt / atan »
  ifte' )
      end

      # cosinus
      def cosinus( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric,
                   base: Rpl::Lang.infer_resulting_base( args ),
                   value: BigMath.cos( BigDecimal( args[0][:value], Rpl::Lang.precision ), Rpl::Lang.precision ) }

        [stack, dictionary]
      end

      # arg cosinus
      def arg_cosinus( stack, dictionary )
        Rpl::Lang.eval( stack, dictionary, '
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
      def tangent( stack, dictionary )
        Rpl::Lang.eval( stack, dictionary, 'dup sin swap cos /' )
      end

      # arg tangent
      def arg_tangent( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric,
                   base: Rpl::Lang.infer_resulting_base( args ),
                   value: BigMath.atan( BigDecimal( args[0][:value], Rpl::Lang.precision ), Rpl::Lang.precision ) }

        [stack, dictionary]
      end

      # convert degrees to radians
      def degrees_to_radians( stack, dictionary )
        Rpl::Lang.eval( stack, dictionary, '𝛑 180 / *' )
      end

      # convert radians to degrees
      def radians_to_degrees( stack, dictionary )
        Rpl::Lang.eval( stack, dictionary, '𝛑 180 / /' )
      end
    end
  end
end
