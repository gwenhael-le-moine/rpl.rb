# frozen_string_literal: true

module RplLang
  module Words
    module Operations
      def populate_dictionary
        super

        # Usual operations on reals and complexes
        @dictionary.add_word( ['+'],
                              'Usual operations on reals and complexes',
                              '( a b -- c ) addition',
                              proc do
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
                              end )

        @dictionary.add_word( ['-'],
                              'Usual operations on reals and complexes',
                              '( a b -- c ) subtraction',
                              proc do
                                args = stack_extract( [%i[numeric], %i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: args[1][:value] - args[0][:value] }
                              end )

        @dictionary.add_word( ['chs'],
                              'Usual operations on reals and complexes',
                              '( a -- b ) negate',
                              proc do
                                run( '-1 *' )
                              end )

        @dictionary.add_word( ['×', '*'],
                              'Usual operations on reals and complexes',
                              '( a b -- c ) multiplication',
                              proc do
                                args = stack_extract( [%i[numeric], %i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: args[1][:value] * args[0][:value] }
                              end )

        @dictionary.add_word( ['÷', '/'],
                              'Usual operations on reals and complexes',
                              '( a b -- c ) division',
                              proc do
                                args = stack_extract( [%i[numeric], %i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: args[1][:value] / args[0][:value] }
                              end )

        @dictionary.add_word( ['inv'],
                              'Usual operations on reals and complexes',
                              '( a -- b ) invert numeric',
                              proc do
                                run( '1.0 swap /' )
                              end )

        @dictionary.add_word( ['^'],
                              'Usual operations on reals and complexes',
                              '( a b -- c ) a to the power of b',
                              proc do
                                args = stack_extract( [%i[numeric], %i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: args[1][:value]**args[0][:value] }
                              end )

        @dictionary.add_word( ['√', 'sqrt'],
                              'Usual operations on reals and complexes',
                              '( a -- b ) square root',
                              proc do
                                args = stack_extract( [%i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: BigMath.sqrt( BigDecimal( args[0][:value], precision ), precision ) }
                              end )

        @dictionary.add_word( ['²', 'sq'],
                              'Usual operations on reals and complexes',
                              '( a -- b ) square',
                              proc do
                                run( 'dup ×')
                              end )

        @dictionary.add_word( ['abs'],
                              'Usual operations on reals and complexes',
                              '( a -- b ) absolute value',
                              proc do
                                args = stack_extract( [%i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: args[0][:value].abs }
                              end )

        @dictionary.add_word( ['dec'],
                              'Usual operations on reals and complexes',
                              '( a -- a ) set numeric\'s base to 10',
                              proc do
                                run( '10 base' )
                              end )

        @dictionary.add_word( ['hex'],
                              'Usual operations on reals and complexes',
                              '( a -- a ) set numeric\'s base to 16',
                              proc do
                                run( '16 base' )
                              end )

        @dictionary.add_word( ['bin'],
                              'Usual operations on reals and complexes',
                              '( a -- a ) set numeric\'s base to 2',
                              proc do
                                run( '2 base' )
                              end )

        @dictionary.add_word( ['base'],
                              'Usual operations on reals and complexes',
                              '( a b -- a ) set numeric\'s base to b',
                              proc do
                                args = stack_extract( [%i[numeric], %i[numeric]] )

                                args[1][:base] = args[0][:value]

                                @stack << args[1]
                              end )

        @dictionary.add_word( ['sign'],
                              'Usual operations on reals and complexes',
                              '( a -- b ) sign of element',
                              proc do
                                args = stack_extract( [%i[numeric]] )
                                value = if args[0][:value].positive?
                                          1
                                        elsif args[0][:value].negative?
                                          -1
                                        else
                                          0
                                        end

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: value }
                              end )

        # Operations on reals
        @dictionary.add_word( ['%'],
                              'Operations on reals',
                              '( a b -- c ) b% of a',
                              proc do
                                args = stack_extract( [%i[numeric], %i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: args[0][:value] * ( args[1][:value] / 100.0 ) }
                              end )

        @dictionary.add_word( ['%CH'],
                              'Operations on reals',
                              '( a b -- c ) b is c% of a',
                              proc do
                                args = stack_extract( [%i[numeric], %i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: 100.0 * ( args[0][:value] / args[1][:value] ) }
                              end )

        @dictionary.add_word( ['mod'],
                              'Operations on reals',
                              '( a b -- c ) modulo',
                              proc do
                                args = stack_extract( [%i[numeric], %i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: args[1][:value] % args[0][:value] }
                              end )

        @dictionary.add_word( ['!', 'fact'],
                              'Operations on reals',
                              '( a -- b ) factorial',
                              proc do
                                args = stack_extract( [%i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: Math.gamma( args[0][:value] ) }
                              end )

        @dictionary.add_word( ['floor'],
                              'Operations on reals',
                              '( a -- b ) highest integer under a',
                              proc do
                                args = stack_extract( [%i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: args[0][:value].floor }
                              end )

        @dictionary.add_word( ['ceil'],
                              'Operations on reals',
                              '( a -- b ) highest integer over a',
                              proc do
                                args = stack_extract( [%i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: args[0][:value].ceil }
                              end )

        @dictionary.add_word( ['min'],
                              'Operations on reals',
                              '( a b -- a/b ) leave lowest of a or b',
                              proc do
                                args = stack_extract( [%i[numeric], %i[numeric]] )

                                @stack << ( args[0][:value] < args[1][:value] ? args[0] : args[1] )
                              end )

        @dictionary.add_word( ['max'],
                              'Operations on reals',
                              '( a b -- a/b ) leave highest of a or b',
                              proc do
                                args = stack_extract( [%i[numeric], %i[numeric]] )

                                @stack << ( args[0][:value] > args[1][:value] ? args[0] : args[1] )
                              end )

        @dictionary.add_word( ['mant'],
                              'Operations on reals',
                              'mantissa of a real number',
                              proc do
                                args = stack_extract( [%i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: BigDecimal( args[0][:value].to_s.split('e').first.to_f.abs, @precision ) }
                              end )

        @dictionary.add_word( ['xpon'],
                              'Operations on reals',
                              'exponant of a real number',
                              proc do
                                args = stack_extract( [%i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: args[0][:value].exponent }
                              end )

        @dictionary.add_word( ['ip'],
                              'Operations on reals',
                              '( n -- i ) integer part',
                              proc do
                                run( 'dup fp -' )
                              end )

        @dictionary.add_word( ['fp'],
                              'Operations on reals',
                              '( n -- f ) fractional part',
                              proc do
                                args = stack_extract( [%i[numeric]] )

                                @stack << { type: :numeric,
                                            base: infer_resulting_base( args ),
                                            value: args[0][:value].frac }
                              end )

        # Operations on complexes
        # @dictionary.add_word( ['re'],
        #                       'Operations on complexes',
        #                       'complex real part',
        #                       proc do

        #                       end )

        # @dictionary.add_word( 'im',
        #                       'Operations on complexes',
        #                       'complex imaginary part',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['conj'],
        #                       'Operations on complexes',
        #                       'complex conjugate',
        #                       proc do

        #                       end )

        # @dictionary.add_word( 'arg',
        #                       'Operations on complexes',
        #                       'complex argument in radians',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['c→r', 'c->r'],
        #                       'Operations on complexes',
        #                       'transform a complex in 2 reals',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['r→c', 'r->c'],
        #                       'Operations on complexes',
        #                       'transform 2 reals in a complex',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['p→r', 'p->r'],
        #                       'Operations on complexes',
        #                       'cartesian to polar',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['r→p', 'r->p'],
        #                       'Operations on complexes',
        #                       'polar to cartesian',
        #                       proc do

        #                       end )
      end
    end
  end
end
