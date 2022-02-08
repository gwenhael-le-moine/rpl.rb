# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # ( … x -- […] ) pack x stacks levels into a list
      def to_list( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric]] )
        stack, args = Rpl::Lang.stack_extract( stack, %i[any] * args[0][:value] )

        stack << { type: :list,
                   value: args.reverse }

        [stack, dictionary]
      end

      # ( […] -- … ) unpack list on stack
      def unpack_list( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[list]] )

        args[0][:value].each do |elt|
          stack << elt
        end

        [stack, dictionary]
      end
    end
  end
end
