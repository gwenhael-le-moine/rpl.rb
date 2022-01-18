module Rpl
  module Lang
    module Core
      module_function

      # Euler constant
      def e( stack, dictionary )
        stack << { type: :numeric,
                   base: 10,
                   value: BigMath.E( Rpl::Core.precision ) }

        [stack, dictionary]
      end
    end
  end
end
