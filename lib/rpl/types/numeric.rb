# frozen_string_literal: true

require 'bigdecimal'

module Types
  class RplNumeric
    attr_accessor :value,
                  :base

    @@precision = 12 # rubocop:disable Style/ClassVars

    def self.default_precision
      @@precision = 12 # rubocop:disable Style/ClassVars
    end

    def self.precision
      @@precision
    end

    def self.precision=( precision )
      @@precision = precision.to_i # rubocop:disable Style/ClassVars
    end

    def initialize( value, base = 10 )
      raise RplTypeError unless self.class.can_parse?( value )

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
        begin
          @value = BigDecimal( value )
        rescue ArgumentError
          case value
          when /^0x[0-9a-f]+$/
            @base = 16
            @value = /^0x(?<value>[0-9a-f]+)$/.match( value )['value'].to_i( @base )
          when /^0o[0-7]+$/
            @base = 8
            @value = /^0o(?<value>[0-7]+)$/.match( value )['value'].to_i( @base )
          when /^0b[0-1]+$/
            @base = 2
            @value = /^0b(?<value>[0-1]+)$/.match( value )['value'].to_i( @base )
          when '∞'
            @value = BigDecimal('+Infinity')
          when '-∞'
            @value = BigDecimal('-Infinity')
          else
            matches = /(?<base>[0-9]+)b(?<value>[0-9a-z]+)/.match( value )
            @base = matches['base'].to_i
            @value = matches['value'].to_i( @base )
          end
        end
      end
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
                                      ( value.match?(/^[0-9]+b[0-9a-z]+$/) and
                                        value.split('_').first.to_i <= 36 ) ) )
    end

    def ==( other )
      other.class == RplNumeric and
        other.base == base and
        other.value == value
    end
  end
end
