module Rpl
  module Core
    module_function

    # pi constant
    def pi( stack )
      stack << { type: :numeric,
                 base: 10,
                 value: BigMath.PI( Rpl::Core.precision ) }
      stack
    end
  end
end
