# frozen_string_literal: true

require 'rpl/parser'

module Types
  class RplComplex
    attr_accessor :value

    def initialize( value )
      raise RplTypeError unless self.class.can_parse?( value )

      # we systematicalyl trim enclosing ()
      value = value[1..-2] if value.is_a?( String ) && value[0] == '(' && value[-1] == ')'

      @value = Complex( value )
    end

    def to_s
      "(#{@value})"
    end

    def self.can_parse?( value )
      # we systematically trim enclosing ()
      value = value[1..-2] if value.is_a?( String ) && (value[0] == '(') && (value[-1] == ')')

      !Complex( value, exception: false ).nil?
    end

    def ==( other )
      other.class == RplComplex &&
        other.value == value
    end
  end
end
