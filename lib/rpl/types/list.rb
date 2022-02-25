# frozen_string_literal: true

require 'rpl/parser'

module Types
  class RplList
    attr_accessor :value

    def initialize( value )
      raise RplTypeError unless self.class.can_parse?( value )

      # we systematicalyl trim enclosing { }
      @value = Parser.parse( value[2..-3] )
    end

    def to_s
      "{ #{@value.map(&:to_s).join(' ')} }"
    end

    def self.can_parse?( value )
      value[0..1] == '{ ' && value[-2..-1] == ' }'
    end
  end
end
