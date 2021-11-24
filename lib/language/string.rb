module Rpl
  module Core
    module_function

    # convert an object into a string
    def to_string( stack )
      stack, args = Rpl::Core.stack_extract( stack, :any )

      stack << { type: :string,
                 value: args[0][:value].to_s }
    end

    # return the length of the string
    def size( stack )
      stack, args = Rpl::Core.stack_extract( stack, %i[string] )

      stack << { type: :numeric,
                 base: 10,
                 value: args[0][:value].length }
    end

    # return a substring of the string in level 3
    def sub( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric], %i[numeric], %i[string]] )

      puts "#{args[0][:value]}[#{args[1][:value]}..#{args[2][:value]}]"
      stack << { type: :string,
                 value: args[2][:value][args[1][:value]..args[0][:value]] }
    end
  end
end
