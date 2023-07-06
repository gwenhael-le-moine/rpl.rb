# frozen_string_literal: true

require 'rpl/parser'

module Types
  class RplGrOb
    attr_reader :width,
                :height,
                :bits,
                :value

    def initialize( value )
      raise RplTypeError unless self.class.can_parse?( value )

      parsed = /^GROB:(?<width>\d+):(?<height>\d+):(?<bits>[0-9a-f]+)$/.match( value )

      @width = parsed[:width].to_i
      @height = parsed[:height].to_i
      @bits = parsed[:bits].to_i( 16 )

      @value = [@width, @height, @bits]
    end

    def to_s
      "GROB:#{@width}:#{@height}:#{@bits.to_s( 16 )}"
    end

    def self.can_parse?( value )
      value.instance_of?( String ) && value.match?(/^GROB:\d+:\d+:[0-9a-f]+$/)
    end

    def ==( other )
      other.class == RplGrOb &&
        other.width == width &&
        other.height == height &&
        other.bits == bits
    end
  end
end
