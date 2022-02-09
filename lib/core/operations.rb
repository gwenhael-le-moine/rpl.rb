# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # addition
      def add( stack, dictionary )
        addable = %i[numeric string name list]
        stack, args = Rpl::Lang.stack_extract( stack, [addable, addable] )
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
            Rpl::Lang.stringify( e )
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

        stack << result

        [stack, dictionary]
      end

      # substraction
      def subtract( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric], %i[numeric]] )

        stack << { type: :numeric, base: Rpl::Lang.infer_resulting_base( args ),
                   value: args[1][:value] - args[0][:value] }

        [stack, dictionary]
      end

      # multiplication
      def multiply( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric], %i[numeric]] )

        stack << { type: :numeric, base: Rpl::Lang.infer_resulting_base( args ),
                   value: args[1][:value] * args[0][:value] }

        [stack, dictionary]
      end

      # division
      def divide( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric], %i[numeric]] )

        stack << { type: :numeric, base: Rpl::Lang.infer_resulting_base( args ),
                   value: args[1][:value] / args[0][:value] }

        [stack, dictionary]
      end

      # power
      def power( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric], %i[numeric]] )

        stack << { type: :numeric, base: Rpl::Lang.infer_resulting_base( args ),
                   value: args[1][:value]**args[0][:value] }

        [stack, dictionary]
      end

      # rpn_square root
      def sqrt( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric, base: Rpl::Lang.infer_resulting_base( args ),
                   value: BigMath.sqrt( BigDecimal( args[0][:value], Rpl::Lang.precision ), Rpl::Lang.precision ) }

        [stack, dictionary]
      end

      # rpn_square
      def sq( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric, base: Rpl::Lang.infer_resulting_base( args ),
                   value: args[0][:value] * args[0][:value] }

        [stack, dictionary]
      end

      # absolute value
      def abs( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric, base: Rpl::Lang.infer_resulting_base( args ),
                   value: args[0][:value].abs }

        [stack, dictionary]
      end

      # arbitrary base representation
      def base( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric], %i[numeric]] )

        args[1][:base] = args[0][:value]

        stack << args[1]

        [stack, dictionary]
      end

      # 1 if number at stack level 1 is > 0, 0 if == 0, -1 if <= 0
      def sign( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric]] )
        value = if args[0][:value].positive?
                  1
                elsif args[0][:value].negative?
                  -1
                else
                  0
                end

        stack << { type: :numeric, base: Rpl::Lang.infer_resulting_base( args ),
                   value: value }

        [stack, dictionary]
      end

      # OPERATIONS ON REALS

      # percent
      def percent( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric], %i[numeric]] )

        stack << { type: :numeric,
                   base: Rpl::Lang.infer_resulting_base( args ),
                   value: args[0][:value] * ( args[1][:value] / 100.0 ) }

        [stack, dictionary]
      end

      # inverse percent
      def inverse_percent( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric], %i[numeric]] )

        stack << { type: :numeric,
                   base: Rpl::Lang.infer_resulting_base( args ),
                   value: 100.0 * ( args[0][:value] / args[1][:value] ) }

        [stack, dictionary]
      end

      # modulo
      def mod( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric], %i[numeric]] )

        stack << { type: :numeric,
                   base: Rpl::Lang.infer_resulting_base( args ),
                   value: args[1][:value] % args[0][:value] }

        [stack, dictionary]
      end

      # n! for integer n or Gamma(x+1) for fractional x
      def fact( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric,
                   base: Rpl::Lang.infer_resulting_base( args ),
                   value: Math.gamma( args[0][:value] ) }

        [stack, dictionary]
      end

      # largest number <=
      def floor( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric,
                   base: Rpl::Lang.infer_resulting_base( args ),
                   value: args[0][:value].floor }

        [stack, dictionary]
      end

      # smallest number >=
      def ceil( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric]] )

        stack << { type: :numeric,
                   base: Rpl::Lang.infer_resulting_base( args ),
                   value: args[0][:value].ceil }

        [stack, dictionary]
      end

      # min of 2 real numbers
      def min( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric], %i[numeric]] )

        stack << ( args[0][:value] < args[1][:value] ? args[0] : args[1] )

        [stack, dictionary]
      end

      # max of 2 real numbers
      def max( stack, dictionary )
        stack, args = Rpl::Lang.stack_extract( stack, [%i[numeric], %i[numeric]] )

        stack << ( args[0][:value] > args[1][:value] ? args[0] : args[1] )

        [stack, dictionary]
      end

      # implemented in Rpl
      # negation
      def negate( stack, dictionary )
        Rpl::Lang.eval( stack, dictionary, '-1 *' )
      end

      # inverse
      def inverse( stack, dictionary )
        Rpl::Lang.eval( stack, dictionary, '1.0 swap /' )
      end

      # decimal representation
      def dec( stack, dictionary )
        Rpl::Lang.eval( stack, dictionary, '10 base' )
      end

      # hexadecimal representation
      def hex( stack, dictionary )
        Rpl::Lang.eval( stack, dictionary, '16 base' )
      end

      # binary representation
      def bin( stack, dictionary )
        Rpl::Lang.eval( stack, dictionary, '2 base' )
      end
    end
  end
end
