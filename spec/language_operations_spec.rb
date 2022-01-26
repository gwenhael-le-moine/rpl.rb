# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TesttLanguageOperations < Test::Unit::TestCase
  def test_add
    lang = Rpl::Language.new
    lang.run '1 2 +'
    assert_equal [{ value: 3, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '1 "a" +'
    assert_equal [{ value: '1a', type: :string }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '1 \'a\' +'
    assert_equal [{ value: '1a', type: :string }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '1 dup dup →list +'
    assert_equal [{ value: [{ value: 1, type: :numeric, base: 10 },
                            { value: 1, type: :numeric, base: 10 }],
                    type: :list }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '"a" "b" +'
    assert_equal [{ value: 'ab', type: :string }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '"a" \'b\' +'
    assert_equal [{ value: 'ab', type: :string }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '"a" 1 +'
    assert_equal [{ value: 'a1', type: :string }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '"a" 1 dup →list +'
    assert_equal [{ value: [{ value: 'a', type: :string },
                            { value: 1, type: :numeric, base: 10 }],
                    type: :list }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '\'a\' 1 +'
    assert_equal [{ value: 'a1', type: :name }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '\'a\' "b" +'
    assert_equal [{ value: 'ab', type: :string }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '\'a\' \'b\' +'
    assert_equal [{ value: 'ab', type: :name }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '\'a\' 1 dup →list +'
    assert_equal [{ value: [{ value: 'a', type: :name },
                            { value: 1, type: :numeric, base: 10 }],
                    type: :list }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '1 a "test" 3 →list dup rev +'
    assert_equal [{ type: :list,
                    value: [{ value: 1, type: :numeric, base: 10 },
                            { type: :name, value: 'a' },
                            { value: 'test', type: :string },
                            { value: 'test', type: :string },
                            { type: :name, value: 'a' },
                            { value: 1, type: :numeric, base: 10 }] }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '1 a "test" 3 →list 9 +'
    assert_equal [{ type: :list,
                    value: [{ value: 1, type: :numeric, base: 10 },
                            { type: :name, value: 'a' },
                            { value: 'test', type: :string },
                            { value: 9, type: :numeric, base: 10 }] }],
                 lang.stack
  end

  def test_subtract
    lang = Rpl::Language.new
    lang.run '1 2 -'
    assert_equal [{ value: -1, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '2 1 -'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_negate
    lang = Rpl::Language.new
    lang.run '-1 chs'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '1 chs'
    assert_equal [{ value: -1, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_multiply
    lang = Rpl::Language.new
    lang.run '3 4 *'
    assert_equal [{ value: 12, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_divide
    lang = Rpl::Language.new
    lang.run '3.0 4 /'
    assert_equal [{ value: 0.75, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_inverse
    lang = Rpl::Language.new
    lang.run '4 inv'
    assert_equal [{ value: 0.25, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_power
    lang = Rpl::Language.new
    lang.run '3 4 ^'
    assert_equal [{ value: 81, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_sqrt
    lang = Rpl::Language.new
    lang.run '16 √'
    assert_equal [{ value: 4, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_sq
    lang = Rpl::Language.new
    lang.run '4 sq'
    assert_equal [{ value: 16, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_abs
    lang = Rpl::Language.new
    lang.run '-1 abs'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '1 abs'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_dec
    lang = Rpl::Language.new
    lang.run '0x1 dec'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_hex
    lang = Rpl::Language.new
    lang.run '1 hex'
    assert_equal [{ value: 1, type: :numeric, base: 16 }],
                 lang.stack
  end

  def test_bin
    lang = Rpl::Language.new
    lang.run '1 bin'
    assert_equal [{ value: 1, type: :numeric, base: 2 }],
                 lang.stack
  end

  def test_base
    lang = Rpl::Language.new
    lang.run '1 31 base'
    assert_equal [{ value: 1, type: :numeric, base: 31 }],
                 lang.stack
  end

  def test_sign
    lang = Rpl::Language.new
    lang.run '-10 sign'
    assert_equal [{ value: -1, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '10 sign'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '0 sign'
    assert_equal [{ value: 0, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_percent
    lang = Rpl::Language.new
    lang.run '2 33 %'
    assert_equal [{ value: 0.66, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_inverse_percent
    lang = Rpl::Language.new
    lang.run '2 0.66 %CH'
    assert_equal [{ value: 33, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_mod
    lang = Rpl::Language.new
    lang.run '9 4 mod'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_fact
    lang = Rpl::Language.new
    lang.run '5 !'
    assert_equal [{ value: 24, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_floor
    lang = Rpl::Language.new
    lang.run '5.23 floor'
    assert_equal [{ value: 5, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_ceil
    lang = Rpl::Language.new
    lang.run '5.23 ceil'
    assert_equal [{ value: 6, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_min
    lang = Rpl::Language.new
    lang.run '1 2 min'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '2 1 min'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_max
    lang = Rpl::Language.new
    lang.run '1 2 max'
    assert_equal [{ value: 2, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '2 1 max'
    assert_equal [{ value: 2, type: :numeric, base: 10 }],
                 lang.stack
  end
end
