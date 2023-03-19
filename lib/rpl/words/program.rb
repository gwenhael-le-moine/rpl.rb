# frozen_string_literal: true

module RplLang
  module Words
    module Program
      include Types

      def populate_dictionary
        super

        category = 'Program'

        @dictionary.add_word!( ['eval'],
                               category,
                               '( a -- … ) interpret',
                               proc do
                                 args = stack_extract( [:any] )

                                 if [RplList, RplNumeric, RplBoolean].include?( args[0].class )
                                   @stack << args[0] # these types evaluate to themselves
                                 else
                                   run!( args[0].value.to_s )
                                 end
                               end )

        @dictionary.add_word!( ['sheval'],
                               category,
                               '( string -- output ) run string in OS shell and put output on stack',
                               proc do
                                 args = stack_extract( [[RplString]] )

                                 @stack << Types.new_object( RplString, "\"#{`#{args[0].value}`}\"" )
                               end )

        @dictionary.add_word!( ['↴', 'lsto'],
                               category,
                               '( content name -- ) store to local variable',
                               proc do
                                 args = stack_extract( [[RplName], :any] )

                                 @dictionary.add_local_var!( args[0].value,
                                                             args[1] )
                               end )
      end
    end
  end
end
