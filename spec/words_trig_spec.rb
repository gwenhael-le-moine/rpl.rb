# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'
require 'rpl/types'

class TesttLanguageOperations < MiniTest::Test
  include Types

  def test_pi
    interpreter = Rpl.new
    interpreter.run! 'pi'
    assert_equal [Types.new_object( RplNumeric, BigMath.PI( RplNumeric.precision ) )],
                 interpreter.stack
  end

  def test_sin
    interpreter = Rpl.new
    interpreter.run! '3 sin'
    assert_equal [Types.new_object( RplNumeric, BigMath.sin( BigDecimal( 3 ), RplNumeric.precision ) )],
                 interpreter.stack
  end

  def test_asin
    interpreter = Rpl.new
    interpreter.run! '1 asin pi 2 / =='
    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack
  end

  def test_cos
    interpreter = Rpl.new
    interpreter.run! '3 cos'
    assert_equal [Types.new_object( RplNumeric, BigMath.cos( BigDecimal( 3 ), RplNumeric.precision ) )],
                 interpreter.stack
  end

  def test_acos
    interpreter = Rpl.new
    interpreter.run! '0 acos pi 2 / =='
    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack
  end

  def test_tan
    interpreter = Rpl.new
    interpreter.run! '0 tan 0 =='
    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack
  end

  def test_atan
    interpreter = Rpl.new
    interpreter.run! '1 atan'
    assert_equal [Types.new_object( RplNumeric, BigMath.atan( BigDecimal( 1 ), RplNumeric.precision ) )],
                 interpreter.stack
  end

  def test_d2r
    interpreter = Rpl.new
    interpreter.run! '90 d→r'
    assert_equal [Types.new_object( RplNumeric, BigMath.PI( RplNumeric.precision ) / 2 )],
                 interpreter.stack
  end

  def test_r2d
    interpreter = Rpl.new
    interpreter.run! 'pi r→d'
    assert_equal [Types.new_object( RplNumeric, 180 )],
                 interpreter.stack
  end
end
