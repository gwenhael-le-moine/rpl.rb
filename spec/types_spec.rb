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
  end

  def test_string
  end

  def test_program
  end

  def test_list
  end

  def test_numeric
  end
end
