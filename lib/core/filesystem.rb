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

      # ( content filename mode -- ) write content into filename using mode (w, a, …)
      def fwrite( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[string], %i[string], :any] )

        path = args[1][:value][1..-2]
        puts "File.open( #{path}, mode: #{args[0][:value][1..-2]} ) { |file| file.write( #{args[2][:value]} ) }"
        File.open( path ) { |file| file.write( args[0][:value] ) }

        [stack, dictionary]
      end
    end
  end
end
