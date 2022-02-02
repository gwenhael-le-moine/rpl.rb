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
    lang.run '1 asin pi 2 / =='
    assert_equal [{ value: true, type: :boolean }],
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
    lang.run '0 acos pi 2 / =='
    assert_equal [{ value: true, type: :boolean }],
                 lang.stack
  end

  def test_tan
    lang = Rpl::Language.new
    lang.run '0 tan 0 =='
    assert_equal [{ value: true, type: :boolean }],
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
