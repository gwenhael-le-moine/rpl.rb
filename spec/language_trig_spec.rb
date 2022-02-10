# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../rpl'

class TesttLanguageOperations < Test::Unit::TestCase
  def test_pi
    interpreter = Rpl.new
    interpreter.run 'pi'
    assert_equal [{ value: BigMath.PI( interpreter.precision ), type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_sin
    interpreter = Rpl.new
    interpreter.run '3 sin'
    assert_equal [{ value: BigMath.sin( BigDecimal( 3 ), interpreter.precision ), type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_asin
    interpreter = Rpl.new
    interpreter.run '1 asin pi 2 / =='
    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack
  end

  def test_cos
    interpreter = Rpl.new
    interpreter.run '3 cos'
    assert_equal [{ value: BigMath.cos( BigDecimal( 3 ), interpreter.precision ), type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_acos
    interpreter = Rpl.new
    interpreter.run '0 acos pi 2 / =='
    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack
  end

  def test_tan
    interpreter = Rpl.new
    interpreter.run '0 tan 0 =='
    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack
  end

  def test_atan
    interpreter = Rpl.new
    interpreter.run '1 atan'
    assert_equal [{ value: BigMath.atan( BigDecimal( 1 ), interpreter.precision ), type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_d→r
    interpreter = Rpl.new
    interpreter.run '90 d→r'
    assert_equal [{ value: BigMath.PI( interpreter.precision ) / 2,
                    type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_r→d
    interpreter = Rpl.new
    interpreter.run 'pi r→d'
    assert_equal [{ value: 180, type: :numeric, base: 10 }],
                 interpreter.stack
  end
end
