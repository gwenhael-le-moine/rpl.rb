# frozen_string_literal: true

require 'date'

module RplLang
  module Core
    module TimeAndDate
      def populate_dictionary
        super

        @dictionary.add_word( ['time'],
                              'Time and date',
                              '( -- t ) push current time',
                              proc do
                                @stack << { type: :string,
                                            value: Time.now.to_s }
                              end )
        @dictionary.add_word( ['date'],
                              'Time and date',
                              '( -- d ) push current date',
                              proc do
                                @stack << { type: :string,
                                            value: Date.today.to_s }
                              end )
        @dictionary.add_word( ['ticks'],
                              'Time and date',
                              '( -- t ) push datetime as ticks',
                              proc do
                                ticks_since_epoch = Time.utc( 1, 1, 1 ).to_i * 10_000_000
                                now = Time.now
                                @stack << { type: :numeric,
                                            base: 10,
                                            value: now.to_i * 10_000_000 + now.nsec / 100 - ticks_since_epoch }
                              end )
      end
    end
  end
end
