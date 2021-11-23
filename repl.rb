# coding: utf-8
# frozen_string_literal: true

require 'readline'

require './lib/core'
require './lib/dictionary'
require './lib/parser'
require './lib/runner'

module Rpl
  class Repl
    def initialize
      @stack = []
      @dictionary = Dictionary.new
      @parser = Parser.new
      @runner = Runner.new
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

        input = '"rpn.rb version 0.0"' if %w[version uname].include?( input )

        # Remove blank lines from history
        Readline::HISTORY.pop if input.empty?

        @stack, @dictionary = @runner.run_input( @stack, @dictionary,
                                                 @parser.parse_input( input ) )

        print_stack
      end
    end

    def format_element( elt )
      if elt[:type] == :numeric && elt[:base] != 10
        prefix = case elt[:base]
                 when 2
                   '0b'
                 when 8
                   '0o'
                 when 16
                   '0x'
                 else
                   "0#{elt[:base]}_"
                 end
        return "#{prefix}#{elt[:value].to_s( elt[:base] )}"
      end

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

Rpl::Repl.new.run
