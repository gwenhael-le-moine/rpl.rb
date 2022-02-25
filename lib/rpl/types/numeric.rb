# frozen_string_literal: true

require 'bigdecimal'

module Types
  class RplNumeric
    attr_accessor :value,
                  :base

    def initialize( value, base = 10 )
      raise RplTypeError unless self.class.can_parse?( value )

      @@precision = 12 # rubocop:disable Style/ClassVars

      @base = base

      case value
      when RplNumeric
        @value = value.value
        @base = value.base
      when BigDecimal
        @value = value
      when Integer
        @value = BigDecimal( value, @@precision )
      when Float
        @value = BigDecimal( value, @@precision )
      when String
        case value
        when '∞'
          @value = BigDecimal('+Infinity')
        when '-∞'
          @value = BigDecimal('-Infinity')
        else
          underscore_position = value.index('_')

          if value[0] == '0' && ( %w[b o x].include?( value[1] ) || !underscore_position.nil? )
            if value[1] == 'x'
              @base = 16
            elsif value[1] == 'b'
              @base = 2
            elsif value[1] == 'o'
              @base = 8
              value = value[2..-1]
            elsif !underscore_position.nil?
              @base = value[1..(underscore_position - 1)].to_i
              value = value[(underscore_position + 1)..-1]
            end
          end

          value = value.to_i( @base ) unless @base == 10
          @value = BigDecimal( value, @@precision )
        end
      end
    end

    def self.precision=( precision )
      raise RplTypeError unless precision.is_a? RplNumeric

      @@precision = precision.value.to_i # rubocop:disable Style/ClassVars
    end

    def to_s
      prefix = case @base
               when 2
                 '0b'
               when 8
                 '0o'
               when 10
                 ''
               when 16
                 '0x'
               else
                 "0#{@base}_"
               end

      if @value.infinite?
        suffix = @value.infinite?.positive? ? '∞' : '-∞'
      elsif @value.nan?
        suffix = '<NaN>'
      else
        suffix = if @value.to_i == @value
                   @value.to_i
                 else
                   @value.to_s('F')
                 end
        suffix = @value.to_s( @base ) unless @base == 10
      end

      "#{prefix}#{suffix}"
    end

    def self.can_parse?( value )
      [RplNumeric, BigDecimal, Integer, Float].include?( value.class ) or
        ( value.is_a?( String ) and ( value.match?(/^-?[0-9]*\.?[0-9]+$/) or
                                      value.match?(/^-?∞$/) or
                                      value.match?(/^0b[0-1]+$/) or
                                      value.match?(/^0o[0-7]+$/) or
                                      value.match?(/^0x[0-9a-f]+$/) or
                                      ( value.match?(/^0[0-9]+_[0-9a-z]+$/) and
                                        value.split('_').first.to_i <= 36 ) ) )
    end

    def ==( other )
      other.class == RplNumeric and
        other.base == base and
        other.value == value
    end

    def self.infer_resulting_base( numerics )
      10 if numerics.length.zero?

      numerics.last.base
    end
  end
end
