# frozen_string_literal: true

require 'rpl/parser'

module Types
  class RplComplex
    attr_accessor :value

    def initialize( value )
      raise RplTypeError unless self.class.can_parse?( value )

      # we systematicalyl trim enclosing ()
      @value = Complex( value[1..-2] )
    end

    def to_s
      "(#{@value})"
    end

    def self.can_parse?( value )
      possibility = value[0] == '(' && value[-1] == ')'

      return possibility unless possibility

      begin
        Complex( value[1..-2] )
      rescue ArgumentError
        possibility = false
      end

      possibility
    end

    def ==( other )
      other.class == RplComplex and
        other.value == value
    end
  end
end
