# frozen_string_literal: true

module RplLang
  module Words
    module StringAndList
      include Types

      def populate_dictionary
        super

        @dictionary.add_word( ['→str', '->str'],
                              'String',
                              '( a -- s ) convert element to string',
                              proc do
                                args = stack_extract( [:any] )

                                @stack << Types.new_object( RplString, "\"#{args[0]}\"" )
                              end )

        @dictionary.add_word( ['str→', 'str->'],
                              'String',
                              '( s -- a ) convert string to element',
                              proc do
                                args = stack_extract( [[RplString]] )

                                @stack += Parser.parse( args[0].value )
                              end )

        @dictionary.add_word( ['→list', '->list'],
                              'Lists',
                              '( … x -- […] ) pack x stacks levels into a list',
                              proc do
                                args = stack_extract( [[RplNumeric]] )
                                args = stack_extract( %i[any] * args[0].value )

                                @stack << Types.new_object( RplList, args.reverse )
                              end )

        @dictionary.add_word( ['list→', 'list->'],
                              'Lists',
                              '( […] -- … ) unpack list on stack',
                              proc do
                                args = stack_extract( [[RplList]] )

                                args[0].value.each do |elt|
                                  @stack << elt
                                end
                              end )

        @dictionary.add_word( ['chr'],
                              'String',
                              '( n -- c ) convert ASCII character code in stack level 1 into a string',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                @stack << Types.new_object( RplString, "\"#{args[0].value.to_i.chr}\"" )
                              end )

        @dictionary.add_word( ['num'],
                              'String',
                              '( s -- n ) return ASCII code of the first character of the string in stack level 1 as a real number',
                              proc do
                                args = stack_extract( [[RplString]] )

                                @stack << Types.new_object( RplNumeric, args[0].value.ord )
                              end )

        @dictionary.add_word( ['size'],
                              'String',
                              '( s -- n ) return the length of the string or list',
                              proc do
                                args = stack_extract( [[RplString, RplList]] )

                                @stack << Types.new_object( RplNumeric, args[0].value.length )
                              end )

        @dictionary.add_word( ['pos'],
                              'String',
                              '( s s -- n ) search for the string in level 1 within the string in level 2',
                              proc do
                                args = stack_extract( [[RplString], [RplString]] )

                                @stack << Types.new_object( RplNumeric, args[1].value.index( args[0].value ) )
                              end )

        @dictionary.add_word( ['sub'],
                              'String',
                              '( s n n -- s ) return a substring of the string in level 3',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric], [RplString]] )

                                @stack << Types.new_object( RplString, "\"#{args[2].value[ (args[1].value - 1)..(args[0].value - 1) ]}\"" )
                              end )

        @dictionary.add_word( ['rev'],
                              'String',
                              '( s -- s ) reverse string or list',
                              proc do
                                args = stack_extract( [[RplString, RplList]] )

                                args[0].value.reverse!

                                @stack << args[0]
                              end )

        @dictionary.add_word( ['split'],
                              'String',
                              '( s c -- … ) split string s on character c',
                              proc do
                                args = stack_extract( [[RplString], [RplString]] )

                                args[1].value.split( args[0].value ).each do |elt|
                                  @stack << Types.new_object( RplString, "\"#{elt}\"" )
                                end
                              end )

        @dictionary.add_word( ['dolist'],
                              'Lists',
                              '( […] prg -- … ) run prg on each element of a list',
                              proc do
                                args = stack_extract( [[RplProgram], [RplList]] )

                                args[1].value.each do |elt|
                                  @stack << elt
                                  run( args[0].value )
                                end

                                run( "#{args[1].value.length} →list" )
                              end )
      end
    end
  end
end
