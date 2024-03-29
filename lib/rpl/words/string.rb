# frozen_string_literal: true

module RplLang
  module Words
    module String
      include Types

      def populate_dictionary
        super

        category = 'String'

        @dictionary.add_word!( ['→str', '->str'],
                               category,
                               '( a -- s ) convert element to string',
                               proc do
                                 args = stack_extract( [:any] )

                                 @stack << Types.new_object( RplString, "\"#{args[0]}\"" )
                               end )

        @dictionary.add_word!( ['str→', 'str->'],
                               category,
                               '( s -- a ) convert string to element',
                               proc do
                                 args = stack_extract( [[RplString]] )

                                 @stack += Parser.parse( args[0].value )
                               end )

        @dictionary.add_word!( ['chr'],
                               category,
                               '( n -- c ) convert ASCII character code in stack level 1 into a string',
                               proc do
                                 args = stack_extract( [[RplNumeric]] )

                                 @stack << Types.new_object( RplString, "\"#{args[0].value.to_i.chr}\"" )
                               end )

        @dictionary.add_word!( ['num'],
                               category,
                               '( s -- n ) return ASCII code of the first character of the string in stack level 1 as a real number',
                               proc do
                                 args = stack_extract( [[RplString]] )

                                 @stack << Types.new_object( RplNumeric, args[0].value.ord )
                               end )

        @dictionary.add_word!( ['size'],
                               category,
                               '( s -- n ) return the length of the string or list',
                               proc do
                                 args = stack_extract( [[RplString, RplList]] )

                                 @stack << Types.new_object( RplNumeric, args[0].value.length )
                               end )

        @dictionary.add_word!( ['pos'],
                               category,
                               '( s s -- n ) search for the string in level 1 within the string in level 2',
                               proc do
                                 args = stack_extract( [[RplString], [RplString]] )

                                 @stack << Types.new_object( RplNumeric, args[1].value.index( args[0].value ) )
                               end )

        @dictionary.add_word!( ['sub'],
                               category,
                               '( s n n -- s ) return a substring of the string in level 3',
                               proc do
                                 args = stack_extract( [[RplNumeric], [RplNumeric], [RplString]] )

                                 @stack << Types.new_object( RplString, "\"#{args[2].value[ (args[1].value - 1)..(args[0].value - 1) ]}\"" )
                               end )

        @dictionary.add_word!( ['split'],
                               category,
                               '( s c -- … ) split string s on character c',
                               proc do
                                 args = stack_extract( [[RplString], [RplString]] )

                                 args[1].value.split( args[0].value ).each do |elt|
                                   @stack << Types.new_object( RplString, "\"#{elt}\"" )
                                 end
                               end )
      end
    end
  end
end
