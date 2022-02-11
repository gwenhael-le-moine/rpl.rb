# frozen_string_literal: true

module RplLang
  module Core
    module FileSystem
      def populate_dictionary
        super

        @dictionary.add_word( ['fread'],
                              'Filesystem',
                              '( filename -- content ) read file and put content on stack as string',
                              proc do
                                args = stack_extract( [%i[string]] )

                                path = File.absolute_path( args[0][:value] )

                                @stack << { type: :string,
                                            value: File.read( path ) }
                              end )
        @dictionary.add_word( ['feval'],
                              'Filesystem',
                              '( filename -- … ) read and run file',
                              proc do
                                run( 'fread eval' )
                              end )
        @dictionary.add_word( ['fwrite'],
                              'Filesystem',
                              '( content filename -- ) write content into filename',
                              proc do
                                args = stack_extract( [%i[string], :any] )

                                File.write( File.absolute_path( args[0][:value] ),
                                            args[1][:value] )
                              end )
      end
    end
  end
end
