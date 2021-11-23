module Rpl
  module Core
    module_function

    # addition
    def add( stack )
      addable = %i[numeric string name]
      stack, args = Rpl::Core.stack_extract( stack, [addable, addable] )

      result = { type: case args[0][:type]
                       when :name
                         :name
                       when :string
                         :string
                       when :numeric
                         if args[1][:type] == :numeric
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
                         "'#{args[0][:value]}#{args[1][:value]}'"
                       when :string
                         "\"#{args[0][:value]}#{args[1][:value]}\""
                       when :numeric
                         args[0][:value] + args[1][:value]
                       end

      stack << result
    end

    # substraction
    def subtract( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

      stack << { type: :numeric,
                 value: args[0][:value] - args[1][:value] }
    end

    # negation
    def negate( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric]] )

      stack << { type: :numeric,
                 value: args[0][:value] * -1 }
    end

    # multiplication
    def multiply( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

      stack << { type: :numeric,
                 value: args[0][:value] * args[1][:value] }
    end

    # division
    def divide( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

      raise 'Division by 0' if args[0][:value].zero?

      stack << { type: :numeric,
                 value: args[0][:value] / args[1][:value] }
    end

    # inverse
    def inverse( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric]] )

      raise 'Division by 0' if args[0][:value].zero?

      stack << { type: :numeric,
                 value: 1.0 / args[0][:value] }
    end

    # power
    def power( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric], %i[numeric]] )

      stack << { type: :numeric,
                 value: args[0][:value]**args[1][:value] }
    end

    # rpn_square root
    def sqrt( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric]] )

      stack << { type: :numeric,
                 value: BigMath.sqrt( BigDecimal( args[0][:value] ), Rpl::Core.precision ) }
    end

    # rpn_square
    def sq( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric]] )

      stack << { type: :numeric,
                 value: args[0][:value] * args[0][:value] }
    end

    # absolute value
    def abs( stack )
      stack, args = Rpl::Core.stack_extract( stack, [%i[numeric]] )

      stack << { type: :numeric,
                 value: args[0][:value].abs }
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

      stack << { type: :numeric,
                 value: value }
    end
  end
end
