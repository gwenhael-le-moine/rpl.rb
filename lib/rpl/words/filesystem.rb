# frozen_string_literal: true

module RplLang
  module Words
    module FileSystem
      include Types

      def populate_dictionary
        super

        category = 'Filesystem'

        @dictionary.add_word( ['fread'],
                              category,
                              '( filename -- content ) read file and put content on stack as string',
                              proc do
                                args = stack_extract( [[RplString]] )

                                path = File.absolute_path( args[0].value )

                                @stack << Types.new_object( RplString, "\"#{File.read( path )}\"" )
                              end )

        @dictionary.add_word( ['feval'],
                              category,
                              '( filename -- … ) read and run file',
                              Types.new_object( RplProgram, '« fread eval »' ) )

        @dictionary.add_word( ['fwrite'],
                              category,
                              '( content filename -- ) write content into filename',
                              proc do
                                args = stack_extract( [[RplString], :any] )

                                File.write( File.absolute_path( args[0].value ),
                                            args[1].value )
                              end )
      end
    end
  end
end
