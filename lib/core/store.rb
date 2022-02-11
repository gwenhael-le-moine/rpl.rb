# frozen_string_literal: true

module RplLang
  module Core
    module Store
      def populate_dictionary
        super

        @dictionary.add_word( ['▶', 'sto'],
                              'Store',
                              '( content name -- ) store to variable',
                              proc do
                                args = stack_extract( [%i[name], :any] )

                                @dictionary.add_var( args[0][:value],
                                                     args[1] )
                              end )

        @dictionary.add_word( ['rcl'],
                              'Store',
                              '( name -- … ) push content of variable name onto stack',
                              proc do
                                args = stack_extract( [%i[name]] )

                                content = @dictionary.lookup( args[0][:value] )

                                @stack << content unless content.nil?
                              end )

        @dictionary.add_word( ['purge'],
                              'Store',
                              '( name -- ) delete variable',
                              proc do
                                args = stack_extract( [%i[name]] )

                                @dictionary.remove_var( args[0][:value] )
                              end )

        @dictionary.add_word( ['vars'],
                              'Store',
                              '( -- […] ) list variables',
                              proc do
                                @stack << { type: :list,
                                            value: (@dictionary.vars.keys + @dictionary.local_vars_layers.reduce([]) { |memo, layer| memo + layer.keys }).map { |name| { type: :name, value: name } } }
                              end )

        @dictionary.add_word( ['clusr'],
                              'Store',
                              '( -- ) delete all variables',
                              proc do
                                @dictionary.remove_all_vars
                              end )

        @dictionary.add_word( ['sto+'],
                              'Store',
                              '( a n -- ) add content to variable\'s value',
                              proc do
                                run( '
  dup type "name" ==
  « swap »
  ift
  over rcl + swap sto' )

                              end )

        @dictionary.add_word( ['sto-'],
                              'Store',
                              '( a n -- ) subtract content to variable\'s value',
                              proc do
                                run( '
  dup type "name" ==
  « swap »
  ift
  over rcl swap - swap sto' )
                              end )

        @dictionary.add_word( ['sto×', 'sto*'],
                              'Store',
                              '( a n -- ) multiply content of variable\'s value',
                              proc do
                                run( '
  dup type "name" ==
  « swap »
  ift
  over rcl * swap sto' )

                              end )

        @dictionary.add_word( ['sto÷', 'sto/'],
                              'Store',
                              '( a n -- ) divide content of variable\'s value',
                              proc do
                                run( '
  dup type "name" ==
  « swap »
  ift
  over rcl swap / swap sto' )

                              end )

        @dictionary.add_word( ['sneg'],
                              'Store',
                              '( a n -- ) negate content of variable\'s value',
                              proc do
                                run( 'dup rcl chs swap sto' )
                              end )

        @dictionary.add_word( ['sinv'],
                              'Store',
                              '( a n -- ) invert content of variable\'s value',
                              proc do
                                run( 'dup rcl inv swap sto' )
                              end )

        @dictionary.add_word( ['↴', 'lsto'],
                              'Program',
                              '( content name -- ) store to local variable',
                              proc do
                                args = stack_extract( [%i[name], :any] )

                                @dictionary.add_local_var( args[0][:value],
                                                           args[1] )
                              end )
      end
    end
  end
end
