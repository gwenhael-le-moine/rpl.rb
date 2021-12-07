# frozen_string_literal: true

module Rpl
  module Lang
    class Runner
      def initialize; end

      def run_input( input, stack, dictionary )
        input.each do |elt|
          case elt[:type]
          when :word
            command = dictionary.lookup( elt[:value] )

            if command.nil?
              stack << { type: :name, value: "'#{elt[:value]}'" }
            else
              stack = command.call( stack )
            end
          else
            stack << elt
          end
        end

        [stack, dictionary]
      end
    end
  end
end
