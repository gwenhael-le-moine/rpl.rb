module Rpl
  module Lang
    module Core
      module_function

      # ( filename -- content ) read file and put content on stack as string
      def fread( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[string]] )

        path = File.absolute_path( args[0][:value] )

        stack << { type: :string,
                   value: File.read( path ) }

        [stack, dictionary]
      end

      # ( filename -- … ) read and run file
      def feval( stack, dictionary )
        Rpl::Lang.eval( stack, dictionary, 'fread eval' )
      end

      # ( content filename -- ) write content into filename
      def fwrite( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[string], :any] )

        File.write( File.absolute_path( args[0][:value] ),
                    args[1][:value] )

        [stack, dictionary]
      end
    end
  end
end
