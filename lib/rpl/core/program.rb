# frozen_string_literal: true

module RplLang
  module Core
    module Program
      def populate_dictionary
        super

        @dictionary.add_word( ['eval'],
                              'Program',
                              '( a -- … ) interpret',
                              proc do
                                args = stack_extract( [:any] )

                                if %i[list numeric boolean].include?( args[0][:type] )
                                  @stack << args[0] # these types evaluate to themselves
                                else
                                  run( args[0][:value].to_s )
                                end
                              end )
      end
    end
  end
end
