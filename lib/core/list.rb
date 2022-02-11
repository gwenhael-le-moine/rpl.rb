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
      end
    end
  end
end
