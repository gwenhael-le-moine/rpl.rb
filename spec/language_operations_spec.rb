# coding: utf-8
# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TesttLanguageOperations < MiniTest::Test
  include Types

  def test_add
    interpreter = Rpl.new
    interpreter.run '1 2 +'
    assert_equal [RplNumeric.new( 3 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 "a" +'
    assert_equal [RplString.new( '"1a"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 \'a\' +'
    assert_equal [RplName.new( "'1a'" )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 dup dup →list +'
    assert_equal [RplList.new( [RplNumeric.new( 1 ),
                                RplNumeric.new( 1 )] )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" "b" +'
    assert_equal [RplString.new( '"ab"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" \'b\' +'
    assert_equal [RplString.new( '"ab"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" 1 +'
    assert_equal [RplString.new( '"a1"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" 1 dup →list +'
    assert_equal [RplList.new( [RplString.new( '"a"' ),
                                RplNumeric.new( 1 )] )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'a\' 1 +'
    assert_equal [RplName.new( 'a1' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'a\' "b" +'
    assert_equal [RplString.new( '"ab"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'a\' \'b\' +'
    assert_equal [RplName.new( "'ab'" )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'a\' 1 dup →list +'
    assert_equal [RplList.new( [RplName.new( 'a' ),
                                RplNumeric.new( 1 )] )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 a "test" 3 →list dup rev +'
    assert_equal [RplList.new( [RplNumeric.new( 1 ),
                                RplName.new( 'a' ),
                                RplString.new( '"test"' ),
                                RplString.new( '"test"' ),
                                RplName.new( 'a' ),
                                RplNumeric.new( 1 )] )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 a "test" 3 →list 9 +'
    assert_equal [RplList.new( [RplNumeric.new( 1 ),
                                RplName.new( 'a' ),
                                RplString.new( '"test"' ),
                                RplNumeric.new( 9 )] )],
                 interpreter.stack
  end

  def test_subtract
    interpreter = Rpl.new
    interpreter.run '1 2 -'
    assert_equal [RplNumeric.new( -1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '2 1 -'
    assert_equal [RplNumeric.new( 1 )],
                 interpreter.stack
  end

  def test_negate
    interpreter = Rpl.new
    interpreter.run '-1 chs'
    assert_equal [RplNumeric.new( 1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 chs'
    assert_equal [RplNumeric.new( -1 )],
                 interpreter.stack
  end

  def test_multiply
    interpreter = Rpl.new
    interpreter.run '3 4 *'
    assert_equal [RplNumeric.new( 12 )],
                 interpreter.stack
  end

  def test_divide
    interpreter = Rpl.new
    interpreter.run '3.0 4 /'
    assert_equal [RplNumeric.new( 0.75 )],
                 interpreter.stack
  end

  def test_inverse
    interpreter = Rpl.new
    interpreter.run '4 inv'
    assert_equal [RplNumeric.new( 0.25 )],
                 interpreter.stack
  end

  def test_power
    interpreter = Rpl.new
    interpreter.run '3 4 ^'
    assert_equal [RplNumeric.new( 81 )],
                 interpreter.stack
  end

  def test_sqrt
    interpreter = Rpl.new
    interpreter.run '16 √'
    assert_equal [RplNumeric.new( 4 )],
                 interpreter.stack
  end

  def test_sq
    interpreter = Rpl.new
    interpreter.run '4 sq'
    assert_equal [RplNumeric.new( 16 )],
                 interpreter.stack
  end

  def test_abs
    interpreter = Rpl.new
    interpreter.run '-1 abs'
    assert_equal [RplNumeric.new( 1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 abs'
    assert_equal [RplNumeric.new( 1 )],
                 interpreter.stack
  end

  def test_dec
    interpreter = Rpl.new
    interpreter.run '0x1 dec'
    assert_equal [RplNumeric.new( 1 )],
                 interpreter.stack
  end

  def test_hex
    interpreter = Rpl.new
    interpreter.run '1 hex'
    assert_equal [RplNumeric.new( 1, 16 )],
                 interpreter.stack
  end

  def test_bin
    interpreter = Rpl.new
    interpreter.run '1 bin'
    assert_equal [RplNumeric.new( 1, 2 )],
                 interpreter.stack
  end

  def test_base
    interpreter = Rpl.new
    interpreter.run '1 31 base'
    assert_equal [RplNumeric.new( 1, 31 )],
                 interpreter.stack
  end

  def test_sign
    interpreter = Rpl.new
    interpreter.run '-10 sign'
    assert_equal [RplNumeric.new( -1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '10 sign'
    assert_equal [RplNumeric.new( 1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '0 sign'
    assert_equal [RplNumeric.new( 0 )],
                 interpreter.stack
  end

  def test_percent
    interpreter = Rpl.new
    interpreter.run '2 33 %'
    assert_equal [RplNumeric.new( 0.66 )],
                 interpreter.stack
  end

  def test_inverse_percent
    interpreter = Rpl.new
    interpreter.run '2 0.66 %CH'
    assert_equal [RplNumeric.new( 33 )],
                 interpreter.stack
  end

  def test_mod
    interpreter = Rpl.new
    interpreter.run '9 4 mod'
    assert_equal [RplNumeric.new( 1 )],
                 interpreter.stack
  end

  def test_fact
    interpreter = Rpl.new
    interpreter.run '5 !'
    assert_equal [RplNumeric.new( 24 )],
                 interpreter.stack
  end

  def test_floor
    interpreter = Rpl.new
    interpreter.run '5.23 floor'
    assert_equal [RplNumeric.new( 5 )],
                 interpreter.stack
  end

  def test_ceil
    interpreter = Rpl.new
    interpreter.run '5.23 ceil'
    assert_equal [RplNumeric.new( 6 )],
                 interpreter.stack
  end

  def test_min
    interpreter = Rpl.new
    interpreter.run '1 2 min'
    assert_equal [RplNumeric.new( 1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '2 1 min'
    assert_equal [RplNumeric.new( 1 )],
                 interpreter.stack
  end

  def test_max
    interpreter = Rpl.new
    interpreter.run '1 2 max'
    assert_equal [RplNumeric.new( 2 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '2 1 max'
    assert_equal [RplNumeric.new( 2 )],
                 interpreter.stack
  end

  def test_ip
    interpreter = Rpl.new
    interpreter.run '3.14 ip'
    assert_equal [RplNumeric.new( 3 )],
                 interpreter.stack
  end

  def test_fp
    interpreter = Rpl.new
    interpreter.run '3.14 fp'
    assert_equal [RplNumeric.new( 0.14 )],
                 interpreter.stack
  end

  def test_mant
    interpreter = Rpl.new
    interpreter.run '123.456 mant -123.456 mant 0 mant'
    assert_equal [RplNumeric.new( 0.123456 ),
                  RplNumeric.new( 0.123456 ),
                  RplNumeric.new( 0 )],
                 interpreter.stack
  end

  def test_xpon
    interpreter = Rpl.new
    interpreter.run '123.456 xpon -123.456 xpon 0 xpon'
    assert_equal [RplNumeric.new( 3 ),
                  RplNumeric.new( 3 ),
                  RplNumeric.new( 0 )],
                 interpreter.stack
  end
end
