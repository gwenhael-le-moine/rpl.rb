# frozen_string_literal: true

module Lang
  module Core
    module_function

    # no operation
    def nop; end

    # show version
    def version
      @stack += parse( @version.to_s )
    end

    # show complete identification string
    def uname
      @stack += parse( "\"Rpl Interpreter version #{@version}\"" )
    end

    def help
      args = stack_extract( [%i[name]] )

      word = @dictionary.words[ args[0][:value] ]

      @stack << { type: :string,
                  value: "#{args[0][:value]}: #{word.nil? ? 'not a core word' : word[:help]}" }
    end
  end
end
