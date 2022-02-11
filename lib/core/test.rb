# frozen_string_literal: true

module RplLang
  module Core
    module Test
      def populate_dictionary
        super

        @dictionary.add_word( ['>'],
                              'Test',
                              '( a b -- t ) is a greater than b?',
                              proc do
                                args = stack_extract( %i[any any] )

                                @stack << { type: :boolean,
                                            value: args[1][:value] > args[0][:value] }
                              end )

        @dictionary.add_word( ['≥', '>='],
                              'Test',
                              '( a b -- t ) is a greater than or equal to b?',
                              proc do
                                args = stack_extract( %i[any any] )

                                @stack << { type: :boolean,
                                            value: args[1][:value] >= args[0][:value] }
                              end )

        @dictionary.add_word( ['<'],
                              'Test',
                              '( a b -- t ) is a less than b?',
                              proc do
                                args = stack_extract( %i[any any] )

                                @stack << { type: :boolean,
                                            value: args[1][:value] < args[0][:value] }
                              end )

        @dictionary.add_word( ['≤', '<='],
                              'Test',
                              '( a b -- t ) is a less than or equal to b?',
                              proc do
                                args = stack_extract( %i[any any] )

                                @stack << { type: :boolean,
                                            value: args[1][:value] <= args[0][:value] }
                              end )

        @dictionary.add_word( ['≠', '!='],
                              'Test',
                              '( a b -- t ) is a not equal to b',
                              proc do
                                args = stack_extract( %i[any any] )

                                @stack << { type: :boolean,
                                            value: args[1][:value] != args[0][:value] }
                              end )

        @dictionary.add_word( ['==', 'same'],
                              'Test',
                              '( a b -- t ) is a equal to b',
                              proc do
                                args = stack_extract( %i[any any] )

                                @stack << { type: :boolean,
                                            value: args[1][:value] == args[0][:value] }
                              end )

        @dictionary.add_word( ['and'],
                              'Test',
                              '( a b -- t ) boolean and',
                              proc do
                                args = stack_extract( [%i[boolean], %i[boolean]] )

                                @stack << { type: :boolean,
                                            value: args[1][:value] && args[0][:value] }
                              end )

        @dictionary.add_word( ['or'],
                              'Test',
                              '( a b -- t ) boolean or',
                              proc do
                                args = stack_extract( [%i[boolean], %i[boolean]] )

                                @stack << { type: :boolean,
                                            value: args[1][:value] || args[0][:value] }
                              end )

        @dictionary.add_word( ['xor'],
                              'Test',
                              '( a b -- t ) boolean xor',
                              proc do
                                args = stack_extract( [%i[boolean], %i[boolean]] )

                                @stack << { type: :boolean,
                                            value: args[1][:value] ^ args[0][:value] }
                              end )

        @dictionary.add_word( ['not'],
                              'Test',
                              '( a -- t ) invert boolean value',
                              proc do
                                args = stack_extract( [%i[boolean]] )

                                @stack << { type: :boolean,
                                            value: !args[0][:value] }
                              end )

        @dictionary.add_word( ['true'],
                              'Test',
                              '( -- t ) push true onto stack',
                              proc do
                                @stack << { type: :boolean,
                                            value: true }
                              end ) # specific

        @dictionary.add_word( ['false'],
                              'Test',
                              '( -- t ) push false onto stack',
                              proc do
                                @stack << { type: :boolean,
                                            value: false }
                              end ) # specific
      end
    end
  end
end
