# frozen_string_literal: true

module Types
  class RplProgram
    attr_accessor :value

    def initialize( value )
      raise RplTypeError unless self.class.can_parse?( value )

      # we systematically trim enclosing « »
      @value = value[2..-3] # TODO: parse each element ?
    end

    def to_s
      "« #{@value} »"
    end

    def self.can_parse?( value )
      value.length > 4 &&
        value[0..1] == '« ' &&
        value[-2..] == ' »' &&
        !value[2..-3].strip.empty?
    end

    def ==( other )
      other.class == RplProgram &&
        other.value == value
    end
  end
end
