# frozen_string_literal: true

module Lang
  module Core
    module_function

    # ( filename -- content ) read file and put content on stack as string
    def fread
      args = stack_extract( [%i[string]] )

      path = File.absolute_path( args[0][:value] )

      @stack << { type: :string,
                  value: File.read( path ) }
    end

    # ( filename -- … ) read and run file
    def feval
      run 'fread eval'
    end

    # ( content filename -- ) write content into filename
    def fwrite
      args = stack_extract( [%i[string], :any] )

      File.write( File.absolute_path( args[0][:value] ),
                  args[1][:value] )
    end
  end
end
