# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../interpreter'

class TestLanguageStack < Test::Unit::TestCase
  def test_swap
    interpreter = Rpl::Interpreter.new
    interpreter.run '1 2 swap'

    assert_equal [{ value: 2, type: :numeric, base: 10 },
                  { value: 1, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_drop
    interpreter = Rpl::Interpreter.new
    interpreter.run '1 2 drop'

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_drop2
    interpreter = Rpl::Interpreter.new
    interpreter.run '1 2 drop2'

    assert_equal [],
                 interpreter.stack
  end

  def test_dropn
    interpreter = Rpl::Interpreter.new
    interpreter.run '1 2 3 4 3 dropn'

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_del
    interpreter = Rpl::Interpreter.new
    interpreter.run '1 2 del'

    assert_empty interpreter.stack
  end

  def test_rot
    interpreter = Rpl::Interpreter.new
    interpreter.run '1 2 3 rot'

    assert_equal [{ value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 1, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_dup
    interpreter = Rpl::Interpreter.new
    interpreter.run '1 2 dup'

    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_dup2
    interpreter = Rpl::Interpreter.new
    interpreter.run '1 2 dup2'

    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_dupn
    interpreter = Rpl::Interpreter.new
    interpreter.run '1 2 3 4 3 dupn'

    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_pick
    interpreter = Rpl::Interpreter.new
    interpreter.run '1 2 3 4 3 pick'

    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_depth
    interpreter = Rpl::Interpreter.new
    interpreter.run 'depth'

    assert_equal [{ value: 0, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run '1 2 depth'

    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_roll
    interpreter = Rpl::Interpreter.new
    interpreter.run '1 2 3 4 3 roll'

    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_rolld
    interpreter = Rpl::Interpreter.new
    interpreter.run '1 2 4 3 2 rolld'

    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_over
    interpreter = Rpl::Interpreter.new
    interpreter.run '1 2 3 4 over'

    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 }],
                 interpreter.stack
  end
end
