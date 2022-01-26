# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # set float precision in bits. ex: 256 prec
      def prec( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )

        Rpl::Lang::Core.precision = args[0][:value]

        [stack, dictionary]
      end

      # set float representation and precision to default
      def default( stack, dictionary )
        Rpl::Lang::Core.precision = 12

        [stack, dictionary]
      end

      # show type of stack first entry
      def type( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [:any] )

        stack << { type: :string,
                   value: args[0][:type].to_s }

        [stack, dictionary]
      end
    end
  end
end
