# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # similar to if-then-else-end, <test-instruction> <true-instruction> <false-instruction> ifte
      def ifte( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[program word], %i[program word], %i[boolean]] )

        stack << args[ args[2][:value] ? 1 : 0 ]

        Rpl::Lang::Core.eval( stack, dictionary )
      end

      # similar to if-then-end, <test-instruction> <true-instruction> ift
      def ift( stack, dictionary )
        stack << { value: '« « nop » ifte »',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end
    end
  end
end
