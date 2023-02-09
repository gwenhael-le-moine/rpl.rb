# frozen_string_literal: true

module RplLang
  module Words
    module System
      include Types

      def populate_dictionary
        super

        category = 'System'

        @dictionary.add_word!( ['syseval'],
                               category,
                               '( string -- output ) run string in OS shell and put output on stack',
                               proc do
                                 args = stack_extract( [[RplString]] )

                                 @stack << Types.new_object( RplString, "\"#{`#{args[0].value}`}\"" )
                               end )
      end
    end
  end
end
