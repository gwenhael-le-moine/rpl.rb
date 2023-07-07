# frozen_string_literal: true

require 'rpl/parser'

class BitArray
  def initialize
    @mask = 0
  end

  def []=(position, value)
    if value.zero?
      @mask ^= (1 << position)
    else
      @mask |= (1 << position)
    end
  end

  def [](position)
    @mask[position]
  end

  def to_i
    @mask.to_i
  end

  def from_i( value )
    @mask = value.to_i
  end
end

module Types
  class RplGrOb
    attr_accessor :width,
                  :height,
                  :bits

    def initialize( init )
      raise RplTypeError unless self.class.can_parse?( init )

      parsed = if init.instance_of?( RplGrOb )
                 init.value
               else
                 /^GROB:(?<width>\d+):(?<height>\d+):(?<bits>[0-9a-f]+)$/.match( init )
               end

      @width = parsed[:width].to_i
      @height = parsed[:height].to_i
      @bits = BitArray.new
      @bits.from_i( parsed[:bits].to_i( 16 ) )
    end

    def value
      { width: @width,
        height: @height,
        bits: @bits.to_i.to_s( 16 ) }
    end

    def to_s
      "GROB:#{@width}:#{@height}:#{@bits.to_i.to_s( 16 )}"
    end

    def self.can_parse?( value )
      value.instance_of?( RplGrOb ) ||
        ( value.instance_of?( String ) && value.match?(/^GROB:\d+:\d+:[0-9a-f]+$/) )
    end

    def ==( other )
      other.class == RplGrOb &&
        other.width == @width &&
        other.height == @height &&
        other.bits.to_i == @bits.to_i
    end

    def to_text
      @bits.to_i
           .to_s(2)
           .ljust(@width * @height, '0')
           .slice(0, @width * @height)
           .scan(/.{1,#{@width}}/)
           .join("\n")
           .gsub( '0', '_' )
           .gsub( '1', '.' )
    end

    def set_pixel( pos_x, pos_y, value )
      @bits[ ( pos_y * @height ) + pos_x ] = value
    end
  end
end
