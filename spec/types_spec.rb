# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl/types'

class TestTypes < Minitest::Test
  include Types

  def test_boolean
    assert_equal true, RplBoolean.can_parse?( true )
    assert_equal true, RplBoolean.can_parse?( false )
    assert_equal true, RplBoolean.can_parse?( 'true' )
    assert_equal true, RplBoolean.can_parse?( 'false' )
    assert_equal true, RplBoolean.can_parse?( 'TRUE' )
    assert_equal true, RplBoolean.can_parse?( 'FALSE' )
    assert_equal false, RplBoolean.can_parse?( 'prout' )
    assert_equal false, RplBoolean.can_parse?( 1 )

    assert_equal RplBoolean, Types.new_object( RplBoolean, true ).class
    assert_equal RplBoolean, Types.new_object( RplBoolean, false ).class
    assert_equal RplBoolean, Types.new_object( RplBoolean, 'true' ).class
    assert_equal RplBoolean, Types.new_object( RplBoolean, 'false' ).class
    assert_equal RplBoolean, Types.new_object( RplBoolean, 'TRUE' ).class
    assert_equal RplBoolean, Types.new_object( RplBoolean, 'FALSE' ).class

    assert_equal true, Types.new_object( RplBoolean, true ).value
    assert_equal false, Types.new_object( RplBoolean, false ).value
    assert_equal true, Types.new_object( RplBoolean, 'true' ).value
    assert_equal false, Types.new_object( RplBoolean, 'false' ).value
    assert_equal true, Types.new_object( RplBoolean, 'TRUE' ).value
    assert_equal false, Types.new_object( RplBoolean, 'FALSE' ).value
  end

  def test_name
    assert_equal true, RplName.can_parse?( "'test'" )
    assert_equal true, RplName.can_parse?( "'test test'" ) # let's just allow spaces in names
    assert_equal true, RplName.can_parse?( 'test' )
    assert_equal true, RplName.can_parse?( 'test test' ) # let's just allow spaces in names
    assert_equal true, RplName.can_parse?( "'test" )
    assert_equal true, RplName.can_parse?( "test'" )
    assert_equal false, RplName.can_parse?( "''" )
    assert_equal false, RplName.can_parse?( "'1" )
    assert_equal false, RplName.can_parse?( "1'" )
    assert_equal false, RplName.can_parse?( '1' )

    assert_equal RplName, Types.new_object( RplName, "'test'" ).class
    assert_equal RplName, Types.new_object( RplName, "'test test'" ).class

    assert_equal 'test', Types.new_object( RplName, "'test'" ).value
    assert_equal 'test test', Types.new_object( RplName, "'test test'" ).value
  end

  def test_string
    assert_equal true, RplString.can_parse?( '"test"' )
    assert_equal true, RplString.can_parse?( '""' )
    assert_equal true, RplString.can_parse?( '"test test"' )
    assert_equal false, RplString.can_parse?( '"test' )
    assert_equal false, RplString.can_parse?( 'test"' )
    assert_equal false, RplString.can_parse?( '1' )

    assert_equal RplString, Types.new_object( RplString, '"test"' ).class
    assert_equal RplString, Types.new_object( RplString, '""' ).class
    assert_equal RplString, Types.new_object( RplString, '"test test"' ).class

    assert_equal 'test', Types.new_object( RplString, '"test"' ).value
    assert_equal '', Types.new_object( RplString, '""' ).value
    assert_equal 'test test', Types.new_object( RplString, '"test test"' ).value
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

    assert_equal RplProgram, Types.new_object( RplProgram, '« test »' ).class
    assert_equal RplProgram, Types.new_object( RplProgram, '« test test »' ).class

    assert_equal 'test', Types.new_object( RplProgram, '« test »' ).value
    assert_equal 'test test', Types.new_object( RplProgram, '« test test »' ).value
  end

  def test_numeric
    assert_equal true, RplNumeric.can_parse?( BigDecimal( 1 ) )
    assert_equal true, RplNumeric.can_parse?( Types.new_object( RplNumeric, 1 ) )
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
    assert_equal true, RplNumeric.can_parse?( '13bba7' )
    assert_equal false, RplNumeric.can_parse?( '0b' )
    assert_equal false, RplNumeric.can_parse?( '0x' )
    assert_equal false, RplNumeric.can_parse?( '0o' )
    assert_equal false, RplNumeric.can_parse?( '13b' )
    assert_equal false, RplNumeric.can_parse?( '37bba7' )
    assert_equal false, RplNumeric.can_parse?( 'fed' )
    assert_equal false, RplNumeric.can_parse?( 'ba7' )
    assert_equal false, RplNumeric.can_parse?( '0aba7' )

    assert_equal RplNumeric, Types.new_object( RplNumeric, 1 ).class
    assert_equal RplNumeric, Types.new_object( RplNumeric, 1.2 ).class
    assert_equal RplNumeric, Types.new_object( RplNumeric, BigDecimal( 1 ) ).class
    assert_equal RplNumeric, Types.new_object( RplNumeric, Types.new_object( RplNumeric, 1 ) ).class
    assert_equal RplNumeric, Types.new_object( RplNumeric, '1' ).class
    assert_equal RplNumeric, Types.new_object( RplNumeric, '1.1' ).class
    assert_equal RplNumeric, Types.new_object( RplNumeric, '.1' ).class
    assert_equal RplNumeric, Types.new_object( RplNumeric, '∞' ).class
    assert_equal RplNumeric, Types.new_object( RplNumeric, '-∞' ).class
    assert_equal RplNumeric, Types.new_object( RplNumeric, '0' ).class
    assert_equal RplNumeric, Types.new_object( RplNumeric, '-3' ).class
    assert_equal RplNumeric, Types.new_object( RplNumeric, '-3.456' ).class
    assert_equal RplNumeric, Types.new_object( RplNumeric, '-.456' ).class
    assert_equal RplNumeric, Types.new_object( RplNumeric, '0b101' ).class
    assert_equal RplNumeric, Types.new_object( RplNumeric, '0xfed' ).class
    assert_equal RplNumeric, Types.new_object( RplNumeric, '0o57' ).class
    assert_equal RplNumeric, Types.new_object( RplNumeric, '13bba7' ).class

    assert_equal BigDecimal(1), Types.new_object( RplNumeric, 1 ).value
    assert_equal BigDecimal(1.2, 12), Types.new_object( RplNumeric, 1.2 ).value
    assert_equal BigDecimal(1), Types.new_object( RplNumeric, '1' ).value
    assert_equal BigDecimal(1.1, 12), Types.new_object( RplNumeric, '1.1' ).value
    assert_equal BigDecimal(0.1, 12), Types.new_object( RplNumeric, '.1' ).value
    assert_equal BigDecimal('+Infinity'), Types.new_object( RplNumeric, '∞' ).value
    assert_equal BigDecimal('-Infinity'), Types.new_object( RplNumeric, '-∞' ).value
    assert_equal BigDecimal(0), Types.new_object( RplNumeric, '0' ).value
    assert_equal BigDecimal(-3), Types.new_object( RplNumeric, '-3' ).value
    assert_equal BigDecimal(-3.456, 12), Types.new_object( RplNumeric, '-3.456' ).value
    assert_equal BigDecimal(-0.456, 12), Types.new_object( RplNumeric, '-.456' ).value
    assert_equal BigDecimal(5), Types.new_object( RplNumeric, '0b101' ).value
    assert_equal BigDecimal(4077), Types.new_object( RplNumeric, '0xfed' ).value
    assert_equal BigDecimal(47), Types.new_object( RplNumeric, '0o57' ).value
    assert_equal BigDecimal(1996), Types.new_object( RplNumeric, '13bba7' ).value

    assert_equal 10, Types.new_object( RplNumeric, '-.456' ).base
    assert_equal 2, Types.new_object( RplNumeric, '0b101' ).base
    assert_equal 16, Types.new_object( RplNumeric, '0xfed' ).base
    assert_equal 8, Types.new_object( RplNumeric, '0o57' ).base
    assert_equal 13, Types.new_object( RplNumeric, '13bba7' ).base

    assert_equal '1', Types.new_object( RplNumeric, '1' ).to_s
    assert_equal '1.1', Types.new_object( RplNumeric, '1.1' ).to_s
    assert_equal '0.1', Types.new_object( RplNumeric, '.1' ).to_s
    assert_equal '∞', Types.new_object( RplNumeric, '∞' ).to_s
    assert_equal '-∞', Types.new_object( RplNumeric, '-∞' ).to_s
    assert_equal '0', Types.new_object( RplNumeric, '0' ).to_s
    assert_equal '-3', Types.new_object( RplNumeric, '-3' ).to_s
    assert_equal '-3.456', Types.new_object( RplNumeric, '-3.456' ).to_s
    assert_equal '-0.456', Types.new_object( RplNumeric, '-.456' ).to_s
    assert_equal '0b101', Types.new_object( RplNumeric, '0b101' ).to_s
    assert_equal '0xfed', Types.new_object( RplNumeric, '0xfed' ).to_s
    assert_equal '0o57', Types.new_object( RplNumeric, '0o57' ).to_s
    assert_equal '13bba7', Types.new_object( RplNumeric, '13bba7' ).to_s
  end

  def test_list
    assert_equal true, RplList.can_parse?( '{ 1 2 3 }' )
    assert_equal false, RplList.can_parse?( '{ 1 2 3' )
    assert_equal false, RplList.can_parse?( '1' )

    assert_equal RplList, Types.new_object( RplList, '{ 1 2 3 }' ).class

    assert_equal [Types.new_object( RplNumeric, 1 ),
                  Types.new_object( RplNumeric, 2 ),
                  Types.new_object( RplNumeric, 3 )],
                 Types.new_object( RplList, '{ 1 2 3 }' ).value
  end
end
