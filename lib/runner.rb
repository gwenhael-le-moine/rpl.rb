# frozen_string_literal: true

module Rpl
  module Lang
    class Runner
      def initialize; end

      def run_input( input, stack, dictionary )
        dictionary.add_local_vars_layer

        input.each do |elt|
          case elt[:type]
          when :word
            command = dictionary.lookup( elt[:value] )

            if command.nil?
              # if there's command by that name then it's a name
              elt[:type] = :name

              stack << elt
            else
              stack, dictionary = command.call( stack, dictionary )
            end
          else
            stack << elt
          end
        end

        dictionary.remove_local_vars_layer

        [stack, dictionary]
      end
    end
  end
end
