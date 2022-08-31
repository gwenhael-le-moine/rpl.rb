# frozen_string_literal: true

module RplLang
  module Words
    module Operations
      include Types

      def populate_dictionary
        super

        category = 'Usual operations on reals and complexes'

        # Usual operations on reals and complexes
        @dictionary.add_word( ['+'],
                              category,
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
                                           new_list = if args[1].instance_of?( RplList )
                                                        RplList.new( args[0].to_s ).value.concat( args[1].value )
                                                      else
                                                        RplList.new( args[0].to_s ).value.concat( [args[1]] )
                                                      end

                                           RplList.new( "{ #{new_list.join(' ')} }" )

                                         elsif args[1].instance_of?( RplList )
                                           new_list = if args[0].instance_of?( RplList )
                                                        RplList.new( args[0].to_s ).value.concat( args[1].value )
                                                      else
                                                        RplList.new( "{ #{args[0]} }" ).value.concat( args[1].value )
                                                      end

                                           RplList.new( "{ #{new_list.join(' ')} }" )

                                         elsif args[0].instance_of?( RplString )
                                           RplString.new( if args[1].instance_of?( RplString ) ||
                                                              args[1].instance_of?( RplName )
                                                            "\"#{args[0].value}#{args[1].value}\""
                                                          else
                                                            "\"#{args[0].value}#{args[1]}\""
                                                          end )

                                         elsif args[0].instance_of?( RplName )

                                           if args[1].instance_of?( RplName )
                                             RplName.new( "'#{args[0].value}#{args[1].value}'" )
                                           elsif args[1].instance_of?( RplString )
                                             Types.new_object( RplString, "\"#{args[0].value}#{args[1].value}\"" )
                                           elsif args[1].instance_of?( RplNumeric )
                                             RplName.new( "'#{args[0].value}#{args[1]}'" )
                                           else
                                             Types.new_object( RplString, "\"#{args[0]}#{args[1]}\"" )
                                           end

                                         elsif args[0].instance_of?( RplNumeric )
                                           if args[1].instance_of?( RplNumeric )
                                             RplNumeric.new( args[0].value + args[1].value, args[0].base )
                                           elsif args[1].instance_of?( RplString )
                                             RplString.new( "\"#{args[0]}#{args[1].value}\"" )
                                           elsif args[1].instance_of?( RplName )
                                             RplName.new( "'#{args[0]}#{args[1].value}'" )
                                           end
                                         end

                                @stack << result
                              end )

        @dictionary.add_word( ['-'],
                              category,
                              '( a b -- c ) subtraction',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                @stack << RplNumeric.new( args[1].value - args[0].value, args[1].base )
                              end )

        @dictionary.add_word( ['chs'],
                              category,
                              '( a -- b ) negate',
                              proc do
                                run( '-1 *' )
                              end )

        @dictionary.add_word( ['×', '*'],
                              category,
                              '( a b -- c ) multiplication',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                @stack << RplNumeric.new( args[1].value * args[0].value, args[1].base )
                              end )

        @dictionary.add_word( ['÷', '/'],
                              category,
                              '( a b -- c ) division',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                @stack << RplNumeric.new( args[1].value / args[0].value, args[1].base )
                              end )

        @dictionary.add_word( ['inv'],
                              category,
                              '( a -- b ) invert numeric',
                              proc do
                                run( '1.0 swap /' )
                              end )

        @dictionary.add_word( ['^'],
                              category,
                              '( a b -- c ) a to the power of b',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                @stack << RplNumeric.new( args[1].value**args[0].value, args[1].base )
                              end )

        @dictionary.add_word( ['√', 'sqrt'],
                              category,
                              '( a -- b ) square root',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                @stack << RplNumeric.new( BigMath.sqrt( args[0].value, RplNumeric.precision ), args[0].base )
                              end )

        @dictionary.add_word( ['²', 'sq'],
                              category,
                              '( a -- b ) square',
                              proc do
                                run( 'dup ×')
                              end )

        @dictionary.add_word( ['abs'],
                              category,
                              '( a -- b ) absolute value',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                @stack << RplNumeric.new( args[0].value.abs, args[0].base )
                              end )

        @dictionary.add_word( ['dec'],
                              category,
                              '( a -- a ) set numeric\'s base to 10',
                              proc do
                                run( '10 base' )
                              end )

        @dictionary.add_word( ['hex'],
                              category,
                              '( a -- a ) set numeric\'s base to 16',
                              proc do
                                run( '16 base' )
                              end )

        @dictionary.add_word( ['bin'],
                              category,
                              '( a -- a ) set numeric\'s base to 2',
                              proc do
                                run( '2 base' )
                              end )

        @dictionary.add_word( ['base'],
                              category,
                              '( a b -- a ) set numeric\'s base to b',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                @stack << RplNumeric.new( args[1].value, args[0].value )
                              end )

        @dictionary.add_word( ['sign'],
                              category,
                              '( a -- b ) sign of element',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                @stack << RplNumeric.new( if args[0].value.positive?
                                                            1
                                                          elsif args[0].value.negative?
                                                            -1
                                                          else
                                                            0
                                                          end )
                              end )

        category = 'Operations on reals'
        # Operations on reals
        @dictionary.add_word( ['%'],
                              category,
                              '( a b -- c ) b% of a',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                @stack << RplNumeric.new( args[0].value * ( args[1].value / 100.0 ), args[1].base )
                              end )

        @dictionary.add_word( ['%CH'],
                              category,
                              '( a b -- c ) b is c% of a',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                @stack << RplNumeric.new( 100.0 * ( args[0].value / args[1].value ), args[1].base )
                              end )

        @dictionary.add_word( ['mod'],
                              category,
                              '( a b -- c ) modulo',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                @stack << RplNumeric.new( args[1].value % args[0].value, args[1].base )
                              end )

        @dictionary.add_word( ['!', 'fact'],
                              category,
                              '( a -- b ) factorial',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                @stack << RplNumeric.new( Math.gamma( args[0].value ), args[0].base )
                              end )

        @dictionary.add_word( ['floor'],
                              category,
                              '( a -- b ) highest integer under a',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                @stack << RplNumeric.new( args[0].value.floor, args[0].base )
                              end )

        @dictionary.add_word( ['ceil'],
                              category,
                              '( a -- b ) highest integer over a',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                @stack << RplNumeric.new( args[0].value.ceil, args[0].base )
                              end )

        @dictionary.add_word( ['min'],
                              category,
                              '( a b -- a/b ) leave lowest of a or b',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                @stack << ( args[0].value < args[1].value ? args[0] : args[1] )
                              end )

        @dictionary.add_word( ['max'],
                              category,
                              '( a b -- a/b ) leave highest of a or b',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                @stack << ( args[0].value > args[1].value ? args[0] : args[1] )
                              end )

        @dictionary.add_word( ['mant'],
                              category,
                              'mantissa of a real number',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                @stack << Types.new_object( RplNumeric, args[0].value.to_s.split('e').first.to_f.abs )
                              end )

        @dictionary.add_word( ['xpon'],
                              category,
                              'exponant of a real number',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                @stack << RplNumeric.new( args[0].value.exponent, args[0].base )
                              end )

        @dictionary.add_word( ['ip'],
                              category,
                              '( n -- i ) integer part',
                              proc do
                                run( 'dup fp -' )
                              end )

        @dictionary.add_word( ['fp'],
                              category,
                              '( n -- f ) fractional part',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                @stack << RplNumeric.new( args[0].value.frac, args[0].base )
                              end )

        category = 'Operations on complexes'
        # Operations on complexes
        # @dictionary.add_word( ['re'],
        #                       category,
        #                       '( c -- n ) complex real part',
        #                       proc do

        #                       end )

        # @dictionary.add_word( 'im',
        #                       category,
        #                       '( c -- n ) complex imaginary part',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['conj'],
        #                       category,
        #                       '( c -- c ) complex conjugate',
        #                       proc do

        #                       end )

        # @dictionary.add_word( 'arg',
        #                       category,
        #                       'complex argument in radians',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['c→r', 'c->r'],
        #                       category,
        #                       '( c -- n n ) transform a complex in 2 reals',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['r→c', 'r->c'],
        #                       category,
        #                       '( n n -- c ) transform 2 reals in a complex',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['p→r', 'p->r'],
        #                       category,
        #                       'cartesian to polar',
        #                       proc do

        #                       end )

        # @dictionary.add_word( ['r→p', 'r->p'],
        #                       category,
        #                       'polar to cartesian',
        #                       proc do

        #                       end )
      end
    end
  end
end
