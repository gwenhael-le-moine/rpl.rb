# frozen_string_literal: true

require 'readline'

require_relative './lib/interpreter'

require_relative './lib/core/branch'
require_relative './lib/core/general'
require_relative './lib/core/mode'
require_relative './lib/core/operations'
require_relative './lib/core/program'
require_relative './lib/core/stack'
require_relative './lib/core/store'
require_relative './lib/core/string'
require_relative './lib/core/test'
require_relative './lib/core/time-date'
require_relative './lib/core/trig'
require_relative './lib/core/logarithm'
require_relative './lib/core/filesystem'
require_relative './lib/core/list'

class Rpl < Interpreter
  def initialize( stack = [], dictionary = Dictionary.new )
    super

    populate_dictionary if @dictionary.words.empty?
  end

  prepend RplLang::Core::Branch
  prepend RplLang::Core::FileSystem
  prepend RplLang::Core::General
  prepend RplLang::Core::List
  prepend RplLang::Core::Logarithm
  prepend RplLang::Core::Mode
  prepend RplLang::Core::Operations
  prepend RplLang::Core::Program
  prepend RplLang::Core::Stack
  prepend RplLang::Core::Store
  prepend RplLang::Core::String
  prepend RplLang::Core::Test
  prepend RplLang::Core::TimeAndDate
  prepend RplLang::Core::Trig

  def populate_dictionary; end
end

class RplRepl
  def initialize
    @interpreter = Rpl.new
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

RplRepl.new.run if __FILE__ == $PROGRAM_NAME
