# frozen_string_literal: true

require 'readline'

require './interpreter'

class RplRepl
  def initialize
    @interpreter = Rpl::Interpreter.new
  end

  def run
    Readline.completion_proc = proc do |s|
      Readline::HISTORY.grep(/^#{Regexp.escape(s)}/)
    end
    Readline.completion_append_character = ' '

    loop do
      input = Readline.readline( ' ', true )
      break if input.nil? || input == 'quit'

      pp Readline::HISTORY if input == 'history'

      # Remove blank lines from history
      Readline::HISTORY.pop if input.empty?

      begin
        @interpreter.run( input )
      rescue ArgumentError => e
        p e
        p e.stack
      end

      print_stack
    end
  end

  def format_element( elt )
    @interpreter.stringify( elt )
  end

  def print_stack
    stack_size = @interpreter.stack.size

    @interpreter.stack.each_with_index do |elt, i|
      puts "#{stack_size - i}: #{format_element( elt )}"
    end
  end
end

RplRepl.new.run
