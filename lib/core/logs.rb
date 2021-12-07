module Rpl
  module Core
    module_function

    # Euler constant
    def e( stack )
      stack << { type: :numeric,
                 base: 10,
                 value: BigMath.E( Rpl::Core.precision ) }
      stack
    end
  end
end
