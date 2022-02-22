# frozen_string_literal: true

require 'bigdecimal/math'

require 'rpl/dictionary'

class Interpreter
  include BigMath

  attr_reader :stack,
              :dictionary,
              :version

  attr_accessor :precision

  def initialize( stack = [], dictionary = Rpl::Lang::Dictionary.new )
    @version = 0.1

    @precision = default_precision

    @dictionary = dictionary
    @stack = stack

    populate_dictionary if @dictionary.words.empty?
  end

  def default_precision
    12
  end

  def parse( input )
    is_numeric = lambda do |elt|
      begin
        !Float(elt).nil?
      rescue ArgumentError
        begin
          !Integer(elt).nil?
        rescue ArgumentError
          false
        end
      end
    end

    unless input.index("\n").nil?
      input = input
                .split("\n")
                .map do |line|
        comment_begin_index = line.index('#')

        if comment_begin_index.nil?
          line
        elsif comment_begin_index == 0
          ''
        else
          line[0..(comment_begin_index - 1)]
        end
      end
                .join(' ')
    end

    splitted_input = input.split(' ')

    # 2-passes:
    # 1. regroup strings and programs
    opened_programs = 0
    closed_programs = 0
    opened_lists = 0
    closed_lists = 0
    string_delimiters = 0
    name_delimiters = 0
    regrouping = false

    regrouped_input = []
    splitted_input.each do |elt|
      if elt[0] == '«'
        opened_programs += 1
        elt.gsub!( '«', '« ') if elt.length > 1 && elt[1] != ' '
      elsif elt[0] == '{'
        opened_lists += 1
        elt.gsub!( '{', '{ ') if elt.length > 1 && elt[1] != ' '
      elsif elt[0] == '"' && elt.length > 1
        string_delimiters += 1
      elsif elt[0] == "'" && elt.length > 1
        name_delimiters += 1
      end

      elt = "#{regrouped_input.pop} #{elt}".strip if regrouping

      regrouped_input << elt

      case elt[-1]
      when '»'
        closed_programs += 1
        elt.gsub!( '»', ' »') if elt.length > 1 && elt[-2] != ' '
      when '}'
        closed_lists += 1
        elt.gsub!( '}', ' }') if elt.length > 1 && elt[-2] != ' '
      when '"'
        string_delimiters += 1
      when "'"
        name_delimiters += 1
      end

      regrouping = string_delimiters.odd? || name_delimiters.odd? || (opened_programs > closed_programs ) || (opened_lists > closed_lists )
    end

    # 2. parse
    # TODO: parse ∞, <NaN> as numerics
    parsed_tree = []
    regrouped_input.each do |elt|
      parsed_entry = { value: elt }

      parsed_entry[:type] = case elt[0]
                            when '«'
                              :program
                            when '{'
                              :list
                            when '"'
                              :string
                            when "'"
                              :name # TODO: check for forbidden space
                            else
                              if is_numeric.call( elt )
                                :numeric
                              else
                                :word
                              end
                            end

      if %I[string name].include?( parsed_entry[:type] )
        parsed_entry[:value] = parsed_entry[:value][1..-2]
      elsif %I[program].include?( parsed_entry[:type] )
        parsed_entry[:value] = parsed_entry[:value][2..-3]
      elsif %I[list].include?( parsed_entry[:type] )
        parsed_entry[:value] = parse( parsed_entry[:value][2..-3] )
      elsif %I[numeric].include?( parsed_entry[:type] )
        underscore_position = parsed_entry[:value].index('_')

        if parsed_entry[:value][0] == '0' && ( ['b', 'o', 'x'].include?( parsed_entry[:value][1] ) || !underscore_position.nil? )
          if parsed_entry[:value][1] == 'x'
            parsed_entry[:base] = 16
          elsif parsed_entry[:value][1] == 'b'
            parsed_entry[:base] = 2
          elsif parsed_entry[:value][1] == 'o'
            parsed_entry[:base] = 8
            parsed_entry[:value] = parsed_entry[:value][2..]
          elsif !underscore_position.nil?
            parsed_entry[:base] = parsed_entry[:value][1..(underscore_position - 1)].to_i
            parsed_entry[:value] = parsed_entry[:value][(underscore_position + 1)..]
          end
        else
          parsed_entry[:base] = 10
        end

        parsed_entry[:value] = parsed_entry[:value].to_i( parsed_entry[:base] ) unless parsed_entry[:base] == 10
        parsed_entry[:value] = BigDecimal( parsed_entry[:value], @precision )
      end

      parsed_tree << parsed_entry
    end

    parsed_tree
  end

  def run( input )
    @dictionary.add_local_vars_layer

    parse( input.to_s ).each do |elt|
      case elt[:type]
      when :word
        break if %w[break quit exit].include?( elt[:value] )

        command = @dictionary.lookup( elt[:value] )

        if command.nil?
          # if there isn't a command by that name then it's a name
          elt[:type] = :name

          @stack << elt
        elsif command.is_a?( Proc )
          command.call
        else
          run( command[:value] )
        end
      else
        @stack << elt
      end
    end

    @dictionary.remove_local_vars_layer

    # superfluous but feels nice
    @stack
  end

  def stack_extract( needs )
    raise ArgumentError, 'Not enough elements' if @stack.size < needs.size

    needs.each_with_index do |need, index|
      stack_index = (index + 1) * -1

      raise ArgumentError, "Type Error, needed #{need} got #{@stack[stack_index]}" unless need == :any || need.include?( @stack[stack_index][:type] )
    end

    args = []
    needs.size.times do
      args << @stack.pop
    end

    args
  end

  def stringify( elt )
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

      if elt[:value].infinite?
        suffix = elt[:value].infinite?.positive? ? '∞' : '-∞'
      elsif elt[:value].nan?
        suffix = '<NaN>'
      else
        suffix = if elt[:value].to_i == elt[:value]
                   elt[:value].to_i
                 else
                   elt[:value].to_s('F')
                 end
        suffix = elt[:value].to_s( elt[:base] ) unless elt[:base] == 10
      end

      "#{prefix}#{suffix}"
    when :list
      "{ #{elt[:value].map { |e| stringify( e ) }.join(' ')} }"
    when :program
      "« #{elt[:value]} »"
    when :string
      "\"#{elt[:value]}\""
    when :name
      "'#{elt[:value]}'"
    else
      elt[:value]
    end
  end

  def infer_resulting_base( numerics )
    10 if numerics.length.zero?

    numerics.last[:base]
  end
end
