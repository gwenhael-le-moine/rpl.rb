# frozen_string_literal: true

class RplName
  attr_accessor :value

  def initialize( value )
    raise RplTypeError unless self.class.can_parse?( value )

    # we systematicalyl trim enclosing '
    @value = value[1..-2]
  end

  def to_s
    "'#{@value}'"
  end

  def self.can_parse?( value )
    value.length > 2 && value[0] == "'" && value[-1] == "'"
  end
end
