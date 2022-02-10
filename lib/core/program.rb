# frozen_string_literal: true

module Lang
  module Core
    module_function

    # evaluate (run) a program, or recall a variable. ex: 'my_prog' eval
    def eval
      args = stack_extract( [:any] )

      run( args[0][:value].to_s )
    end
  end
end
