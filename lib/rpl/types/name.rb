# frozen_string_literal: true

module Types
  class RplName
    attr_accessor :value,
                  :not_to_evaluate

    def initialize( value )
      raise RplTypeError unless self.class.can_parse?( value )

      # we systematicalyl trim enclosing '
      @not_to_evaluate = value[0] == "'"
      @value = if value[0] == "'" && value[-1] == "'"
                 value[1..-2]
               else
                 value
               end
    end

    def to_s
      "'#{@value}'"
    end

    def self.can_parse?( value )
      ( value.length > 2 && value[0] == "'" && value[-1] == "'" ) ||
        ( value != "''" && !value.match?(/^[0-9']+$/) &&
          # it's not any other type
          [RplBoolean, RplList, RplProgram, RplString, RplNumeric].reduce( true ) { |memo, type_class| memo && !type_class.can_parse?( value ) } )
    end

    def ==( other )
      other.class == RplName &&
        other.value == value
    end
  end
end
