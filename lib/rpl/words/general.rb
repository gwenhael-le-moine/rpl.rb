# frozen_string_literal: true

module RplLang
  module Words
    module General
      include Types

      def populate_dictionary
        super

        category = 'General'

        @dictionary.add_word( ['nop'],
                              category,
                              '( -- ) no operation',
                              proc {} )

        @dictionary.add_word( ['help'],
                              category,
                              '( w -- s ) pop help string of the given word',
                              proc do
                                args = stack_extract( [[RplName]] )

                                word = @dictionary.words[ args[0].value ]

                                @stack << Types.new_object( RplString, "\"#{args[0].value}: #{word.nil? ? 'not a core word' : word[:help]}\"" )
                              end )

        @dictionary.add_word( ['quit'],
                              category,
                              '( -- ) Stop and quit interpreter',
                              proc {} )

        @dictionary.add_word( ['version'],
                              category,
                              '( -- n ) Pop the interpreter\'s version number',
                              proc do
                                @stack << Types.new_object( RplString, "\"#{Rpl::VERSION}\"" )
                              end )

        @dictionary.add_word( ['uname'],
                              category,
                              '( -- s ) Pop the interpreter\'s complete indentification string',
                              Types.new_object( RplProgram, '« "Rpl Interpreter version " version + »' ) )
      end
    end
  end
end
