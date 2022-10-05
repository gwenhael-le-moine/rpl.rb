# frozen_string_literal: true

require 'tempfile'

module RplLang
  module Words
    module REPL
      include Types

      def populate_dictionary
        super

        category = 'REPL'

        @dictionary.add_word( ['words'],
                              category,
                              '() print the categorized list of all words',
                              proc do
                                @dictionary.words
                                           .to_a
                                           .group_by { |word| word.last[:category] }
                                           .each do |cat, words|
                                  puts cat
                                  puts "    #{words.map(&:first).join(', ')}"
                                end
                              end )

        @dictionary.add_word( ['history'],
                              category,
                              '() print the REPL\'s history',
                              proc {} )

        @dictionary.add_word( ['edit'],
                              category,
                              '( x -- y ) open object in $EDITOR',
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

        category = 'DEBUG'
        @dictionary.add_word( ['.s'],
                              category,
                              '() print internal state of stack',
                              proc { pp @stack } )

        @dictionary.add_word( ['.d'],
                              category,
                              '() print internal state of dictionary',
                              proc { pp @dictionary } )

        @dictionary.add_word( ['.v'],
                              category,
                              '() print internal state of variables',
                              proc { pp @dictionary.vars } )

        @dictionary.add_word( ['.lv'],
                              category,
                              '() print internal state of local variables layers',
                              proc { pp @dictionary.local_vars_layers } )
      end
    end
  end
end
