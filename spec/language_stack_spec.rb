# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../lib/core'

class TestParser < Test::Unit::TestCase
  def test_swap
    stack = Rpn::Core::Stack.swap [{ value: 1, type: :numeric },
                                   { value: 2, type: :numeric }]
    assert_equal [{ value: 2, type: :numeric },
                  { value: 1, type: :numeric }],
                 stack
  end

  def test_drop
    stack = Rpn::Core::Stack.drop [{ value: 1, type: :numeric },
                                   { value: 2, type: :numeric }]
    assert_equal [{ value: 1, type: :numeric }],
                 stack
  end

  def test_drop2
    stack = Rpn::Core::Stack.drop2 [{ value: 1, type: :numeric },
                                    { value: 2, type: :numeric }]
    assert_equal [],
                 stack
  end

  def test_dropn
    stack = Rpn::Core::Stack.dropn [{ value: 1, type: :numeric },
                                    { value: 2, type: :numeric },
                                    { value: 3, type: :numeric },
                                    { value: 4, type: :numeric },
                                    { value: 3, type: :numeric }]
    assert_equal [{ value: 1, type: :numeric }],
                 stack
  end

  def test_del
    stack = Rpn::Core::Stack.del [{ value: 1, type: :numeric },
                                  { value: 2, type: :numeric }]
    assert_equal [],
                 stack
  end

  def test_rot
    stack = Rpn::Core::Stack.rot [{ value: 1, type: :numeric },
                                  { value: 2, type: :numeric },
                                  { value: 3, type: :numeric }]
    assert_equal [{ value: 2, type: :numeric },
                  { value: 3, type: :numeric },
                  { value: 1, type: :numeric }],
                 stack
  end

  def test_dup
    stack = Rpn::Core::Stack.dup [{ value: 1, type: :numeric },
                                  { value: 2, type: :numeric }]
    assert_equal [{ value: 1, type: :numeric },
                  { value: 2, type: :numeric },
                  { value: 2, type: :numeric }],
                 stack
  end

  def test_dup2
    stack = Rpn::Core::Stack.dup2 [{ value: 1, type: :numeric },
                                   { value: 2, type: :numeric }]
    assert_equal [{ value: 1, type: :numeric },
                  { value: 2, type: :numeric },
                  { value: 1, type: :numeric },
                  { value: 2, type: :numeric }],
                 stack
  end

  def test_dupn
    stack = Rpn::Core::Stack.dupn [{ value: 1, type: :numeric },
                                   { value: 2, type: :numeric },
                                   { value: 3, type: :numeric },
                                   { value: 4, type: :numeric },
                                   { value: 3, type: :numeric }]
    assert_equal [{ value: 1, type: :numeric },
                  { value: 2, type: :numeric },
                  { value: 3, type: :numeric },
                  { value: 4, type: :numeric },
                  { value: 2, type: :numeric },
                  { value: 3, type: :numeric },
                  { value: 4, type: :numeric }],
                 stack
  end

  def test_pick
    stack = Rpn::Core::Stack.pick [{ value: 1, type: :numeric },
                                   { value: 2, type: :numeric },
                                   { value: 3, type: :numeric },
                                   { value: 4, type: :numeric },
                                   { value: 3, type: :numeric }]
    assert_equal [{ value: 1, type: :numeric },
                  { value: 2, type: :numeric },
                  { value: 3, type: :numeric },
                  { value: 4, type: :numeric },
                  { value: 2, type: :numeric }],
                 stack
  end

  def test_depth
    stack = Rpn::Core::Stack.depth []
    assert_equal [{ value: 0, type: :numeric }],
                 stack

    stack = Rpn::Core::Stack.depth [{ value: 1, type: :numeric },
                                    { value: 2, type: :numeric }]
    assert_equal [{ value: 1, type: :numeric },
                  { value: 2, type: :numeric },
                  { value: 2, type: :numeric }],
                 stack
  end

  def test_roll
    stack = Rpn::Core::Stack.roll [{ value: 1, type: :numeric },
                                   { value: 2, type: :numeric },
                                   { value: 3, type: :numeric },
                                   { value: 4, type: :numeric },
                                   { value: 3, type: :numeric }]
    assert_equal [{ value: 1, type: :numeric },
                  { value: 3, type: :numeric },
                  { value: 4, type: :numeric },
                  { value: 2, type: :numeric }],
                 stack
  end

  def test_rolld
    stack = Rpn::Core::Stack.rolld [{ value: 1, type: :numeric },
                                    { value: 2, type: :numeric },
                                    { value: 4, type: :numeric },
                                    { value: 3, type: :numeric },
                                    { value: 2, type: :numeric }]
    assert_equal [{ value: 1, type: :numeric },
                  { value: 2, type: :numeric },
                  { value: 3, type: :numeric },
                  { value: 4, type: :numeric }],
                 stack
  end

  def test_over
    stack = Rpn::Core::Stack.over [{ value: 1, type: :numeric },
                                   { value: 2, type: :numeric },
                                   { value: 3, type: :numeric },
                                   { value: 4, type: :numeric }]
    assert_equal [{ value: 1, type: :numeric },
                  { value: 2, type: :numeric },
                  { value: 3, type: :numeric },
                  { value: 4, type: :numeric },
                  { value: 3, type: :numeric }],
                 stack
  end
end
