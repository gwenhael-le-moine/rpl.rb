require 'bigdecimal/math'

require_relative './language/branch'
require_relative './language/general'
require_relative './language/mode'
require_relative './language/operations'
require_relative './language/program'
require_relative './language/stack'
require_relative './language/string'
require_relative './language/test'
require_relative './language/time-date'

module Rpl
  module Lang
    module Core
      module_function

      include BigMath

      def precision
        @precision or 12
      end

      def precision=( value )
        @precision = value
      end

      def stack_extract( stack, needs )
        raise 'Not enough elements' if stack.size < needs.size

        args = []
        needs.each do |need|
          elt = stack.pop

          raise "Type Error, needed #{need} got #{elt[:type]}" if need != :any && !need.include?( elt[:type] )

          args << elt
        end

        [stack, args]
      end

      def __todo( stack )
        puts '__NOT IMPLEMENTED__'
        stack
      end
    end
  end
end
