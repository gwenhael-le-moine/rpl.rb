# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # addition
      def add( stack, dictionary )
        addable = %i[numeric string name]
        stack, args = Rpl::Lang::Core.stack_extract( stack, [addable, addable] )

        result = { type: case args[1][:type]
                         when :name
                           :name
                         when :string
                           :string
                         when :numeric
                           if args[0][:type] == :numeric
                             :numeric
                           else
                             :string
                           end
                         end }

        args.each do |elt|
          elt[:value] = elt[:value][1..-2] unless elt[:type] == :numeric
        end

        result[:value] = case result[:type]
                         when :name
                           "'#{args[1][:value]}#{args[0][:value]}'"
                         when :string
                           "\"#{args[1][:value]}#{args[0][:value]}\""
                         when :numeric
                           args[1][:value] + args[0][:value]
                         end

        result[:base] = 10 if result[:type] == :numeric # TODO: what if operands have other bases ?

        stack << result

        [stack, dictionary]
      end

      # substraction
      def subtract( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

        stack << { type: :numeric, base: 10,
                   value: args[1][:value] - args[0][:value] }

        [stack, dictionary]
      end

      # negation
      def negate( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric, base: 10,
                   value: args[0][:value] * -1 }

        [stack, dictionary]
      end

      # multiplication
      def multiply( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

        stack << { type: :numeric, base: 10,
                   value: args[1][:value] * args[0][:value] }

        [stack, dictionary]
      end

      # division
      def divide( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

        raise 'Division by 0' if args[0][:value].zero?

        stack << { type: :numeric, base: 10,
                   value: args[1][:value] / args[0][:value] }

        [stack, dictionary]
      end

      # inverse
      def inverse( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )

        raise 'Division by 0' if args[0][:value].zero?

        stack << { type: :numeric, base: 10,
                   value: 1.0 / args[0][:value] }

        [stack, dictionary]
      end

      # power
      def power( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

        stack << { type: :numeric, base: 10,
                   value: args[1][:value]**args[0][:value] }

        [stack, dictionary]
      end

      # rpn_square root
      def sqrt( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric, base: 10,
                   value: BigMath.sqrt( BigDecimal( args[0][:value] ), Rpl::Lang::Core.precision ) }

        [stack, dictionary]
      end

      # rpn_square
      def sq( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric, base: 10,
                   value: args[0][:value] * args[0][:value] }

        [stack, dictionary]
      end

      # absolute value
      def abs( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric, base: 10,
                   value: args[0][:value].abs }

        [stack, dictionary]
      end

      # decimal representation
      def dec( stack, dictionary )
        base( stack << { type: :numeric, base: 10, value: 10 }, dictionary )
      end

      # hexadecimal representation
      def hex( stack, dictionary )
        base( stack << { type: :numeric, base: 10, value: 16 }, dictionary )
      end

      # binary representation
      def bin( stack, dictionary )
        base( stack << { type: :numeric, base: 10, value: 2 }, dictionary )
      end

      # arbitrary base representation
      def base( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

        args[1][:base] = args[0][:value]

        stack << args[1]

        [stack, dictionary]
      end

      # 1 if number at stack level 1 is > 0, 0 if == 0, -1 if <= 0
      def sign( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )
        value = if args[0][:value].positive?
                  1
                elsif args[0][:value].negative?
                  -1
                else
                  0
                end

        stack << { type: :numeric, base: 10,
                   value: value }

        [stack, dictionary]
      end

      # OPERATIONS ON REALS

      # percent
      def percent( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

        stack << { type: :numeric,
                   base: 10,
                   value: args[0][:value] * ( args[1][:value] / 100.0 ) }

        [stack, dictionary]
      end

      # inverse percent
      def inverse_percent( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

        stack << { type: :numeric,
                   base: 10,
                   value: 100.0 * ( args[0][:value] / args[1][:value] ) }

        [stack, dictionary]
      end

      # modulo
      def mod( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

        stack << { type: :numeric,
                   base: 10,
                   value: args[1][:value] % args[0][:value] }

        [stack, dictionary]
      end

      # n! for integer n or Gamma(x+1) for fractional x
      def fact( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric,
                   base: 10,
                   value: Math.gamma( args[0][:value] ) }

        [stack, dictionary]
      end

      # largest number <=
      def floor( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric,
                   base: 10,
                   value: args[0][:value].floor }

        [stack, dictionary]
      end

      # smallest number >=
      def ceil( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric,
                   base: 10,
                   value: args[0][:value].ceil }

        [stack, dictionary]
      end

      # min of 2 real numbers
      def min( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

        stack << ( args[0][:value] < args[1][:value] ? args[0] : args[1] )

        [stack, dictionary]
      end

      # max of 2 real numbers
      def max( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

        stack << ( args[0][:value] > args[1][:value] ? args[0] : args[1] )

        [stack, dictionary]
      end
    end
  end
end
