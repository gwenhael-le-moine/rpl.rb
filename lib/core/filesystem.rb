module Rpl
  module Lang
    module Core
      module_function

      # ( filename -- content ) read file and put content on stack as string
      def fread( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[string]] )

        path = File.absolute_path( args[0][:value][1..-2] )

        stack << { type: :string,
                   value: "\"#{File.read( path )}\"" }

        [stack, dictionary]
      end

      # ( filename -- … ) read and run file
      def feval( stack, dictionary )
        stack << { value: '« fread eval »',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end

      # ( content filename -- ) write content into filename
      def fwrite( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[string], :any] )

        File.write( File.absolute_path( args[0][:value][1..-2] ),
                    args[1][:value] )

        [stack, dictionary]
      end
    end
  end
end
