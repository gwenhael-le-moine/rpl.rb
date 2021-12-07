# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # evaluate (run) a program, or recall a variable. ex: 'my_prog' eval
      def sto( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [:any, %i[name]] )

        # TODO
        dictionary.add( args[1][:value], proc { |stk| Rpl::Lang::Core.eval( stk << args[0][:value], dictionary ) } )

        [stack, dictionary]
      end
    end
  end
end
