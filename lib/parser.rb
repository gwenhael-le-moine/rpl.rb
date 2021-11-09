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
      parsed_tree = []

      opened_programs = 0
      closed_programs = 0
      string_delimiters = 0
      regrouping = false

      splitted_input.each do |elt|
        parsed_entry = { value: elt }

        opened_programs += 1 if elt[0] == '«'
        string_delimiters += 1 if elt[0] == '"'

        if regrouping
          parsed_entry = parsed_tree.pop

          parsed_entry[:value] = "#{parsed_entry[:value]} #{elt}".strip
        else
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

          if parsed_entry[:type] == :word
            if false
              # TODO: run word if known
            else
              parsed_entry[:type] = :name
              parsed_entry[:value] = "'#{parsed_entry[:value]}'" if parsed_entry[:value][0] != "'"
            end
          end
        end

        regrouping = ( (parsed_entry[:type] == :string && string_delimiters % 2 != 0) ||
                       (parsed_entry[:type] == :program && opened_programs > closed_programs ) )

        if parsed_entry[:type] == :numeric
          i = parsed_entry[:value].to_i
          f = parsed_entry[:value].to_f

          parsed_entry[:value] = i == f ? i : f
        end

        closed_programs += 1 if elt[-1] == '»'
        string_delimiters += 1 if elt.length > 1 && elt[-1] == '"'

        parsed_tree << parsed_entry
      end

      parsed_tree
    end
  end
end
