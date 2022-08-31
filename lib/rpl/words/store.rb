# frozen_string_literal: true

module RplLang
  module Words
    module Store
      include Types

      def populate_dictionary
        super

        category = 'Store'

        @dictionary.add_word( ['▶', 'sto'],
                              category,
                              '( content name -- ) store to variable',
                              proc do
                                args = stack_extract( [[RplName], :any] )

                                @dictionary.add_var( args[0].value,
                                                     args[1] )
                              end )

        @dictionary.add_word( ['rcl'],
                              category,
                              '( name -- … ) push content of variable name onto stack',
                              proc do
                                args = stack_extract( [[RplName]] )

                                content = @dictionary.lookup( args[0].value )

                                @stack << content unless content.nil?
                              end )

        @dictionary.add_word( ['purge'],
                              category,
                              '( name -- ) delete variable',
                              proc do
                                args = stack_extract( [[RplName]] )

                                @dictionary.remove_var( args[0].value )
                              end )

        @dictionary.add_word( ['vars'],
                              category,
                              '( -- […] ) list variables',
                              proc do
                                @stack << Types.new_object( RplList, (@dictionary.vars.keys + @dictionary.local_vars_layers.reduce([]) { |memo, layer| memo + layer.keys })
                                                                       .map { |name| Types.new_object( RplName, name ) } )
                              end )

        @dictionary.add_word( ['clusr'],
                              category,
                              '( -- ) delete all variables',
                              proc do
                                @dictionary.remove_all_vars
                              end )

        @dictionary.add_word( ['sto+'],
                              category,
                              '( a n -- ) add content to variable\'s value',
                              Types.new_object( RplProgram, '« swap over rcl + swap sto »' ) )

        @dictionary.add_word( ['sto-'],
                              category,
                              '( a n -- ) subtract content to variable\'s value',
                              Types.new_object( RplProgram, '« swap over rcl swap - swap sto »' ) )

        @dictionary.add_word( ['sto×', 'sto*'],
                              category,
                              '( a n -- ) multiply content of variable\'s value',
                              Types.new_object( RplProgram, '« swap over rcl * swap sto »' ) )

        @dictionary.add_word( ['sto÷', 'sto/'],
                              category,
                              '( a n -- ) divide content of variable\'s value',
                              Types.new_object( RplProgram, '« swap over rcl swap / swap sto »' ) )

        @dictionary.add_word( ['sneg'],
                              category,
                              '( a n -- ) negate content of variable\'s value',
                              Types.new_object( RplProgram, '« dup rcl chs swap sto »' ) )

        @dictionary.add_word( ['sinv'],
                              category,
                              '( a n -- ) invert content of variable\'s value',
                              Types.new_object( RplProgram, '« dup rcl inv swap sto »' ) )
      end
    end
  end
end
