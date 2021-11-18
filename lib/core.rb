require_relative './language/general'
require_relative './language/operations'
require_relative './language/program'
require_relative './language/stack'

module Rpn
  module Core
    module_function

    def stack_extract( stack, needs )
      raise 'Not enough elements' if stack.size < needs.size

      args = []
      needs.each do |need|
        elt = stack.pop

        raise "Type Error, needed #{need} got #{elt[:type]}" if need != :any && !need.include?( elt[:type] )

        args << elt
      end

      [stack, args.reverse]
    end

    def __todo( stack )
      puts '__NOT IMPLEMENTED__'
      stack
    end
  end
end
