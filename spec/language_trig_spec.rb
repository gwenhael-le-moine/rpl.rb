# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TesttLanguageOperations < Test::Unit::TestCase
  def test_pi
    lang = Rpl::Language.new
    lang.run 'pi'
    assert_equal [{ value: BigMath.PI( Rpl::Lang::Core.precision ), type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_sin
    lang = Rpl::Language.new
    lang.run '3 sin'
    assert_equal [{ value: BigMath.sin( BigDecimal( 3 ), Rpl::Lang::Core.precision ), type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_asin
    lang = Rpl::Language.new
    lang.run '0.14112000806 asin'
    assert_equal [{ value: Math.asin( 0.14112000806 ), type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_cos
    lang = Rpl::Language.new
    lang.run '3 cos'
    assert_equal [{ value: BigMath.cos( BigDecimal( 3 ), Rpl::Lang::Core.precision ), type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_acos
    lang = Rpl::Language.new
    lang.run '0.5 acos'
    assert_equal [{ value: Math.acos( 0.5 ), type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_tan
    lang = Rpl::Language.new
    lang.run '1 tan'
    assert_equal [{ value: Math.tan( 1 ), type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_atan
    lang = Rpl::Language.new
    lang.run '1 atan'
    assert_equal [{ value: BigMath.atan( BigDecimal( 1 ), Rpl::Lang::Core.precision ), type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_d→r
    lang = Rpl::Language.new
    lang.run '30 d→r'
    assert_equal [{ value: 0.5235987756, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_r→d
    lang = Rpl::Language.new
    lang.run '2.6179938780 r→d'
    assert_equal [{ value: 150, type: :numeric, base: 10 }],
                 lang.stack
  end
end
