# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TestLanguageStack < Test::Unit::TestCase
  def test_swap
    stack, _dictionary = Rpl::Lang::Core.swap [{ value: 1, type: :numeric, base: 10 },
                                               { value: 2, type: :numeric, base: 10 }],
                                              Rpl::Lang::Dictionary.new
    assert_equal [{ value: 2, type: :numeric, base: 10 },
                  { value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_drop
    stack, _dictionary = Rpl::Lang::Core.drop [{ value: 1, type: :numeric, base: 10 },
                                               { value: 2, type: :numeric, base: 10 }],
                                              Rpl::Lang::Dictionary.new
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_drop2
    stack, _dictionary = Rpl::Lang::Core.drop2 [{ value: 1, type: :numeric, base: 10 },
                                                { value: 2, type: :numeric, base: 10 }],
                                               Rpl::Lang::Dictionary.new
    assert_equal [],
                 stack
  end

  def test_dropn
    stack, _dictionary = Rpl::Lang::Core.dropn [{ value: 1, type: :numeric, base: 10 },
                                                { value: 2, type: :numeric, base: 10 },
                                                { value: 3, type: :numeric, base: 10 },
                                                { value: 4, type: :numeric, base: 10 },
                                                { value: 3, type: :numeric, base: 10 }],
                                               Rpl::Lang::Dictionary.new
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_del
    stack, _dictionary = Rpl::Lang::Core.del [{ value: 1, type: :numeric, base: 10 },
                                              { value: 2, type: :numeric, base: 10 }],
                                             Rpl::Lang::Dictionary.new
    assert_equal [],
                 stack
  end

  def test_rot
    stack, _dictionary = Rpl::Lang::Core.rot [{ value: 1, type: :numeric, base: 10 },
                                              { value: 2, type: :numeric, base: 10 },
                                              { value: 3, type: :numeric, base: 10 }],
                                             Rpl::Lang::Dictionary.new
    assert_equal [{ value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_dup
    stack, _dictionary = Rpl::Lang::Core.dup [{ value: 1, type: :numeric, base: 10 },
                                              { value: 2, type: :numeric, base: 10 }],
                                             Rpl::Lang::Dictionary.new
    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 stack
  end

  def test_dup2
    stack, _dictionary = Rpl::Lang::Core.dup2 [{ value: 1, type: :numeric, base: 10 },
                                               { value: 2, type: :numeric, base: 10 }],
                                              Rpl::Lang::Dictionary.new
    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 stack
  end

  def test_dupn
    stack, _dictionary = Rpl::Lang::Core.dupn [{ value: 1, type: :numeric, base: 10 },
                                               { value: 2, type: :numeric, base: 10 },
                                               { value: 3, type: :numeric, base: 10 },
                                               { value: 4, type: :numeric, base: 10 },
                                               { value: 3, type: :numeric, base: 10 }],
                                              Rpl::Lang::Dictionary.new
    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 stack
  end

  def test_pick
    stack, _dictionary = Rpl::Lang::Core.pick [{ value: 1, type: :numeric, base: 10 },
                                               { value: 2, type: :numeric, base: 10 },
                                               { value: 3, type: :numeric, base: 10 },
                                               { value: 4, type: :numeric, base: 10 },
                                               { value: 3, type: :numeric, base: 10 }],
                                              Rpl::Lang::Dictionary.new
    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 stack
  end

  def test_depth
    stack, _dictionary = Rpl::Lang::Core.depth [],
                                               Rpl::Lang::Dictionary.new
    assert_equal [{ value: 0, type: :numeric, base: 10 }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.depth [{ value: 1, type: :numeric, base: 10 },
                                                { value: 2, type: :numeric, base: 10 }],
                                               Rpl::Lang::Dictionary.new
    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 stack
  end

  def test_roll
    stack, _dictionary = Rpl::Lang::Core.roll [{ value: 1, type: :numeric, base: 10 },
                                               { value: 2, type: :numeric, base: 10 },
                                               { value: 3, type: :numeric, base: 10 },
                                               { value: 4, type: :numeric, base: 10 },
                                               { value: 3, type: :numeric, base: 10 }],
                                              Rpl::Lang::Dictionary.new
    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 stack
  end

  def test_rolld
    stack, _dictionary = Rpl::Lang::Core.rolld [{ value: 1, type: :numeric, base: 10 },
                                                { value: 2, type: :numeric, base: 10 },
                                                { value: 4, type: :numeric, base: 10 },
                                                { value: 3, type: :numeric, base: 10 },
                                                { value: 2, type: :numeric, base: 10 }],
                                               Rpl::Lang::Dictionary.new
    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 stack
  end

  def test_over
    stack, _dictionary = Rpl::Lang::Core.over [{ value: 1, type: :numeric, base: 10 },
                                               { value: 2, type: :numeric, base: 10 },
                                               { value: 3, type: :numeric, base: 10 },
                                               { value: 4, type: :numeric, base: 10 }],
                                              Rpl::Lang::Dictionary.new
    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 }],
                 stack
  end
end
