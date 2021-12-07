# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # no operation
      def nop( stack, dictionary )
        [stack, dictionary]
      end
    end
  end
end
