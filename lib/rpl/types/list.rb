# frozen_string_literal: true

class RplList
  attr_accessor :value

  def initialize( value )
    raise RplTypeError unless self.class.can_parse?( value )

    # we systematicalyl trim enclosing { }
    @value = value[2..-3] # TODO: parse each element
  end

  def to_s
    "{ #{@value.map(&:to_s).join(' ')} }"
  end

  def self.can_parse?( value )
    value[0] == '{' && value[-1] == '}'
  end
end
