# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # evaluate (run) a program, or recall a variable. ex: 'my_prog' eval
      def eval( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [:any] )

        Rpl::Lang.eval( stack, dictionary,
                        args[0][:value].to_s )
      end
    end
  end
end
