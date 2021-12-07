# frozen_string_literal: true

require 'bigdecimal/math'

require_relative './core/branch'
require_relative './core/general'
require_relative './core/mode'
require_relative './core/operations'
require_relative './core/program'
require_relative './core/stack'
require_relative './core/store'
require_relative './core/string'
require_relative './core/test'
require_relative './core/time-date'
require_relative './core/trig'
require_relative './core/logs'

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
