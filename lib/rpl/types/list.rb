# frozen_string_literal: true

require 'rpl/parser'

module Types
  class RplList
    attr_accessor :value

    def initialize( value )
      raise RplTypeError unless self.class.can_parse?( value )

      @value = if value.instance_of?( Array )
                 value
               else
                 # we systematicalyl trim enclosing { }
                 Parser.parse( value[2..-3] )
               end
    end

    def to_s
      "{ #{@value.map(&:to_s).join(' ')} }"
    end

    def self.can_parse?( value )
      value.instance_of?( Array ) or
        value[0..1] == '{ ' && value[-2..] == ' }'
    end

    def ==( other )
      other.class == RplList and
        other.value == value
    end
  end
end
