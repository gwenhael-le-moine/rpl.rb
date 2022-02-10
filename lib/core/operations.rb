# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # addition
      def add
        addable = %i[numeric string name list]
        args = stack_extract( [addable, addable] )
        # | +         | 1 numeric | 1 string | 1 name | 1 list |
        # |-----------+-----------+----------+--------+--------|
        # | 0 numeric | numeric   | string   | name   | list   |
        # | 0 string  | string    | string   | string | list   |
        # | 0 name    | string    | string   | name   | list   |
        # | 0 list    | list      | list     | list   | list   |

        result = { type: case args[0][:type]
                         when :numeric
                           args[1][:type]

                         when :string
                           case args[1][:type]
                           when :list
                             :list
                           else
                             :string
                           end

                         when :name
                           case args[1][:type]
                           when :name
                             :name
                           when :list
                             :list
                           else
                             :string
                           end

                         when :list
                           :list

                         else
                           args[0][:type]
                         end }

        if result[:type] == :list
          args.each do |elt|
            next unless elt[:type] != :list

            elt_copy = Marshal.load(Marshal.dump( elt ))
            elt[:type] = :list
            elt[:value] = [elt_copy]
          end
        end

        value_to_string = lambda do |e|
          if e[:type] == :numeric
            stringify( e )
          else
            e[:value].to_s
          end
        end

        result[:value] = if %i[name string].include?( result[:type] )
                           "#{value_to_string.call( args[1] )}#{value_to_string.call( args[0] )}"
                         else
                           args[1][:value] + args[0][:value]
                         end

        result[:base] = args[0][:base] if result[:type] == :numeric

        @stack << result
      end

      # substraction
      def subtract
        args = stack_extract( [%i[numeric], %i[numeric]] )

        @stack << { type: :numeric, base: infer_resulting_base( args ),
                    value: args[1][:value] - args[0][:value] }

        [stack, dictionary]
      end

      # multiplication
      def multiply
        args = stack_extract( [%i[numeric], %i[numeric]] )

        @stack << { type: :numeric, base: infer_resulting_base( args ),
                    value: args[1][:value] * args[0][:value] }

        [stack, dictionary]
      end

      # division
      def divide
        args = stack_extract( [%i[numeric], %i[numeric]] )

        @stack << { type: :numeric, base: infer_resulting_base( args ),
                    value: args[1][:value] / args[0][:value] }
      end

      # power
      def power
        args = stack_extract( [%i[numeric], %i[numeric]] )

        @stack << { type: :numeric, base: infer_resulting_base( args ),
                    value: args[1][:value]**args[0][:value] }
      end

      # rpn_square root
      def sqrt
        args = stack_extract( [%i[numeric]] )

        @stack << { type: :numeric, base: infer_resulting_base( args ),
                    value: BigMath.sqrt( BigDecimal( args[0][:value], precision ), precision ) }
      end

      # rpn_square
      def sq
        args = stack_extract( [%i[numeric]] )

        @stack << { type: :numeric, base: infer_resulting_base( args ),
                    value: args[0][:value] * args[0][:value] }
      end

      # absolute value
      def abs
        args = stack_extract( [%i[numeric]] )

        @stack << { type: :numeric, base: infer_resulting_base( args ),
                    value: args[0][:value].abs }
      end

      # arbitrary base representation
      def base
        args = stack_extract( [%i[numeric], %i[numeric]] )

        args[1][:base] = args[0][:value]

        @stack << args[1]
      end

      # 1 if number at stack level 1 is > 0, 0 if == 0, -1 if <= 0
      def sign
        args = stack_extract( [%i[numeric]] )
        value = if args[0][:value].positive?
                  1
                elsif args[0][:value].negative?
                  -1
                else
                  0
                end

        @stack << { type: :numeric, base: infer_resulting_base( args ),
                    value: value }
      end

      # OPERATIONS ON REALS

      # percent
      def percent
        args = stack_extract( [%i[numeric], %i[numeric]] )

        @stack << { type: :numeric,
                    base: infer_resulting_base( args ),
                    value: args[0][:value] * ( args[1][:value] / 100.0 ) }
      end

      # inverse percent
      def inverse_percent
        args = stack_extract( [%i[numeric], %i[numeric]] )

        @stack << { type: :numeric,
                    base: infer_resulting_base( args ),
                    value: 100.0 * ( args[0][:value] / args[1][:value] ) }
      end

      # modulo
      def mod
        args = stack_extract( [%i[numeric], %i[numeric]] )

        @stack << { type: :numeric,
                    base: infer_resulting_base( args ),
                    value: args[1][:value] % args[0][:value] }
      end

      # n! for integer n or Gamma(x+1) for fractional x
      def fact
        args = stack_extract( [%i[numeric]] )

        @stack << { type: :numeric,
                    base: infer_resulting_base( args ),
                    value: Math.gamma( args[0][:value] ) }
      end

      # largest number <=
      def floor
        args = stack_extract( [%i[numeric]] )

        @stack << { type: :numeric,
                    base: infer_resulting_base( args ),
                    value: args[0][:value].floor }
      end

      # smallest number >=
      def ceil
        args = stack_extract( [%i[numeric]] )

        @stack << { type: :numeric,
                    base: infer_resulting_base( args ),
                    value: args[0][:value].ceil }
      end

      # min of 2 real numbers
      def min
        args = stack_extract( [%i[numeric], %i[numeric]] )

        @stack << ( args[0][:value] < args[1][:value] ? args[0] : args[1] )
      end

      # max of 2 real numbers
      def max
        args = stack_extract( [%i[numeric], %i[numeric]] )

        @stack << ( args[0][:value] > args[1][:value] ? args[0] : args[1] )
      end

      # implemented in Rpl
      # negation
      def negate
        run( '-1 *' )
      end

      # inverse
      def inverse
        run( '1.0 swap /' )
      end

      # decimal representation
      def dec
        run( '10 base' )
      end

      # hexadecimal representation
      def hex
        run( '16 base' )
      end

      # binary representation
      def bin
        run( '2 base' )
      end
    end
  end
end
