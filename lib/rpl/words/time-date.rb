# frozen_string_literal: true

require 'date'

module RplLang
  module Words
    module TimeAndDate
      include Types

      def populate_dictionary
        super

        @dictionary.add_word( ['time'],
                              'Time and date',
                              '( -- t ) push current time',
                              proc do
                                @stack << RplString.new( "\"#{Time.now}\"" )
                              end )
        @dictionary.add_word( ['date'],
                              'Time and date',
                              '( -- d ) push current date',
                              proc do
                                @stack << RplString.new( "\"#{Date.today}\"" )
                              end )
        @dictionary.add_word( ['ticks'],
                              'Time and date',
                              '( -- t ) push datetime as ticks',
                              proc do
                                ticks_since_epoch = Time.utc( 1, 1, 1 ).to_i * 10_000_000
                                now = Time.now
                                @stack << RplNumeric.new( now.to_i * 10_000_000 + now.nsec / 100 - ticks_since_epoch )
                              end )
      end
    end
  end
end
