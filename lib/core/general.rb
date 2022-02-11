# frozen_string_literal: true

module RplLang
  module Core
    module General
      def populate_dictionary
        super

        @dictionary.add_word( ['nop'],
                              'General',
                              '( -- ) no operation',
                              proc {} )

        @dictionary.add_word( ['help'],
                              'General',
                              '( w -- s ) pop help string of the given word',
                              proc do
                                args = stack_extract( [%i[name]] )

                                word = @dictionary.words[ args[0][:value] ]

                                @stack << { type: :string,
                                            value: "#{args[0][:value]}: #{word.nil? ? 'not a core word' : word[:help]}" }
                              end )

        @dictionary.add_word( ['quit'],
                              'General',
                              '( -- ) Stop and quit interpreter',
                              proc {} )

        @dictionary.add_word( ['version'],
                              'General',
                              '( -- n ) Pop the interpreter\'s version number',
                              proc do
                                @stack += parse( @version.to_s )
                              end )

        @dictionary.add_word( ['uname'],
                              'General',
                              '( -- s ) Pop the interpreter\'s complete indentification string',
                              proc do
                                @stack += parse( "\"Rpl Interpreter version #{@version}\"" )
                              end )

        @dictionary.add_word( ['history'],
                              'REPL',
                              '',
                              proc {} )

        @dictionary.add_word( ['.s'],
                              'REPL',
                              'DEBUG',
                              proc { pp @stack } )
      end
    end
  end
end
