# coding: utf-8

module Rpn
  class Parser
    def initialize; end

    def numeric?( elt )
      !Float(elt).nil?
    rescue ArgumentError
      false
    end

    def parse_input( input )
      splitted_input = input.split(' ')

      # 2-passes:
      # 1. regroup strings and programs
      opened_programs = 0
      closed_programs = 0
      string_delimiters = 0
      regrouping = false

      regrouped_input = []
      splitted_input.each do |elt|
        # TODO: handle buried-in-elt « and » (surround by ' ' and re-split)
        if elt[0] == '«'
          opened_programs += 1
          elt.gsub!( '«', '« ') if elt.length > 1 && elt[1] != ' '
        end
        string_delimiters += 1 if elt[0] == '"'

        elt = "#{regrouped_input.pop} #{elt}".strip if regrouping

        regrouped_input << elt

        regrouping = string_delimiters.odd? || (opened_programs > closed_programs )

        if elt[-1] == '»'
          closed_programs += 1
          elt.gsub!( '»', ' »') if elt.length > 1 && elt[-2] != ' '
        end
        string_delimiters += 1 if elt.length > 1 && elt[-1] == '"'
      end

      # 2. parse
      parsed_tree = []
      regrouped_input.each do |elt|
        parsed_entry = { value: elt }

        opened_programs += 1 if elt[0] == '«'
        string_delimiters += 1 if elt[0] == '"'

        parsed_entry[:type] = case elt[0]
                              when '«'
                                :program
                              when '"'
                                :string
                              when "'"
                                :name # TODO: check for forbidden space
                              else
                                if numeric?( elt )
                                  :numeric
                                else
                                  :word
                                end
                              end

        if parsed_entry[:type] == :numeric
          i = parsed_entry[:value].to_i
          f = parsed_entry[:value].to_f

          parsed_entry[:value] = i == f ? i : f
        end

        parsed_tree << parsed_entry
      end

      parsed_tree
    end
  end
end
