module Rpl
  module Lang
    module Core
      module_function

      # pi constant
      def pi( stack, dictionary )
        stack << { type: :numeric,
                   base: 10,
                   value: BigMath.PI( Rpl::Core.precision ) }

        [stack, dictionary]
      end
    end
  end
end
