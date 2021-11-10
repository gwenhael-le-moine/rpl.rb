# coding: utf-8
# frozen_string_literal: true

require 'readline'

require './lib/dictionary'
require './lib/parser'
require './lib/runner'

module Rpn
  class Repl
    def initialize
      @stack = []
      @dictionary = Dictionary.new
      @parser = Parser.new
      @runner = Runner.new
    end

    def run
      Readline.completion_proc = proc do |s|
        directory_list = Dir.glob("#{s}*")
        if directory_list.positive?
          directory_list
        else
          Readline::HISTORY.grep(/^#{Regexp.escape(s)}/)
        end
      end
      Readline.completion_append_character = ' '

      loop do
        input = Readline.readline( ' ', true )
        break if input.nil? || input == 'exit'

        # Remove blank lines from history
        Readline::HISTORY.pop if input.empty?

        @stack, @dictionary = @runner.run_input( @stack, @dictionary,
                                                 @parser.parse_input( input ) )

        print_stack
      end
    end

    def format_element( elt )
      elt[:value]
    end

    def print_stack
      stack_size = @stack.size

      @stack.each_with_index do |elt, i|
        puts "#{stack_size - i}: #{format_element( elt )}"
      end
    end
  end
end

Rpn::Repl.new.run
