# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # convert an object into a string
      def to_string
        args = stack_extract( [:any] )

        @stack << { type: :string,
                    value: stringify( args[0] ) }
      end

      # convert a string into an object
      def from_string
        args = stack_extract( [%i[string]] )

        @stack += parse( args[0][:value] )
      end

      # convert ASCII character code in stack level 1 into a string
      def chr
        args = stack_extract( [%i[numeric]] )

        @stack << { type: :string,
                    value: args[0][:value].to_i.chr }
      end

      # return ASCII code of the first character of the string in stack level 1 as a real number
      def num
        args = stack_extract( [%i[string]] )

        @stack << { type: :numeric,
                    base: 10,
                    value: args[0][:value].ord }
      end

      # return the length of the string
      def size
        args = stack_extract( [%i[string]] )

        @stack << { type: :numeric,
                    base: 10,
                    value: args[0][:value].length }
      end

      # search for the string in level 1 within the string in level 2
      def pos
        args = stack_extract( [%i[string], %i[string]] )

        @stack << { type: :numeric,
                    base: 10,
                    value: args[1][:value].index( args[0][:value] ) }
      end

      # return a substring of the string in level 3
      def sub
        args = stack_extract( [%i[numeric], %i[numeric], %i[string]] )

        @stack << { type: :string,
                    value: args[2][:value][ (args[1][:value] - 1)..(args[0][:value] - 1) ] }
      end

      # reverse string or list
      def rev
        args = stack_extract( [%i[string list]] )

        result = args[0]

        case args[0][:type]
        when :string
          result = { type: :string,
                     value: args[0][:value].reverse }
        when :list
          result[:value].reverse!
        end

        @stack << result
      end

      # split string
      def split
        args = stack_extract( [%i[string], %i[string]] )

        args[1][:value].split( args[0][:value] ).each do |elt|
          @stack << { type: :string,
                      value: elt }
        end
      end
    end
  end
end
