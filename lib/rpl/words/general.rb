# frozen_string_literal: true

require 'tempfile'

module RplLang
  module Words
    module General
      include Types

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
                                args = stack_extract( [[RplName]] )

                                word = @dictionary.words[ args[0].value ]

                                @stack << Types.new_object( RplString, "\"#{args[0].value}: #{word.nil? ? 'not a core word' : word[:help]}\"" )
                              end )

        @dictionary.add_word( ['words'],
                              'REPL',
                              'DEBUG',
                              proc do
                                @dictionary.words
                                           .to_a
                                           .group_by { |word| word.last[:category] }
                                           .each do |cat, words|
                                  puts cat
                                  puts "    #{words.map(&:first).join(', ')}"
                                end
                              end )

        @dictionary.add_word( ['quit'],
                              'General',
                              '( -- ) Stop and quit interpreter',
                              proc {} )

        @dictionary.add_word( ['version'],
                              'General',
                              '( -- n ) Pop the interpreter\'s version number',
                              proc do
                                @stack << Types.new_object( RplString, "\"#{@version}\"" )
                              end )

        @dictionary.add_word( ['uname'],
                              'General',
                              '( -- s ) Pop the interpreter\'s complete indentification string',
                              proc do
                                @stack << Types.new_object( RplString, "\"Rpl Interpreter version #{@version}\"" )
                              end )

        @dictionary.add_word( ['history'],
                              'REPL',
                              '',
                              proc {} )

        @dictionary.add_word( ['edit'],
                              'General',
                              '( -- s ) Pop the interpreter\'s complete indentification string',
                              proc do
                                args = stack_extract( [:any] )

                                value = args[0].to_s
                                tempfile = Tempfile.new('rpl')

                                begin
                                  tempfile.write( value )
                                  tempfile.rewind

                                  `$EDITOR #{tempfile.path}`

                                  edited_value = tempfile.read
                                ensure
                                  tempfile.close
                                  tempfile.unlink
                                end

                                @stack << Types.new_object( args[0].class, edited_value )
                              end )

        @dictionary.add_word( ['.s'],
                              'REPL',
                              'DEBUG',
                              proc { pp @stack } )

        @dictionary.add_word( ['.d'],
                              'REPL',
                              'DEBUG',
                              proc { pp @dictionary } )

        @dictionary.add_word( ['.v'],
                              'REPL',
                              'DEBUG',
                              proc { pp @dictionary.vars } )

        @dictionary.add_word( ['.lv'],
                              'REPL',
                              'DEBUG',
                              proc { pp @dictionary.local_vars_layers } )
      end
    end
  end
end
