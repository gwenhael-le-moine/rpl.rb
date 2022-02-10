# frozen_string_literal: true

module Lang
  module Core
    module_function

    # set float precision in bits. ex: 256 prec
    def prec
      args = stack_extract( [%i[numeric]] )

      @precision = args[0][:value]
    end

    # set float representation and precision to default
    def default
      @precision = default_precision
    end

    # show type of stack first entry
    def type
      args = stack_extract( [:any] )

      @stack << { type: :string,
                  value: args[0][:type].to_s }
    end
  end
end
