# frozen_string_literal: true

module RplLang
  module Words
    module List
      include Types

      def populate_dictionary
        super

        category = 'Lists'

        @dictionary.add_word( ['→list', '->list'],
                              category,
                              '( … x -- […] ) pack x stacks levels into a list',
                              proc do
                                args = stack_extract( [[RplNumeric]] )
                                args = stack_extract( %i[any] * args[0].value )

                                @stack << Types.new_object( RplList, args.reverse )
                              end )

        @dictionary.add_word( ['list→', 'list->'],
                              category,
                              '( […] -- … ) unpack list on stack',
                              proc do
                                args = stack_extract( [[RplList]] )

                                args[0].value.each do |elt|
                                  @stack << elt
                                end
                              end )

        @dictionary.add_word( ['dolist'],
                              category,
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
