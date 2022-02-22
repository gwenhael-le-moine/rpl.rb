# frozen_string_literal: true

module RplLang
  module Core
    module List
      def populate_dictionary
        super

        @dictionary.add_word( ['→list', '->list'],
                              'Lists',
                              '( … x -- […] ) pack x stacks levels into a list',
                              proc do
                                args = stack_extract( [%i[numeric]] )
                                args = stack_extract( %i[any] * args[0][:value] )

                                @stack << { type: :list,
                                            value: args.reverse }
                              end )

        @dictionary.add_word( ['list→', 'list->'],
                              'Lists',
                              '( […] -- … ) unpack list on stack',
                              proc do
                                args = stack_extract( [%i[list]] )

                                args[0][:value].each do |elt|
                                  @stack << elt
                                end
                              end )

        @dictionary.add_word( ['dolist'],
                              'Lists',
                              '( […] prg -- … ) run prg on each element of a list',
                              proc do
                                args = stack_extract( [%i[program], %i[list]] )

                                args[1][:value].each do |elt|
                                  @stack << elt
                                  run( args[0][:value] )
                                end

                                run( "#{args[1][:value].length} →list" )
                              end )
      end
    end
  end
end
