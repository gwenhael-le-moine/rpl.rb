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

      regrouping = false
      splitted_input.each do |elt|
        parsed_entry = { value: elt }

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
          # parsed_entry[:value] = elt[1..] if [:program, :string, :name].include?( parsed_entry[:type] )
        end

        regrouping = ( (parsed_entry[:type] == :string && elt.size == 1 && elt[-1] != '"') ||
                       (parsed_entry[:type] == :program && elt[-1] != '»') )

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
