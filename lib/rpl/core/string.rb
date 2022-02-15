# frozen_string_literal: true

module RplLang
  module Core
    module String
      def populate_dictionary
        super

        @dictionary.add_word( ['→str', '->str'],
                              'String',
                              '( a -- s ) convert element to string',
                              proc do
                                args = stack_extract( [:any] )

                                @stack << { type: :string,
                                            value: stringify( args[0] ) }
                              end )

        @dictionary.add_word( ['str→', 'str->'],
                              'String',
                              '( s -- a ) convert string to element',
                              proc do
                                args = stack_extract( [%i[string]] )

                                @stack += parse( args[0][:value] )
                              end )

        @dictionary.add_word( ['chr'],
                              'String',
                              '( n -- c ) convert ASCII character code in stack level 1 into a string',
                              proc do
                                args = stack_extract( [%i[numeric]] )

                                @stack << { type: :string,
                                            value: args[0][:value].to_i.chr }
                              end )

        @dictionary.add_word( ['num'],
                              'String',
                              '( s -- n ) return ASCII code of the first character of the string in stack level 1 as a real number',
                              proc do
                                args = stack_extract( [%i[string]] )

                                @stack << { type: :numeric,
                                            base: 10,
                                            value: args[0][:value].ord }
                              end )

        @dictionary.add_word( ['size'],
                              'String',
                              '( s -- n ) return the length of the string',
                              proc do
                                args = stack_extract( [%i[string]] )

                                @stack << { type: :numeric,
                                            base: 10,
                                            value: args[0][:value].length }
                              end )

        @dictionary.add_word( ['pos'],
                              'String',
                              '( s s -- n ) search for the string in level 1 within the string in level 2',
                              proc do
                                args = stack_extract( [%i[string], %i[string]] )

                                @stack << { type: :numeric,
                                            base: 10,
                                            value: args[1][:value].index( args[0][:value] ) }
                              end )

        @dictionary.add_word( ['sub'],
                              'String',
                              '( s n n -- s ) return a substring of the string in level 3',
                              proc do
                                args = stack_extract( [%i[numeric], %i[numeric], %i[string]] )

                                @stack << { type: :string,
                                            value: args[2][:value][ (args[1][:value] - 1)..(args[0][:value] - 1) ] }
                              end )

        @dictionary.add_word( ['rev'],
                              'String',
                              '( s -- s ) reverse string',
                              proc do
                                args = stack_extract( [%i[string list]] )

                                result = args[0]

                                case args[0][:type]
                                when :string
                                  result = { type: :string,
                                             value: args[0][:value].reverse }
                                when :list
                                  result[:value].reverse!
                                end

                                @stack << result
                              end )

        @dictionary.add_word( ['split'],
                              'String',
                              '( s c -- … ) split string s on character c',
                              proc do
                                args = stack_extract( [%i[string], %i[string]] )

                                args[1][:value].split( args[0][:value] ).each do |elt|
                                  @stack << { type: :string,
                                              value: elt }
                                end
                              end )
      end
    end
  end
end
