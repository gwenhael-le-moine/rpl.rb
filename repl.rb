# coding: utf-8
# frozen_string_literal: true

require 'readline'

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

def parse_input( input )
  splitted_input = input.split( " " )
  parsed_input = []

  regrouping = false
  splitted_input.each do |elt|
    if regrouping
      partial_elt = parsed_input.pop
      elt = "#{partial_elt} #{elt}"
    end

    if regrouping
      regrouping = false if (elt[0] == '\'' and elt[-1] == '\'') or (elt[0] == '"' and elt[-1] == '"') or (elt[0] == '«' and elt[-1] == '»')
    else
      regrouping = true if elt[0] == '\'' or elt[0] == '"' or elt[0] == '«'
    end

    # 'xx' is a name (no space allowed)
    # "xx x x xx" is a string
    # « xx xx xx » is a program (must have inner spaces)

    parsed_input << elt
  end

  parsed_input
end

def process_input( stack, input )
  parse_input( input ).each do |elt|
    stack << elt
  end

  stack
end

def display_stack( stack )
  stack_size = stack.size
  stack.each_with_index { |v, i| puts "#{stack_size - i}: #{v}"}

  stack
end

def stack_init
  stack = []

  stack
end

run_REPL( stack_init )
