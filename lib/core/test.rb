# frozen_string_literal: true

module Lang
  module Core
    # binary operator >
    def greater_than
      args = stack_extract( %i[any any] )

      @stack << { type: :boolean,
                  value: args[1][:value] > args[0][:value] }
    end

    # binary operator >=
    def greater_than_or_equal
      args = stack_extract( %i[any any] )

      @stack << { type: :boolean,
                  value: args[1][:value] >= args[0][:value] }
    end

    # binary operator <
    def less_than
      args = stack_extract( %i[any any] )

      @stack << { type: :boolean,
                  value: args[1][:value] < args[0][:value] }
    end

    # binary operator <=
    def less_than_or_equal
      args = stack_extract( %i[any any] )

      @stack << { type: :boolean,
                  value: args[1][:value] <= args[0][:value] }
    end

    # boolean operator != (different)
    def different
      args = stack_extract( %i[any any] )

      @stack << { type: :boolean,
                  value: args[1][:value] != args[0][:value] }
    end

    # boolean operator and
    def boolean_and
      args = stack_extract( [%i[boolean], %i[boolean]] )

      @stack << { type: :boolean,
                  value: args[1][:value] && args[0][:value] }
    end

    # boolean operator or
    def boolean_or
      args = stack_extract( [%i[boolean], %i[boolean]] )

      @stack << { type: :boolean,
                  value: args[1][:value] || args[0][:value] }
    end

    # boolean operator xor
    def xor
      args = stack_extract( [%i[boolean], %i[boolean]] )

      @stack << { type: :boolean,
                  value: args[1][:value] ^ args[0][:value] }
    end

    # boolean operator not
    def boolean_not
      args = stack_extract( [%i[boolean]] )

      @stack << { type: :boolean,
                  value: !args[0][:value] }
    end

    # boolean operator same (equal)
    def same
      args = stack_extract( %i[any any] )

      @stack << { type: :boolean,
                  value: args[1][:value] == args[0][:value] }
    end

    # true boolean
    def boolean_true
      @stack << { type: :boolean,
                  value: true }
    end

    # false boolean
    def boolean_false
      @stack << { type: :boolean,
                  value: false }
    end
  end
end
