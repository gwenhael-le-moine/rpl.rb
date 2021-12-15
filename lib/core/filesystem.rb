module Rpl
  module Lang
    module Core
      module_function

      # ( filename -- content ) read file and put content on stack as string
      def fread( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[string]] )

        path = File.absolute_path( args[0][:value][1..-2] )
        p path
        stack << { type: :string,
                   value: File.read( path ) }

        [stack, dictionary]
      end
    end
  end
end
