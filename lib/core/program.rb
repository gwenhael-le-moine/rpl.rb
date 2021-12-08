# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # evaluate (run) a program, or recall a variable. ex: 'my_prog' eval
      def eval( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [:any] )

        # we trim enclosing characters if necessary
        preparsed_input = %i[string name program].include?( args[0][:type] ) ? args[0][:value][1..-2] : args[0][:value]
        parsed_input = Rpl::Lang::Parser.new.parse_input( preparsed_input.to_s )

        stack, dictionary = Rpl::Lang::Runner.new.run_input( parsed_input,
                                                             stack, dictionary )

        [stack, dictionary]
      end
    end
  end
end
