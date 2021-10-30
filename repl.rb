# coding: utf-8
# frozen_string_literal: true

require 'readline'

require_relative "./lib/parser"

def run_REPL( stack )
  Readline.completion_proc = proc do |s|
    directory_list = Dir.glob("#{s}*")
    if directory_list.positive?
      directory_list
    else
      Readline::HISTORY.grep(/^#{Regexp.escape(s)}/)
    end
  end
  Readline.completion_append_character = " "

  loop do
    input = Readline.readline( " ", true )
    break if input == "exit"

    # Remove blank lines from history
    Readline::HISTORY.pop if input.empty?

    stack = process_input( stack, input )

    stack = display_stack( stack )
  end
end

def process_input( stack, input )
  parse_input( input ).each do |elt|
    stack << elt
  end

  stack
end

def display_stack( stack )
  stack_size = stack.size
  stack.each_with_index { |elt, i| puts "#{stack_size - i}: #{elt['value']}"}

  stack
end

def stack_init
  stack = []

  stack
end

run_REPL( stack_init )
