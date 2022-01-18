# frozen_string_literal: true

require 'readline'

require './language'

class RplRepl
  def initialize
    @lang = Rpl::Language.new
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

      begin
        @lang.run( input )
      rescue ArgumentError, ZeroDivisionError => e
        p e
      end

      print_stack
    end
  end

  def format_element( elt )
    case elt[:type]
    when :numeric
      prefix = case elt[:base]
               when 2
                 '0b'
               when 8
                 '0o'
               when 10
                 ''
               when 16
                 '0x'
               else
                 "0#{elt[:base]}_"
               end
      "#{prefix}#{elt[:value].to_s( elt[:base] )}"
    when :list
      "[#{elt[:value].map { |e| e[:value] }.join(', ')}]"
    else
      elt[:value]
    end
  end

  def print_stack
    stack_size = @lang.stack.size

    @lang.stack.each_with_index do |elt, i|
      puts "#{stack_size - i}: #{format_element( elt )}"
    end
  end
end

RplRepl.new.run
