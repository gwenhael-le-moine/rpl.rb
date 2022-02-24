# frozen_string_literal: true

# :boolean
class RplBoolean
  attr_accessor :value

  def initialize( value )
    raise RplTypeError unless self.class.can_parse?( value )

    @value = if value.is_a?( String )
               value.downcase == 'true'
             else
               value
             end
  end

  def to_s
    @value.to_s
  end

  def self.can_parse?( value )
    return %w[true false].include?( value.downcase ) if value.is_a?( String )

    %w[TrueClass FalseClass].include?( value.class.to_s )
  end
end

# :list
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

# :name
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
    value[0] == "'" && value[-1] == "'"
  end
end

# :numeric
class RplNumeric
  attr_accessor :value

  def initialize( value, base = 10 )
    raise RplTypeError unless self.class.can_parse?( value )

    @base = base
    @value = value

    underscore_position = @value.index('_')

    if @value[0] == '0' && ( %w[b o x].include?( @value[1] ) || !underscore_position.nil? )
      if @value[1] == 'x'
        @base = 16
      elsif @value[1] == 'b'
        @base = 2
      elsif @value[1] == 'o'
        @base = 8
        @value = @value[2..-1]
      elsif !underscore_position.nil?
        @base = @value[1..(underscore_position - 1)].to_i
        @value = @value[(underscore_position + 1)..-1]
      end
    end

    @value = @value.to_i( @base ) unless @base == 10
    @value = BigDecimal( @value, @precision ) # FIXME: how to get @precision?
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
    # FIXME
    !Float( value ).nil?
  rescue ArgumentError
    begin
      !Integer( value ).nil?
    rescue ArgumentError
      false
    end
  end

  def self.infer_resulting_base( numerics )
    10 if numerics.length.zero?

    numerics.last.base
  end
end

# :string
class RplString
  attr_accessor :value

  def initialize( value )
    raise RplTypeError unless self.class.can_parse?( value )

    # we systematicalyl trim enclosing "
    @value = value[1..-2]
  end

  def to_s
    "\"#{@value}\""
  end

  def self.can_parse?( value )
    value[0] == '"' && value[-1] == '"'
  end
end

# :program
class RplProgram
  attr_accessor :value

  def initialize( value )
    raise RplTypeError unless self.class.can_parse?( value )

    # we systematicalyl trim enclosing « »
    @value = value[2..-3]
  end

  def to_s
    "« #{@value} »"
  end

  def self.can_parse?( value )
    value[0] == '«' && value[-1] == '»'
  end
end
