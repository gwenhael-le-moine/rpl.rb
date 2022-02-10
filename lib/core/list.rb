# frozen_string_literal: true

module Lang
  module Core
    module_function

    # ( … x -- […] ) pack x stacks levels into a list
    def to_list
      args = stack_extract( [%i[numeric]] )
      args = stack_extract( %i[any] * args[0][:value] )

      @stack << { type: :list,
                  value: args.reverse }
    end

    # ( […] -- … ) unpack list on stack
    def unpack_list
      args = stack_extract( [%i[list]] )

      args[0][:value].each do |elt|
        @stack << elt
      end
    end
  end
end
