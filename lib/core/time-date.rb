require 'date'

module Rpl
  module Lang
    module Core
      module_function

      # time in local format
      def time( stack )
        stack << { type: :string,
                   value: Time.now.to_s }
      end

      # date in local format
      def date( stack )
        stack << { type: :string,
                   value: Date.today.to_s }
      end

      # system tick in µs
      def ticks( stack )
        ticks_since_epoch = Time.utc( 1, 1, 1 ).to_i * 10_000_000
        now = Time.now
        stack << { type: :numeric,
                   base: 10,
                   value: now.to_i * 10_000_000 + now.nsec / 100 - ticks_since_epoch }
      end
    end
  end
end
