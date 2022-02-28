# coding: utf-8
# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TesttLanguageOperations < MiniTest::Test
  include Types

  def test_add
    interpreter = Rpl.new
    interpreter.run '1 2 +'
    assert_equal [Types.new_object( RplNumeric, 3 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 "a" +'
    assert_equal [Types.new_object( RplString, '"1a"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 \'a\' +'
    assert_equal [Types.new_object( RplName, "'1a'" )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 dup dup →list +'
    assert_equal [Types.new_object( RplList, [Types.new_object( RplNumeric, 1 ),
                                Types.new_object( RplNumeric, 1 )] )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" "b" +'
    assert_equal [Types.new_object( RplString, '"ab"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" \'b\' +'
    assert_equal [Types.new_object( RplString, '"ab"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" 1 +'
    assert_equal [Types.new_object( RplString, '"a1"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" 1 dup →list +'
    assert_equal [Types.new_object( RplList, [Types.new_object( RplString, '"a"' ),
                                Types.new_object( RplNumeric, 1 )] )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'a\' 1 +'
    assert_equal [Types.new_object( RplName, 'a1' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'a\' "b" +'
    assert_equal [Types.new_object( RplString, '"ab"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'a\' \'b\' +'
    assert_equal [Types.new_object( RplName, "'ab'" )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'a\' 1 dup →list +'
    assert_equal [Types.new_object( RplList, [Types.new_object( RplName, 'a' ),
                                Types.new_object( RplNumeric, 1 )] )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 a "test" 3 →list dup rev +'
    assert_equal [Types.new_object( RplList, [Types.new_object( RplNumeric, 1 ),
                                Types.new_object( RplName, 'a' ),
                                Types.new_object( RplString, '"test"' ),
                                Types.new_object( RplString, '"test"' ),
                                Types.new_object( RplName, 'a' ),
                                Types.new_object( RplNumeric, 1 )] )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 a "test" 3 →list 9 +'
    assert_equal [Types.new_object( RplList, [Types.new_object( RplNumeric, 1 ),
                                Types.new_object( RplName, 'a' ),
                                Types.new_object( RplString, '"test"' ),
                                Types.new_object( RplNumeric, 9 )] )],
                 interpreter.stack
  end

  def test_subtract
    interpreter = Rpl.new
    interpreter.run '1 2 -'
    assert_equal [Types.new_object( RplNumeric, -1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '2 1 -'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack
  end

  def test_negate
    interpreter = Rpl.new
    interpreter.run '-1 chs'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 chs'
    assert_equal [Types.new_object( RplNumeric, -1 )],
                 interpreter.stack
  end

  def test_multiply
    interpreter = Rpl.new
    interpreter.run '3 4 *'
    assert_equal [Types.new_object( RplNumeric, 12 )],
                 interpreter.stack
  end

  def test_divide
    interpreter = Rpl.new
    interpreter.run '3.0 4 /'
    assert_equal [Types.new_object( RplNumeric, 0.75 )],
                 interpreter.stack
  end

  def test_inverse
    interpreter = Rpl.new
    interpreter.run '4 inv'
    assert_equal [Types.new_object( RplNumeric, 0.25 )],
                 interpreter.stack
  end

  def test_power
    interpreter = Rpl.new
    interpreter.run '3 4 ^'
    assert_equal [Types.new_object( RplNumeric, 81 )],
                 interpreter.stack
  end

  def test_sqrt
    interpreter = Rpl.new
    interpreter.run '16 √'
    assert_equal [Types.new_object( RplNumeric, 4 )],
                 interpreter.stack
  end

  def test_sq
    interpreter = Rpl.new
    interpreter.run '4 sq'
    assert_equal [Types.new_object( RplNumeric, 16 )],
                 interpreter.stack
  end

  def test_abs
    interpreter = Rpl.new
    interpreter.run '-1 abs'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 abs'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack
  end

  def test_dec
    interpreter = Rpl.new
    interpreter.run '0x1 dec'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack
  end

  def test_hex
    interpreter = Rpl.new
    interpreter.run '1 hex'
    expected_value = Types.new_object( RplNumeric, 1 )
    expected_value.base = 16
    assert_equal [expected_value],
                 interpreter.stack
  end

  def test_bin
    interpreter = Rpl.new
    interpreter.run '1 bin'
    expected_value = Types.new_object( RplNumeric, 1 )
    expected_value.base = 2
    assert_equal [expected_value],
                 interpreter.stack
  end

  def test_base
    interpreter = Rpl.new
    interpreter.run '1 31 base'
    expected_value = Types.new_object( RplNumeric, 1 )
    expected_value.base = 31
    assert_equal [expected_value],
                 interpreter.stack
  end

  def test_sign
    interpreter = Rpl.new
    interpreter.run '-10 sign'
    assert_equal [Types.new_object( RplNumeric, -1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '10 sign'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '0 sign'
    assert_equal [Types.new_object( RplNumeric, 0 )],
                 interpreter.stack
  end

  def test_percent
    interpreter = Rpl.new
    interpreter.run '2 33 %'
    assert_equal [Types.new_object( RplNumeric, 0.66 )],
                 interpreter.stack
  end

  def test_inverse_percent
    interpreter = Rpl.new
    interpreter.run '2 0.66 %CH'
    assert_equal [Types.new_object( RplNumeric, 33 )],
                 interpreter.stack
  end

  def test_mod
    interpreter = Rpl.new
    interpreter.run '9 4 mod'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack
  end

  def test_fact
    interpreter = Rpl.new
    interpreter.run '5 !'
    assert_equal [Types.new_object( RplNumeric, 24 )],
                 interpreter.stack
  end

  def test_floor
    interpreter = Rpl.new
    interpreter.run '5.23 floor'
    assert_equal [Types.new_object( RplNumeric, 5 )],
                 interpreter.stack
  end

  def test_ceil
    interpreter = Rpl.new
    interpreter.run '5.23 ceil'
    assert_equal [Types.new_object( RplNumeric, 6 )],
                 interpreter.stack
  end

  def test_min
    interpreter = Rpl.new
    interpreter.run '1 2 min'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '2 1 min'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack
  end

  def test_max
    interpreter = Rpl.new
    interpreter.run '1 2 max'
    assert_equal [Types.new_object( RplNumeric, 2 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '2 1 max'
    assert_equal [Types.new_object( RplNumeric, 2 )],
                 interpreter.stack
  end

  def test_ip
    interpreter = Rpl.new
    interpreter.run '3.14 ip'
    assert_equal [Types.new_object( RplNumeric, 3 )],
                 interpreter.stack
  end

  def test_fp
    interpreter = Rpl.new
    interpreter.run '3.14 fp'
    assert_equal [Types.new_object( RplNumeric, 0.14 )],
                 interpreter.stack
  end

  def test_mant
    interpreter = Rpl.new
    interpreter.run '123.456 mant -123.456 mant 0 mant'
    assert_equal [Types.new_object( RplNumeric, 0.123456 ),
                  Types.new_object( RplNumeric, 0.123456 ),
                  Types.new_object( RplNumeric, 0 )],
                 interpreter.stack
  end

  def test_xpon
    interpreter = Rpl.new
    interpreter.run '123.456 xpon -123.456 xpon 0 xpon'
    assert_equal [Types.new_object( RplNumeric, 3 ),
                  Types.new_object( RplNumeric, 3 ),
                  Types.new_object( RplNumeric, 0 )],
                 interpreter.stack
  end
end
