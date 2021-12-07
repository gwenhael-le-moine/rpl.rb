# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # convert an object into a string
      def to_string( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [:any] )

        stack << { type: :string,
                   value: args[0][:value].to_s }
      end

      # convert a string into an object
      def from_string( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[string]] )

        parsed_input = Rpl::Lang::Parser.new.parse_input( args[0][:value] )

        stack + parsed_input
      end

      # convert ASCII character code in stack level 1 into a string
      def chr( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )

        stack << { type: :string,
                   value: args[0][:value].chr }
      end

      # return ASCII code of the first character of the string in stack level 1 as a real number
      def num( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[string]] )

        stack << { type: :numeric,
                   base: 10,
                   value: args[0][:value].ord }
      end

      # return the length of the string
      def size( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[string]] )

        stack << { type: :numeric,
                   base: 10,
                   value: args[0][:value].length }
      end

      # search for the string in level 1 within the string in level 2
      def pos( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[string], %i[string]] )

        stack << { type: :numeric,
                   base: 10,
                   value: args[1][:value].index( args[0][:value] ) }
      end

      # return a substring of the string in level 3
      def sub( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric], %i[numeric], %i[string]] )

        stack << { type: :string,
                   value: args[2][:value][args[1][:value]..args[0][:value]] }
      end
    end
  end
end
