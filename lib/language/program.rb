module Rpn
  module Core
    module Program
      module_function

      # evaluate (run) a program, or recall a variable. ex: 'my_prog' eval
      def eval( stack, dictionary )
        stack, args = Rpn::Core.stack_extract( stack, [%i[program word name]] )

        # we trim enclosing «»
        preparsed_input = args[0][:type] == :word ? args[0][:value] : args[0][:value][1..-2]
        parsed_input = Rpn::Parser.new.parse_input( preparsed_input )

        stack, _dictionary = Rpn::Runner.new.run_input( stack, dictionary, parsed_input )
        # TODO: check that STO actually updates dictionary

        stack
      end
    end
  end
end
