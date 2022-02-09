# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # no operation
      def nop( stack, dictionary )
        [stack, dictionary]
      end

      # show version
      def version( stack, dictionary )
        stack += Rpl::Interpreter.parse( Rpl::Lang.version.to_s )

        [stack, dictionary]
      end

      # show complete identification string
      def uname( stack, dictionary )
        stack += Rpl::Interpreter.parse( "\"Rpl Interpreter version #{Rpl::Lang.version}\"" )

        [stack, dictionary]
      end

    end
  end
end
