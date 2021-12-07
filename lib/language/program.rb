module Rpl
  module Lang
    module Core
      module_function

      # evaluate (run) a program, or recall a variable. ex: 'my_prog' eval
      def eval( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[program word name]] )

        # we trim enclosing «»
        preparsed_input = args[0][:type] == :word ? args[0][:value] : args[0][:value][1..-2]
        parsed_input = Rpl::Lang::Parser.new.parse_input( preparsed_input )

        stack, _dictionary = Rpl::Lang::Runner.new.run_input( stack, dictionary, parsed_input )
        # TODO: check that STO actually updates dictionary

        stack
      end
    end
  end
end
