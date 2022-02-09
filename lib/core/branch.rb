# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # ( x prg -- … ) run PRG X times putting i(counter) on the stack before each run
      def times( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [:any, %i[numeric]] )

        args[1][:value].to_i.times do |i|
          counter = { value: BigDecimal( i, Rpl::Lang.precision ), type: :numeric, base: 10 }
          stack << counter << args[0]

          stack, dictionary = Rpl::Lang::Core.eval( stack, dictionary )
        end

        [stack, dictionary]
      end

      # ( x y prg -- … ) run PRG (Y - X) times putting i(counter) on the stack before each run
      def loop( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [:any, %i[numeric], %i[numeric]] )

        ((args[2][:value].to_i)..(args[1][:value].to_i)).each do |i|
          counter = { value: BigDecimal( i, Rpl::Lang.precision ), type: :numeric, base: 10 }
          stack << counter << args[0]

          stack, dictionary = Rpl::Lang::Core.eval( stack, dictionary )
        end

        [stack, dictionary]
      end

      # similar to if-then-else-end, <test-instruction> <true-instruction> <false-instruction> ifte
      def ifte( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [:any, :any, %i[boolean]] )

        stack << args[ args[2][:value] ? 1 : 0 ]

        Rpl::Lang::Core.eval( stack, dictionary )
      end

      # Implemented in Rpl
      # similar to if-then-end, <test-instruction> <true-instruction> ift
      def ift( stack, dictionary )
        Rpl::Lang.eval( stack, dictionary, '« nop » ifte' )
      end
    end
  end
end
