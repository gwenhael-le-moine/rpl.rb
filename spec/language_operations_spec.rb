# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require 'rpl'

class TesttLanguageOperations < Test::Unit::TestCase
  def test_add
    interpreter = Rpl.new
    interpreter.run '1 2 +'
    assert_equal [{ value: 3, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 "a" +'
    assert_equal [{ value: '1a', type: :string }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 \'a\' +'
    assert_equal [{ value: '1a', type: :string }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 dup dup →list +'
    assert_equal [{ value: [{ value: 1, type: :numeric, base: 10 },
                            { value: 1, type: :numeric, base: 10 }],
                    type: :list }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" "b" +'
    assert_equal [{ value: 'ab', type: :string }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" \'b\' +'
    assert_equal [{ value: 'ab', type: :string }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" 1 +'
    assert_equal [{ value: 'a1', type: :string }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" 1 dup →list +'
    assert_equal [{ value: [{ value: 'a', type: :string },
                            { value: 1, type: :numeric, base: 10 }],
                    type: :list }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'a\' 1 +'
    assert_equal [{ value: 'a1', type: :name }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'a\' "b" +'
    assert_equal [{ value: 'ab', type: :string }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'a\' \'b\' +'
    assert_equal [{ value: 'ab', type: :name }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'a\' 1 dup →list +'
    assert_equal [{ value: [{ value: 'a', type: :name },
                            { value: 1, type: :numeric, base: 10 }],
                    type: :list }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 a "test" 3 →list dup rev +'
    assert_equal [{ type: :list,
                    value: [{ value: 1, type: :numeric, base: 10 },
                            { type: :name, value: 'a' },
                            { value: 'test', type: :string },
                            { value: 'test', type: :string },
                            { type: :name, value: 'a' },
                            { value: 1, type: :numeric, base: 10 }] }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 a "test" 3 →list 9 +'
    assert_equal [{ type: :list,
                    value: [{ value: 1, type: :numeric, base: 10 },
                            { type: :name, value: 'a' },
                            { value: 'test', type: :string },
                            { value: 9, type: :numeric, base: 10 }] }],
                 interpreter.stack
  end

  def test_subtract
    interpreter = Rpl.new
    interpreter.run '1 2 -'
    assert_equal [{ value: -1, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '2 1 -'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_negate
    interpreter = Rpl.new
    interpreter.run '-1 chs'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 chs'
    assert_equal [{ value: -1, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_multiply
    interpreter = Rpl.new
    interpreter.run '3 4 *'
    assert_equal [{ value: 12, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_divide
    interpreter = Rpl.new
    interpreter.run '3.0 4 /'
    assert_equal [{ value: 0.75, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_inverse
    interpreter = Rpl.new
    interpreter.run '4 inv'
    assert_equal [{ value: 0.25, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_power
    interpreter = Rpl.new
    interpreter.run '3 4 ^'
    assert_equal [{ value: 81, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_sqrt
    interpreter = Rpl.new
    interpreter.run '16 √'
    assert_equal [{ value: 4, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_sq
    interpreter = Rpl.new
    interpreter.run '4 sq'
    assert_equal [{ value: 16, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_abs
    interpreter = Rpl.new
    interpreter.run '-1 abs'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 abs'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_dec
    interpreter = Rpl.new
    interpreter.run '0x1 dec'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_hex
    interpreter = Rpl.new
    interpreter.run '1 hex'
    assert_equal [{ value: 1, type: :numeric, base: 16 }],
                 interpreter.stack
  end

  def test_bin
    interpreter = Rpl.new
    interpreter.run '1 bin'
    assert_equal [{ value: 1, type: :numeric, base: 2 }],
                 interpreter.stack
  end

  def test_base
    interpreter = Rpl.new
    interpreter.run '1 31 base'
    assert_equal [{ value: 1, type: :numeric, base: 31 }],
                 interpreter.stack
  end

  def test_sign
    interpreter = Rpl.new
    interpreter.run '-10 sign'
    assert_equal [{ value: -1, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '10 sign'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '0 sign'
    assert_equal [{ value: 0, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_percent
    interpreter = Rpl.new
    interpreter.run '2 33 %'
    assert_equal [{ value: 0.66, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_inverse_percent
    interpreter = Rpl.new
    interpreter.run '2 0.66 %CH'
    assert_equal [{ value: 33, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_mod
    interpreter = Rpl.new
    interpreter.run '9 4 mod'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_fact
    interpreter = Rpl.new
    interpreter.run '5 !'
    assert_equal [{ value: 24, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_floor
    interpreter = Rpl.new
    interpreter.run '5.23 floor'
    assert_equal [{ value: 5, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_ceil
    interpreter = Rpl.new
    interpreter.run '5.23 ceil'
    assert_equal [{ value: 6, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_min
    interpreter = Rpl.new
    interpreter.run '1 2 min'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '2 1 min'
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_max
    interpreter = Rpl.new
    interpreter.run '1 2 max'
    assert_equal [{ value: 2, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '2 1 max'
    assert_equal [{ value: 2, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_ip
    interpreter = Rpl.new
    interpreter.run '3.14 ip'
    assert_equal [{ value: 3, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_fp
    interpreter = Rpl.new
    interpreter.run '3.14 fp'
    assert_equal [{ value: 0.14, type: :numeric, base: 10 }],
                 interpreter.stack
  end
end
