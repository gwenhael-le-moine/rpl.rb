# coding: utf-8
# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl/types'

class TestTypes < MiniTest::Test
  def test_boolean
    assert_equal true, RplBoolean.can_parse?( true )
    assert_equal true, RplBoolean.can_parse?( false )
    assert_equal true, RplBoolean.can_parse?( 'true' )
    assert_equal true, RplBoolean.can_parse?( 'false' )
    assert_equal true, RplBoolean.can_parse?( 'TRUE' )
    assert_equal true, RplBoolean.can_parse?( 'FALSE' )
    assert_equal false, RplBoolean.can_parse?( 'prout' )
    assert_equal false, RplBoolean.can_parse?( 1 )

    assert_equal RplBoolean, RplBoolean.new( true ).class
    assert_equal RplBoolean, RplBoolean.new( false ).class
    assert_equal RplBoolean, RplBoolean.new( 'true' ).class
    assert_equal RplBoolean, RplBoolean.new( 'false' ).class
    assert_equal RplBoolean, RplBoolean.new( 'TRUE' ).class
    assert_equal RplBoolean, RplBoolean.new( 'FALSE' ).class

    assert_equal true, RplBoolean.new( true ).value
    assert_equal false, RplBoolean.new( false ).value
    assert_equal true, RplBoolean.new( 'true' ).value
    assert_equal false, RplBoolean.new( 'false' ).value
    assert_equal true, RplBoolean.new( 'TRUE' ).value
    assert_equal false, RplBoolean.new( 'FALSE' ).value
  end

  def test_name
    assert_equal true, RplName.can_parse?( "'test'" )
    assert_equal true, RplName.can_parse?( "'test test'" ) # let's just allow spaces in names
    assert_equal false, RplName.can_parse?( "'test" )
    assert_equal false, RplName.can_parse?( "test'" )
    assert_equal false, RplName.can_parse?( "''" )

    assert_equal RplName, RplName.new( "'test'" ).class
    assert_equal RplName, RplName.new( "'test test'" ).class

    assert_equal 'test', RplName.new( "'test'" ).value
    assert_equal 'test test', RplName.new( "'test test'" ).value
  end

  def test_string
    assert_equal true, RplString.can_parse?( '"test"' )
    assert_equal true, RplString.can_parse?( '""' )
    assert_equal true, RplString.can_parse?( '"test test"' )
    assert_equal false, RplString.can_parse?( '"test' )
    assert_equal false, RplString.can_parse?( 'test"' )
    assert_equal false, RplString.can_parse?( '1' )

    assert_equal RplString, RplString.new( '"test"' ).class
    assert_equal RplString, RplString.new( '""' ).class
    assert_equal RplString, RplString.new( '"test test"' ).class

    assert_equal 'test', RplString.new( '"test"' ).value
    assert_equal '', RplString.new( '""' ).value
    assert_equal 'test test', RplString.new( '"test test"' ).value
  end

  def test_program
    assert_equal true, RplProgram.can_parse?( '« test »' )
    assert_equal true, RplProgram.can_parse?( '« test test »' )
    assert_equal false, RplProgram.can_parse?( '«    »' ) # an empty program is not allowed
    assert_equal false, RplProgram.can_parse?( '«   »' ) # an empty program is not allowed
    assert_equal false, RplProgram.can_parse?( '«  »' ) # an empty program is not allowed
    assert_equal false, RplProgram.can_parse?( '« »' ) # an empty program is not allowed
    assert_equal false, RplProgram.can_parse?( '«»' ) # an empty program is not allowed
    assert_equal false, RplProgram.can_parse?( '« test' )
    assert_equal false, RplProgram.can_parse?( 'test »' )
    assert_equal false, RplProgram.can_parse?( '1' )

    assert_equal RplProgram, RplProgram.new( '« test »' ).class
    assert_equal RplProgram, RplProgram.new( '« test test »' ).class

    assert_equal 'test', RplProgram.new( '« test »' ).value
    assert_equal 'test test', RplProgram.new( '« test test »' ).value
  end

  def test_list
  end

  def test_numeric
    assert_equal true, RplNumeric.can_parse?( BigDecimal( 1 ) )
    assert_equal true, RplNumeric.can_parse?( RplNumeric.new( 1 ) )
    assert_equal true, RplNumeric.can_parse?( '1' )
    assert_equal true, RplNumeric.can_parse?( '1.1' )
    assert_equal true, RplNumeric.can_parse?( '.1' )
    assert_equal true, RplNumeric.can_parse?( '∞' )
    assert_equal true, RplNumeric.can_parse?( '-∞' )
    assert_equal true, RplNumeric.can_parse?( '0' )
    assert_equal true, RplNumeric.can_parse?( '-3' )
    assert_equal true, RplNumeric.can_parse?( '-3.456' )
    assert_equal true, RplNumeric.can_parse?( '-.456' )
    assert_equal true, RplNumeric.can_parse?( '0b101' )
    assert_equal true, RplNumeric.can_parse?( '0xfed' )
    assert_equal true, RplNumeric.can_parse?( '0o57' )
    assert_equal true, RplNumeric.can_parse?( '013_ba7' )
    assert_equal false, RplNumeric.can_parse?( '0b' )
    assert_equal false, RplNumeric.can_parse?( '0x' )
    assert_equal false, RplNumeric.can_parse?( '0o' )
    assert_equal false, RplNumeric.can_parse?( '013_' )
    assert_equal false, RplNumeric.can_parse?( '037_ba7' )
    assert_equal false, RplNumeric.can_parse?( 'fed' )
    assert_equal false, RplNumeric.can_parse?( 'ba7' )
    assert_equal false, RplNumeric.can_parse?( '0aba7' )

    assert_equal RplNumeric, RplNumeric.new( BigDecimal( 1 ) ).class
    assert_equal RplNumeric, RplNumeric.new( RplNumeric.new( 1 ) ).class
    assert_equal RplNumeric, RplNumeric.new( '1' ).class
    assert_equal RplNumeric, RplNumeric.new( '1.1' ).class
    assert_equal RplNumeric, RplNumeric.new( '.1' ).class
    assert_equal RplNumeric, RplNumeric.new( '∞' ).class
    assert_equal RplNumeric, RplNumeric.new( '-∞' ).class
    assert_equal RplNumeric, RplNumeric.new( '0' ).class
    assert_equal RplNumeric, RplNumeric.new( '-3' ).class
    assert_equal RplNumeric, RplNumeric.new( '-3.456' ).class
    assert_equal RplNumeric, RplNumeric.new( '-.456' ).class
    assert_equal RplNumeric, RplNumeric.new( '0b101' ).class
    assert_equal RplNumeric, RplNumeric.new( '0xfed' ).class
    assert_equal RplNumeric, RplNumeric.new( '0o57' ).class
    assert_equal RplNumeric, RplNumeric.new( '013_ba7' ).class

    assert_equal BigDecimal(1), RplNumeric.new( '1' ).value
    assert_equal BigDecimal(1.1, 12), RplNumeric.new( '1.1' ).value
    assert_equal BigDecimal(0.1, 12), RplNumeric.new( '.1' ).value
    assert_equal BigDecimal('+Infinity'), RplNumeric.new( '∞' ).value
    assert_equal BigDecimal('-Infinity'), RplNumeric.new( '-∞' ).value
    assert_equal BigDecimal(0), RplNumeric.new( '0' ).value
    assert_equal BigDecimal(-3), RplNumeric.new( '-3' ).value
    assert_equal BigDecimal(-3.456, 12), RplNumeric.new( '-3.456' ).value
    assert_equal BigDecimal(-0.456, 12), RplNumeric.new( '-.456' ).value
    assert_equal BigDecimal(5), RplNumeric.new( '0b101' ).value
    assert_equal BigDecimal(4077), RplNumeric.new( '0xfed' ).value
    assert_equal BigDecimal(47), RplNumeric.new( '0o57' ).value
    assert_equal BigDecimal(1996), RplNumeric.new( '013_ba7' ).value

    assert_equal 10, RplNumeric.new( '-.456' ).base
    assert_equal 2, RplNumeric.new( '0b101' ).base
    assert_equal 16, RplNumeric.new( '0xfed' ).base
    assert_equal 8, RplNumeric.new( '0o57' ).base
    assert_equal 13, RplNumeric.new( '013_ba7' ).base
  end
end
