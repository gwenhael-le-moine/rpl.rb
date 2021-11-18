module Rpn
  module Core
    module Program
      module_function

      # power
      def eval( stack, dictionary )
        stack, args = Rpn::Core.stack_extract( stack, [%i[program]] )

        # we trim enclosing «»
        parsed_input = Rpn::Parser.new.parse_input( args[0][:value][1..-2] )

        stack, _dictionary = Rpn::Runner.new.run_input( stack, dictionary, parsed_input )
        # TODO: check that STO actually updates dictionary

        stack
      end
    end
  end
end
