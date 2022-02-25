# frozen_string_literal: true

module Types
  class RplBoolean
    attr_accessor :value

    def initialize( value )
      raise RplTypeError unless self.class.can_parse?( value )

      @value = if value.is_a?( String )
                 value.downcase == 'true'
               else
                 value
               end
    end

    def to_s
      @value.to_s
    end

    def self.can_parse?( value )
      return %w[true false].include?( value.downcase ) if value.is_a?( String )

      %w[TrueClass FalseClass].include?( value.class.to_s )
    end
  end
end
