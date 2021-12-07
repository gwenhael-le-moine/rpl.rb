# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # convert an object into a string
      def to_string( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [:any] )

        stack << { type: :string,
                   value: args[0][:value].to_s }

        [stack, dictionary]
      end

      # convert a string into an object
      def from_string( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[string]] )

        parsed_input = Rpl::Lang::Parser.new.parse_input( args[0][:value] )

        stack += parsed_input

        [stack, dictionary]
      end

      # convert ASCII character code in stack level 1 into a string
      def chr( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )

        stack << { type: :string,
                   value: args[0][:value].chr }

        [stack, dictionary]
      end

      # return ASCII code of the first character of the string in stack level 1 as a real number
      def num( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[string]] )

        stack << { type: :numeric,
                   base: 10,
                   value: args[0][:value].ord }

        [stack, dictionary]
      end

      # return the length of the string
      def size( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[string]] )

        stack << { type: :numeric,
                   base: 10,
                   value: args[0][:value].length }

        [stack, dictionary]
      end

      # search for the string in level 1 within the string in level 2
      def pos( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[string], %i[string]] )

        stack << { type: :numeric,
                   base: 10,
                   value: args[1][:value].index( args[0][:value] ) }

        [stack, dictionary]
      end

      # return a substring of the string in level 3
      def sub( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric], %i[numeric], %i[string]] )

        stack << { type: :string,
                   value: args[2][:value][args[1][:value]..args[0][:value]] }

        [stack, dictionary]
      end
    end
  end
end
