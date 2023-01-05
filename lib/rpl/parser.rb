# frozen_string_literal: true

class RplTypeError < StandardError
  attr_reader :reason

  def initialize( reason = '-undefined-' )
    super
    @reason = reason
  end
end

class Parser
  include Types

  def self.parse( input )
    unless input.index("\n").nil?
      input = input.split("\n")
                   .map do |line|
        comment_begin_index = line.index('@')

        case comment_begin_index
        when nil
          line
        when 0
          ''
        else
          line[0..(comment_begin_index - 1)]
        end
      end
                   .join(' ')
    end

    splitted_input = input.split

    # 2-passes:
    # 1. regroup strings, lists, complexes, names and programs
    opened_programs = 0
    closed_programs = 0

    opened_lists = 0
    closed_lists = 0

    opened_complexes = 0
    closed_complexes = 0

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
      elsif elt[0] == '('
        opened_complexes += 1
        elt.gsub!( '( ', '(') if elt.length > 1 && elt[1] == ' '
      elsif elt[0] == '"' && elt.length > 1
        string_delimiters += 1
      elsif elt[0] == "'" && elt.length > 1
        name_delimiters += 1
      end

      elt = "#{regrouped_input.pop}#{opened_complexes > closed_complexes ? '' : ' '}#{elt}".strip if regrouping

      regrouped_input << elt

      case elt[-1]
      when '»'
        closed_programs += 1
        elt.gsub!( '»', ' »') if elt.length > 1 && elt[-2] != ' '
      when '}'
        closed_lists += 1
        elt.gsub!( '}', ' }') if elt.length > 1 && elt[-2] != ' '
      when ')'
        closed_complexes += 1
        elt.gsub!( ' )', ')') if elt.length > 1 && elt[-2] == ' '
      when '"'
        string_delimiters += 1
      when "'"
        name_delimiters += 1
      end

      regrouping = string_delimiters.odd? || name_delimiters.odd? || (opened_programs > closed_programs) || (opened_lists > closed_lists) || (opened_complexes > closed_complexes)
    end

    # 2. parse
    regrouped_input.map do |element|
      if RplBoolean.can_parse?( element )
        Types.new_object( RplBoolean, element )
      elsif RplNumeric.can_parse?( element )
        Types.new_object( RplNumeric, element )
      elsif RplComplex.can_parse?( element )
        Types.new_object( RplComplex, element )
      elsif RplList.can_parse?( element )
        Types.new_object( RplList, element )
      elsif RplString.can_parse?( element )
        Types.new_object( RplString, element )
      elsif RplProgram.can_parse?( element )
        Types.new_object( RplProgram, element )
      elsif RplName.can_parse?( element )
        Types.new_object( RplName, element )
      end
    end
  end
end
