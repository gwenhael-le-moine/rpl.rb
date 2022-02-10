# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      # ( x prg -- … ) run PRG X times putting i(counter) on the stack before each run
      def times
        args = stack_extract( [:any, %i[numeric]] )

        args[1][:value].to_i.times do |i|
          counter = { value: BigDecimal( i, @precision ), type: :numeric, base: 10 }
          @stack << counter

          run( args[0][:value] )
        end
      end

      # ( x y prg -- … ) run PRG (Y - X) times putting i(counter) on the stack before each run
      def loop
        args = stack_extract( [:any, %i[numeric], %i[numeric]] )

        ((args[2][:value].to_i)..(args[1][:value].to_i)).each do |i|
          counter = { value: BigDecimal( i, @precision ), type: :numeric, base: 10 }
          @stack << counter

          run( args[0][:value] )
        end
      end

      # similar to if-then-else-end, <test-instruction> <true-instruction> <false-instruction> ifte
      def ifte
        args = stack_extract( [:any, :any, %i[boolean]] )

        run( args[ args[2][:value] ? 1 : 0 ][:value] )
      end

      # Implemented in Rpl
      # similar to if-then-end, <test-instruction> <true-instruction> ift
      def ift
        run( '« nop » ifte' )
      end
    end
  end
end
