# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # binary operator >
      def greater_than( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, %i[any any] )

        stack << { type: :boolean,
                   value: args[1][:value] > args[0][:value] }

        [stack, dictionary]
      end

      # binary operator >=
      def greater_than_or_equal( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, %i[any any] )

        stack << { type: :boolean,
                   value: args[1][:value] >= args[0][:value] }

        [stack, dictionary]
      end

      # binary operator <
      def less_than( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, %i[any any] )

        stack << { type: :boolean,
                   value: args[1][:value] < args[0][:value] }

        [stack, dictionary]
      end

      # binary operator <=
      def less_than_or_equal( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, %i[any any] )

        stack << { type: :boolean,
                   value: args[1][:value] <= args[0][:value] }

        [stack, dictionary]
      end

      # boolean operator != (different)
      def different( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, %i[any any] )

        stack << { type: :boolean,
                   value: args[1][:value] != args[0][:value] }

        [stack, dictionary]
      end

      # boolean operator and
      def and( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[boolean], %i[boolean]] )

        stack << { type: :boolean,
                   value: args[1][:value] && args[0][:value] }

        [stack, dictionary]
      end

      # boolean operator or
      def or( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[boolean], %i[boolean]] )

        stack << { type: :boolean,
                   value: args[1][:value] || args[0][:value] }

        [stack, dictionary]
      end

      # boolean operator xor
      def xor( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[boolean], %i[boolean]] )

        stack << { type: :boolean,
                   value: args[1][:value] ^ args[0][:value] }

        [stack, dictionary]
      end

      # boolean operator not
      def not( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[boolean]] )

        stack << { type: :boolean,
                   value: !args[0][:value] }

        [stack, dictionary]
      end

      # boolean operator same (equal)
      def same( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, %i[any any] )

        stack << { type: :boolean,
                   value: args[1][:value] == args[0][:value] }

        [stack, dictionary]
      end

      # true boolean
      def true( stack, dictionary )
        stack << { type: :boolean,
                   value: true }

        [stack, dictionary]
      end

      # false boolean
      def false( stack, dictionary )
        stack << { type: :boolean,
                   value: false }

        [stack, dictionary]
      end
    end
  end
end
