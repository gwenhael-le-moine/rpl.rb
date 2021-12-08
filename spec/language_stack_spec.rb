# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TestLanguageStack < Test::Unit::TestCase
  def test_swap
    lang = Rpl::Language.new
    lang.run '1 2 swap'

    assert_equal [{ value: 2, type: :numeric, base: 10 },
                  { value: 1, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_drop
    lang = Rpl::Language.new
    lang.run '1 2 drop'

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_drop2
    lang = Rpl::Language.new
    lang.run '1 2 drop2'

    assert_equal [],
                 lang.stack
  end

  def test_dropn
    lang = Rpl::Language.new
    lang.run '1 2 3 4 3 dropn'

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_del
    lang = Rpl::Language.new
    lang.run '1 2 del'

    assert_empty lang.stack
  end

  def test_rot
    lang = Rpl::Language.new
    lang.run '1 2 3 rot'

    assert_equal [{ value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 1, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_dup
    lang = Rpl::Language.new
    lang.run '1 2 dup'

    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_dup2
    lang = Rpl::Language.new
    lang.run '1 2 dup2'

    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_dupn
    lang = Rpl::Language.new
    lang.run '1 2 3 4 3 dupn'

    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_pick
    lang = Rpl::Language.new
    lang.run '1 2 3 4 3 pick'

    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_depth
    lang = Rpl::Language.new
    lang.run 'depth'

    assert_equal [{ value: 0, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '1 2 depth'

    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_roll
    lang = Rpl::Language.new
    lang.run '1 2 3 4 3 roll'

    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_rolld
    lang = Rpl::Language.new
    lang.run '1 2 4 3 2 rolld'

    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_over
    lang = Rpl::Language.new
    lang.run '1 2 3 4 over'

    assert_equal [{ value: 1, type: :numeric, base: 10 },
                  { value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 }],
                 lang.stack
  end
end
