# frozen_string_literal: true

module RplLang
  module Words
    module OperationsReals
      include Types

      def populate_dictionary
        super

        category = 'Operations on reals'
        # Operations on reals
        @dictionary.add_word!( ['%'],
                               category,
                               '( a b -- c ) b% of a',
                               proc do
                                 args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                 @stack << RplNumeric.new( args[0].value * ( args[1].value / 100.0 ), args[1].base )
                               end )

        @dictionary.add_word!( ['%ch'],
                               category,
                               '( a b -- c ) b is c% of a',
                               proc do
                                 args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                 @stack << RplNumeric.new( ( args[0].value / args[1].value ) * 100.0, args[1].base )
                               end )

        @dictionary.add_word!( ['mod'],
                               category,
                               '( a b -- c ) modulo',
                               proc do
                                 args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                 @stack << RplNumeric.new( args[1].value % args[0].value, args[1].base )
                               end )

        @dictionary.add_word!( ['!', 'fact'],
                               category,
                               '( a -- b ) factorial',
                               proc do
                                 args = stack_extract( [[RplNumeric]] )

                                 @stack << RplNumeric.new( Math.gamma( args[0].value ), args[0].base )
                               end )

        @dictionary.add_word!( ['floor'],
                               category,
                               '( a -- b ) highest integer under a',
                               proc do
                                 args = stack_extract( [[RplNumeric]] )

                                 @stack << RplNumeric.new( args[0].value.floor, args[0].base )
                               end )

        @dictionary.add_word!( ['ceil'],
                               category,
                               '( a -- b ) highest integer over a',
                               proc do
                                 args = stack_extract( [[RplNumeric]] )

                                 @stack << RplNumeric.new( args[0].value.ceil, args[0].base )
                               end )

        @dictionary.add_word!( ['min'],
                               category,
                               '( a b -- a/b ) leave lowest of a or b',
                               proc do
                                 args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                 @stack << ( args[0].value < args[1].value ? args[0] : args[1] )
                               end )

        @dictionary.add_word!( ['max'],
                               category,
                               '( a b -- a/b ) leave highest of a or b',
                               proc do
                                 args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                 @stack << ( args[0].value > args[1].value ? args[0] : args[1] )
                               end )

        @dictionary.add_word!( ['mant'],
                               category,
                               'mantissa of a real number',
                               proc do
                                 args = stack_extract( [[RplNumeric]] )

                                 @stack << Types.new_object( RplNumeric, args[0].value.to_s.split('e').first.to_f.abs )
                               end )

        @dictionary.add_word!( ['xpon'],
                               category,
                               'exponant of a real number',
                               proc do
                                 args = stack_extract( [[RplNumeric]] )

                                 @stack << RplNumeric.new( args[0].value.exponent, args[0].base )
                               end )

        @dictionary.add_word!( ['ip'],
                               category,
                               '( n -- i ) integer part',
                               proc do
                                 run!( 'dup fp -' )
                               end )

        @dictionary.add_word!( ['fp'],
                               category,
                               '( n -- f ) fractional part',
                               proc do
                                 args = stack_extract( [[RplNumeric]] )

                                 @stack << RplNumeric.new( args[0].value.frac, args[0].base )
                               end )
      end
    end
  end
end
