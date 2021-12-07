# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # set float precision in bits. ex: 256 prec
      def prec( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )

        Rpl::Lang::Core.precision = args[0][:value]

        stack
      end

      # set float representation and precision to default
      def default( stack )
        Rpl::Lang::Core.precision = 12

        stack
      end

      # show type of stack first entry
      def type( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [:any] )

        stack << args[0]
        stack << { type: :string,
                   value: args[0][:type].to_s }
        stack
      end
    end
  end
end
