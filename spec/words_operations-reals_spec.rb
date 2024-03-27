# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TesttLanguageOperationsReals < Minitest::Test
  include Types

  def test_percent
    interpreter = Rpl.new
    interpreter.run! '2 33 %'
    assert_equal [Types.new_object( RplNumeric, 0.66 )],
                 interpreter.stack
  end

  def test_inverse_percent
    interpreter = Rpl.new
    interpreter.run! '2 0.66 %CH'
    assert_equal [Types.new_object( RplNumeric, 33 )],
                 interpreter.stack
  end

  def test_mod
    interpreter = Rpl.new
    interpreter.run! '9 4 mod'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack
  end

  def test_fact
    interpreter = Rpl.new
    interpreter.run! '5 !'
    assert_equal [Types.new_object( RplNumeric, 24 )],
                 interpreter.stack
  end

  def test_floor
    interpreter = Rpl.new
    interpreter.run! '5.23 floor'
    assert_equal [Types.new_object( RplNumeric, 5 )],
                 interpreter.stack
  end

  def test_ceil
    interpreter = Rpl.new
    interpreter.run! '5.23 ceil'
    assert_equal [Types.new_object( RplNumeric, 6 )],
                 interpreter.stack
  end

  def test_min
    interpreter = Rpl.new
    interpreter.run! '1 2 min'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run! '2 1 min'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack
  end

  def test_max
    interpreter = Rpl.new
    interpreter.run! '1 2 max'
    assert_equal [Types.new_object( RplNumeric, 2 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run! '2 1 max'
    assert_equal [Types.new_object( RplNumeric, 2 )],
                 interpreter.stack
  end

  def test_ip
    interpreter = Rpl.new
    interpreter.run! '3.14 ip'
    assert_equal [Types.new_object( RplNumeric, 3 )],
                 interpreter.stack
  end

  def test_fp
    interpreter = Rpl.new
    interpreter.run! '3.14 fp'
    assert_equal [Types.new_object( RplNumeric, 0.14 )],
                 interpreter.stack
  end

  def test_mant
    interpreter = Rpl.new
    interpreter.run! '123.456 mant -123.456 mant 0 mant'
    assert_equal [Types.new_object( RplNumeric, 0.123456 ),
                  Types.new_object( RplNumeric, 0.123456 ),
                  Types.new_object( RplNumeric, 0 )],
                 interpreter.stack
  end

  def test_xpon
    interpreter = Rpl.new
    interpreter.run! '123.456 xpon -123.456 xpon 0 xpon'
    assert_equal [Types.new_object( RplNumeric, 3 ),
                  Types.new_object( RplNumeric, 3 ),
                  Types.new_object( RplNumeric, 0 )],
                 interpreter.stack
  end
end
