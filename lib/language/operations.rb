module Rpl
  module Core
    module_function

    # addition
    def add( stack )
      addable = %i[numeric string name]
      stack, args = Rpl::Core.stack_extract( stack, [addable, addable] )

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
    end

    # substraction
    def subtract( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

      stack << { type: :numeric, base: 10,
                 value: args[1][:value] - args[0][:value] }
    end

    # negation
    def negate( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric]] )

      stack << { type: :numeric, base: 10,
                 value: args[0][:value] * -1 }
    end

    # multiplication
    def multiply( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

      stack << { type: :numeric, base: 10,
                 value: args[1][:value] * args[0][:value] }
    end

    # division
    def divide( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

      raise 'Division by 0' if args[0][:value].zero?

      stack << { type: :numeric, base: 10,
                 value: args[1][:value] / args[0][:value] }
    end

    # inverse
    def inverse( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric]] )

      raise 'Division by 0' if args[0][:value].zero?

      stack << { type: :numeric, base: 10,
                 value: 1.0 / args[0][:value] }
    end

    # power
    def power( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

      stack << { type: :numeric, base: 10,
                 value: args[1][:value]**args[0][:value] }
    end

    # rpn_square root
    def sqrt( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric]] )

      stack << { type: :numeric, base: 10,
                 value: BigMath.sqrt( BigDecimal( args[0][:value] ), Rpl::Core.precision ) }
    end

    # rpn_square
    def sq( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric]] )

      stack << { type: :numeric, base: 10,
                 value: args[0][:value] * args[0][:value] }
    end

    # absolute value
    def abs( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric]] )

      stack << { type: :numeric, base: 10,
                 value: args[0][:value].abs }
    end

    # decimal representation
    def dec( stack )
      base( stack << { type: :numeric, base: 10, value: 10 } )
    end

    # hexadecimal representation
    def hex( stack )
      base( stack << { type: :numeric, base: 10, value: 16 } )
    end

    # binary representation
    def bin( stack )
      base( stack << { type: :numeric, base: 10, value: 2 } )
    end

    # arbitrary base representation
    def base( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

      args[1][:base] = args[0][:value]

      stack << args[1]
    end

    # 1 if number at stack level 1 is > 0, 0 if == 0, -1 if <= 0
    def sign( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric]] )
      value = if args[0][:value].positive?
                1
              elsif args[0][:value].negative?
                -1
              else
                0
              end

      stack << { type: :numeric, base: 10,
                 value: value }
    end

    # OPERATIONS ON REALS

    # percent
    def percent( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

      stack << { type: :numeric,
                 base: 10,
                 value: args[0][:value] * ( args[1][:value] / 100.0 ) }

      stack
    end

    # inverse percent
    def inverse_percent( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

      stack << { type: :numeric,
                 base: 10,
                 value: 100.0 * ( args[0][:value] / args[1][:value] ) }

      stack
    end

    # modulo
    def mod( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

      stack << { type: :numeric,
                 base: 10,
                 value: args[1][:value] % args[0][:value] }

      stack
    end

    # n! for integer n or Gamma(x+1) for fractional x
    def fact( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric]] )

      stack << { type: :numeric,
                 base: 10,
                 value: Math.gamma( args[0][:value] ) }

      stack
    end

    # largest number <=
    def floor( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric]] )

      stack << { type: :numeric,
                 base: 10,
                 value: args[0][:value].floor }

      stack
    end

    # smallest number >=
    def ceil( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric]] )

      stack << { type: :numeric,
                 base: 10,
                 value: args[0][:value].ceil }

      stack
    end

    # min of 2 real numbers
    def min( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

      stack << ( args[0][:value] < args[1][:value] ? args[0] : args[1] )

      stack
    end

    # max of 2 real numbers
    def max( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

      stack << ( args[0][:value] > args[1][:value] ? args[0] : args[1] )

      stack
    end
  end
end
