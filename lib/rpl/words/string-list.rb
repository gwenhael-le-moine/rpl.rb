# frozen_string_literal: true

module RplLang
  module Words
    module StringAndList
      include Types

      def populate_dictionary
        super

        category = 'Strings and Lists'

        @dictionary.add_word( ['rev'],
                              category,
                              '( s -- s ) reverse string or list',
                              proc do
                                args = stack_extract( [[RplString, RplList]] )

                                @stack << if args[0].is_a?( RplString )
                                            Types.new_object( RplString, "\"#{args[0].value.reverse}\"" )
                                          else
                                            Types.new_object( args[0].class, "{ #{args[0].value.reverse.join(' ')} }" )
                                          end
                              end )
      end
    end
  end
end
