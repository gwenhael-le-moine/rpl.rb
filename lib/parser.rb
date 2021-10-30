# coding: utf-8

class String
  def numeric?
    Float(self) != nil rescue false
  end
end

def parse_input( input )
  splitted_input = input.split(' ')
  parsed_tree = []

  regrouping = false
  splitted_input.each do |elt|
    next if elt.length == 1 && elt[0] == '»'

    parsed_entry = { 'value' => elt }

    if regrouping
      parsed_entry = parsed_tree.pop

      parsed_entry['value'] = "#{parsed_entry['value']} #{elt}".strip
    else
      parsed_entry['type'] = case elt[0]
                             when '«'
                               'PROGRAM'
                             when '"'
                               'STRING'
                             when '\''
                               'NAME'
                             else
                               if elt.numeric?
                                 'NUMBER'
                               else
                                 'WORD' # TODO: if word isn't known then it's a NAME
                               end
                             end

      parsed_entry['value'] = elt[1..] if %W[PROGRAM STRING NAME].include?( parsed_entry['type'] )
    end

    regrouping = ( (parsed_entry['type'] == 'NAME' && elt[-1] != '\'') ||
                   (parsed_entry['type'] == 'STRING' && elt[-1] != '"') ||
                   (parsed_entry['type'] == 'PROGRAM'  && elt[-1] != '»') )

    parsed_entry['value'] = if ( (parsed_entry['type'] == 'NAME' && elt[-1] == '\'') ||
                                 (parsed_entry['type'] == 'STRING'  && elt[-1] == '"') ||
                                 (parsed_entry['type'] == 'PROGRAM' && elt[-1] == '»') )
                              (parsed_entry['value'][..-2]).strip
                            elsif parsed_entry['type'] == 'NUMBER'
                              parsed_entry['value'].to_f
                            elsif parsed_entry['type'] == 'WORD'
                              parsed_entry['value']
                            else
                              parsed_entry['value']
                            end

    parsed_tree << parsed_entry
  end

  parsed_tree
end
