# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../lib/core'

class TestLanguageStack < Test::Unit::TestCase
  def test_swap
    stack = Rpl::Lang::Core.swap [{ value: 1, type: :numeric, base: 10 },
                                  { value: 2, type: :numeric, base: 10 }]
    assert_equal [{ value: 2, type: :numeric, base: 10 },
                  { value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_drop
    stack = Rpl::Lang::Core.drop [{ value: 1, type: :numeric, base: 10 },
                                  { value: 2, type: :numeric, base: 10 }]
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_drop2
    stack = Rpl::Lang::Core.drop2 [{ value: 1, type: :numeric, base: 10 },
                                   { value: 2, type: :numeric, base: 10 }]
    assert_equal [],
                 stack
  end

  def test_dropn
    stack = Rpl::Lang::Core.dropn [{ value: 1, type: :numeric, base: 10 },
                                   { value: 2, type: :numeric, base: 10 },
                                   { value: 3, type: :numeric, base: 10 },
                                   { value: 4, type: :numeric, base: 10 },
                                   { value: 3, type: :numeric, base: 10 }]
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_del
    stack = Rpl::Lang::Core.del [{ value: 1, type: :numeric, base: 10 },
                                 { value: 2, type: :numeric, base: 10 }]
    assert_equal [],
                 stack
  end

  def test_rot
    stack = Rpl::Lang::Core.rot [{ value: 1, type: :numeric, base: 10 },
                                 { value: 2, type: :numeric, base: 10 },
                                 { value: 3, type: :numeric, base: 10 }]
    assert_equal [{ value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_dup
    stack = Rpl::Lang::Core.dup [{ value: 1, type: :numeric, base: 10 },
                                 { value: 2, type: :numeric, base: 10 }]
    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 stack
  end

  def test_dup2
    stack = Rpl::Lang::Core.dup2 [{ value: 1, type: :numeric, base: 10 },
                                  { value: 2, type: :numeric, base: 10 }]
    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 stack
  end

  def test_dupn
    stack = Rpl::Lang::Core.dupn [{ value: 1, type: :numeric, base: 10 },
                                  { value: 2, type: :numeric, base: 10 },
                                  { value: 3, type: :numeric, base: 10 },
                                  { value: 4, type: :numeric, base: 10 },
                                  { value: 3, type: :numeric, base: 10 }]
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
    stack = Rpl::Lang::Core.pick [{ value: 1, type: :numeric, base: 10 },
                                  { value: 2, type: :numeric, base: 10 },
                                  { value: 3, type: :numeric, base: 10 },
                                  { value: 4, type: :numeric, base: 10 },
                                  { value: 3, type: :numeric, base: 10 }]
    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 stack
  end

  def test_depth
    stack = Rpl::Lang::Core.depth []
    assert_equal [{ value: 0, type: :numeric, base: 10 }],
                 stack

    stack = Rpl::Lang::Core.depth [{ value: 1, type: :numeric, base: 10 },
                                   { value: 2, type: :numeric, base: 10 }]
    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 stack
  end

  def test_roll
    stack = Rpl::Lang::Core.roll [{ value: 1, type: :numeric, base: 10 },
                                  { value: 2, type: :numeric, base: 10 },
                                  { value: 3, type: :numeric, base: 10 },
                                  { value: 4, type: :numeric, base: 10 },
                                  { value: 3, type: :numeric, base: 10 }]
    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 stack
  end

  def test_rolld
    stack = Rpl::Lang::Core.rolld [{ value: 1, type: :numeric, base: 10 },
                                   { value: 2, type: :numeric, base: 10 },
                                   { value: 4, type: :numeric, base: 10 },
                                   { value: 3, type: :numeric, base: 10 },
                                   { value: 2, type: :numeric, base: 10 }]
    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 stack
  end

  def test_over
    stack = Rpl::Lang::Core.over [{ value: 1, type: :numeric, base: 10 },
                                  { value: 2, type: :numeric, base: 10 },
                                  { value: 3, type: :numeric, base: 10 },
                                  { value: 4, type: :numeric, base: 10 }]
    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 }],
                 stack
  end
end
