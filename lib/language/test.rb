module Rpl
  module Lang
    module Core
      module_function

      # binary operator >
      def greater_than( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any any] )

        stack << { type: :boolean,
                   value: args[1][:value] > args[0][:value] }
        stack
      end

      # binary operator >=
      def greater_or_equal_than( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any any] )

        stack << { type: :boolean,
                   value: args[1][:value] >= args[0][:value] }
        stack
      end

      # binary operator <
      def less_than( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any any] )

        stack << { type: :boolean,
                   value: args[1][:value] < args[0][:value] }
        stack
      end

      # binary operator <=
      def less_or_equal_than( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any any] )

        stack << { type: :boolean,
                   value: args[1][:value] <= args[0][:value] }
        stack
      end

      # boolean operator != (different)
      def different( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any any] )

        stack << { type: :boolean,
                   value: args[1][:value] != args[0][:value] }
        stack
      end

      # boolean operator and
      def and( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[boolean], %i[boolean]] )

        stack << { type: :boolean,
                   value: args[1][:value] && args[0][:value] }
        stack
      end

      # boolean operator or
      def or( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[boolean], %i[boolean]] )

        stack << { type: :boolean,
                   value: args[1][:value] || args[0][:value] }
        stack
      end

      # boolean operator xor
      def xor( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[boolean], %i[boolean]] )

        stack << { type: :boolean,
                   value: args[1][:value] ^ args[0][:value] }
        stack
      end

      # boolean operator not
      def not( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[boolean]] )

        stack << { type: :boolean,
                   value: !args[0][:value] }
        stack
      end

      # boolean operator same (equal)
      def same( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any any] )

        stack << { type: :boolean,
                   value: args[1][:value] == args[0][:value] }
        stack
      end

      # true boolean
      def true( stack )
        stack << { type: :boolean,
                   value: true }
        stack
      end

      # false boolean
      def false( stack )
        stack << { type: :boolean,
                   value: false }
        stack
      end
    end
  end
end
