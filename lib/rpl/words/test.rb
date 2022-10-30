# frozen_string_literal: true

module RplLang
  module Words
    module Test
      include Types

      def populate_dictionary
        super

        category = 'Test'

        @dictionary.add_word!( ['>'],
                               category,
                               '( a b -- t ) is a greater than b?',
                               proc do
                                 args = stack_extract( %i[any any] )

                                 @stack << Types.new_object( RplBoolean, args[1].value > args[0].value )
                               end )

        @dictionary.add_word!( ['≥', '>='],
                               category,
                               '( a b -- t ) is a greater than or equal to b?',
                               proc do
                                 args = stack_extract( %i[any any] )

                                 @stack << Types.new_object( RplBoolean, args[1].value >= args[0].value )
                               end )

        @dictionary.add_word!( ['<'],
                               category,
                               '( a b -- t ) is a less than b?',
                               proc do
                                 args = stack_extract( %i[any any] )

                                 @stack << Types.new_object( RplBoolean, args[1].value < args[0].value )
                               end )

        @dictionary.add_word!( ['≤', '<='],
                               category,
                               '( a b -- t ) is a less than or equal to b?',
                               proc do
                                 args = stack_extract( %i[any any] )

                                 @stack << Types.new_object( RplBoolean, args[1].value <= args[0].value )
                               end )

        @dictionary.add_word!( ['≠', '!='],
                               category,
                               '( a b -- t ) is a not equal to b',
                               proc do
                                 args = stack_extract( %i[any any] )

                                 @stack << Types.new_object( RplBoolean, args[1].value != args[0].value )
                               end )

        @dictionary.add_word!( ['==', 'same'],
                               category,
                               '( a b -- t ) is a equal to b',
                               proc do
                                 args = stack_extract( %i[any any] )

                                 @stack << Types.new_object( RplBoolean, args[1].value == args[0].value )
                               end )

        @dictionary.add_word!( ['and'],
                               category,
                               '( a b -- t ) boolean and',
                               proc do
                                 args = stack_extract( [[RplBoolean], [RplBoolean]] )

                                 @stack << Types.new_object( RplBoolean, args[1].value && args[0].value )
                               end )

        @dictionary.add_word!( ['or'],
                               category,
                               '( a b -- t ) boolean or',
                               proc do
                                 args = stack_extract( [[RplBoolean], [RplBoolean]] )

                                 @stack << Types.new_object( RplBoolean, args[1].value || args[0].value )
                               end )

        @dictionary.add_word!( ['xor'],
                               category,
                               '( a b -- t ) boolean xor',
                               proc do
                                 args = stack_extract( [[RplBoolean], [RplBoolean]] )

                                 @stack << Types.new_object( RplBoolean, args[1].value ^ args[0].value )
                               end )

        @dictionary.add_word!( ['not'],
                               category,
                               '( a -- t ) invert boolean value',
                               proc do
                                 args = stack_extract( [[RplBoolean]] )

                                 @stack << Types.new_object( RplBoolean, !args[0].value )
                               end )

        @dictionary.add_word!( ['true'],
                               category,
                               '( -- t ) push true onto stack',
                               proc do
                                 @stack << Types.new_object( RplBoolean, true )
                               end )

        @dictionary.add_word!( ['false'],
                               category,
                               '( -- t ) push false onto stack',
                               proc do
                                 @stack << Types.new_object( RplBoolean, false )
                               end )
      end
    end
  end
end
