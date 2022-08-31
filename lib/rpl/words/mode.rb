# frozen_string_literal: true

module RplLang
  module Words
    module Mode
      include Types

      def populate_dictionary
        super

        category = 'Mode'

        @dictionary.add_word( ['prec'],
                              category,
                              '( a -- ) set precision to a',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                RplNumeric.precision = args[0].value
                              end )
        @dictionary.add_word( ['default'],
                              category,
                              '( -- ) set default precision',
                              proc do
                                RplNumeric.default_precision
                              end )
        @dictionary.add_word( ['type'],
                              category,
                              '( a -- s ) type of a as a string',
                              proc do
                                args = stack_extract( [:any] )

                                @stack << Types.new_object( RplString, "\"#{args[0].class.to_s[10..]}\"" )
                              end )

        # @dictionary.add_word( ['std'],
        #                  proc { __todo } ) # standard floating numbers representation. ex: std
        # @dictionary.add_word( ['fix'],
        #                  proc { __todo } ) # fixed point representation. ex: 6 fix
        # @dictionary.add_word( ['sci'],
        #                  proc { __todo } ) # scientific floating point representation. ex: 20 sci
        # @dictionary.add_word( ['round'],
        #                  proc { __todo } ) # set float rounding mode. ex: ["nearest", "toward zero", "toward +inf", "toward -inf", "away from zero"] round
      end
    end
  end
end
