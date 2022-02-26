# frozen_string_literal: true

module RplLang
  module Words
    module Operations
      include Types

      def populate_dictionary
        super

        # Usual operations on reals and complexes
        @dictionary.add_word( ['+'],
                              'Usual operations on reals and complexes',
                              '( a b -- c ) addition',
                              proc do
                                addable = [RplNumeric, RplString, RplName, RplList]
                                args = stack_extract( [addable, addable] )
                                # | +         | 1 numeric | 1 string | 1 name |v1 list |
                                # |-----------+-----------+----------+--------+--------|
                                # | 0 numeric | numeric   | string   | name   |vlist   |
                                # |v0 string  |vstring    |vstring   |vstring |vlist   |
                                # |v0 name    |vstring    |vstring   |vname   |vlist   |
                                # |v0 list    |vlist      |vlist     |vlist   |vlist   |

                                args.reverse!

                                result = if args[0].instance_of?( RplList )
                                           if args[1].instance_of?( RplList )
                                             args[0].value.concat( args[1].value )
                                           else
                                             args[0].value << args[1]
                                           end
                                           args[0]

                                         elsif args[1].instance_of?( RplList )
                                           if args[0].instance_of?( RplList )
                                             args[0].value.concat( args[1].value )
                                             args[0]
                                           else
                                             args[1].value.unshift( args[0] )
                                             args[1]
                                           end

                                         elsif args[0].instance_of?( RplString )
                                           args[0].value = if args[1].instance_of?( RplString ) ||
                                                              args[1].instance_of?( RplName )
                                                             "#{args[0].value}#{args[1].value}"
                                                           else
                                                             "#{args[0].value}#{args[1]}"
                                                           end
                                           args[0]

                                         elsif args[0].instance_of?( RplName )

                                           if args[1].instance_of?( RplName )
                                             args[0].value = "#{args[0].value}#{args[1].value}"
                                             args[0]
                                           else
                                             if args[1].instance_of?( RplString )
                                               RplString.new( "\"#{args[0].value}#{args[1].value}\"" )
                                             elsif args[1].instance_of?( RplNumeric )
                                               args[0].value = "#{args[0].value}#{args[1]}"
                                               args[0]
                                             else
                                               RplString.new( "\"#{args[0]}#{args[1]}\"" )
                                             end
                                           end

                                         elsif args[0].instance_of?( RplNumeric )
                                           if args[1].instance_of?( RplNumeric )
                                             args[0].value += args[1].value
                                             args[0]

                                           elsif args[1].instance_of?( RplString ) ||
                                                 args[1].instance_of?( RplName )
                                             args[1].value = "#{args[0]}#{args[1].value}"
                                             args[1]
                                           end
                                         end

                                @stack << result
                              end )

        @dictionary.add_word( ['-'],
                              'Usual operations on reals and complexes',
                              '( a b -- c ) subtraction',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                args[1].value = args[1].value - args[0].value

                                @stack << args[1]
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
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                args[1].value = args[1].value * args[0].value

                                @stack << args[1]
                              end )

        @dictionary.add_word( ['÷', '/'],
                              'Usual operations on reals and complexes',
                              '( a b -- c ) division',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                args[1].value = args[1].value / args[0].value

                                @stack << args[1]
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
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                args[1].value = args[1].value**args[0].value

                                @stack << args[1]
                              end )

        @dictionary.add_word( ['√', 'sqrt'],
                              'Usual operations on reals and complexes',
                              '( a -- b ) square root',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                args[0].value = BigMath.sqrt( args[0].value, RplNumeric.precision )

                                @stack << args[0]
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
                                args = stack_extract( [[RplNumeric]] )

                                args[0].value = args[0].value.abs

                                @stack << args[0]
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
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                args[1].base = args[0].value

                                @stack << args[1]
                              end )

        @dictionary.add_word( ['sign'],
                              'Usual operations on reals and complexes',
                              '( a -- b ) sign of element',
                              proc do
                                args = stack_extract( [[RplNumeric]] )
                                args[0].value = if args[0].value.positive?
                                                  1
                                                elsif args[0].value.negative?
                                                  -1
                                                else
                                                  0
                                                end

                                @stack << args[0]
                              end )

        # Operations on reals
        @dictionary.add_word( ['%'],
                              'Operations on reals',
                              '( a b -- c ) b% of a',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                args[1].value = args[0].value * ( args[1].value / 100.0 )

                                @stack << args[1]
                              end )

        @dictionary.add_word( ['%CH'],
                              'Operations on reals',
                              '( a b -- c ) b is c% of a',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                args[1].value = 100.0 * ( args[0].value / args[1].value )

                                @stack << args[1]
                              end )

        @dictionary.add_word( ['mod'],
                              'Operations on reals',
                              '( a b -- c ) modulo',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                args[1].value = args[1].value % args[0].value

                                @stack << args[1]
                              end )

        @dictionary.add_word( ['!', 'fact'],
                              'Operations on reals',
                              '( a -- b ) factorial',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                args[0].value = Math.gamma( args[0].value )

                                @stack << args[0]
                              end )

        @dictionary.add_word( ['floor'],
                              'Operations on reals',
                              '( a -- b ) highest integer under a',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                args[0].value = args[0].value.floor

                                @stack << args[0]
                              end )

        @dictionary.add_word( ['ceil'],
                              'Operations on reals',
                              '( a -- b ) highest integer over a',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                args[0].value = args[0].value.ceil

                                @stack << args[0]
                              end )

        @dictionary.add_word( ['min'],
                              'Operations on reals',
                              '( a b -- a/b ) leave lowest of a or b',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                @stack << ( args[0].value < args[1].value ? args[0] : args[1] )
                              end )

        @dictionary.add_word( ['max'],
                              'Operations on reals',
                              '( a b -- a/b ) leave highest of a or b',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                @stack << ( args[0].value > args[1].value ? args[0] : args[1] )
                              end )

        @dictionary.add_word( ['mant'],
                              'Operations on reals',
                              'mantissa of a real number',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                @stack << RplNumeric.new( args[0].value.to_s.split('e').first.to_f.abs )
                              end )

        @dictionary.add_word( ['xpon'],
                              'Operations on reals',
                              'exponant of a real number',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                args[0].value = args[0].value.exponent

                                @stack << args[0]
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
                                args = stack_extract( [[RplNumeric]] )

                                args[0].value = args[0].value.frac

                                @stack << args[0]
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
