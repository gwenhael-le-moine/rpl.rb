module Rpl
  module Lang
    module Core
      module_function

      # Euler constant
      def e
        @stack << { type: :numeric,
                    base: 10,
                    value: BigMath.E( @precision ) }
      end
    end
  end
end
