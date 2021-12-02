# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../lib/core'

class TesttLanguageOperations < Test::Unit::TestCase
  def test_add
    stack = Rpl::Core.add [{ value: 1, type: :numeric, base: 10 },
                           { value: 2, type: :numeric, base: 10 }]
    assert_equal [{ value: 3, type: :numeric, base: 10 }],
                 stack

    stack = Rpl::Core.add [{ value: 1, type: :numeric, base: 10 },
                           { value: '"a"', type: :string }]
    assert_equal [{ value: '"1a"', type: :string }],
                 stack

    stack = Rpl::Core.add [{ value: 1, type: :numeric, base: 10 },
                           { value: "'a'", type: :name }]
    assert_equal [{ value: '"1a"', type: :string }],
                 stack

    stack = Rpl::Core.add [{ value: "'a'", type: :name },
                           { value: 1, type: :numeric, base: 10 }]
    assert_equal [{ value: "'a1'", type: :name }],
                 stack

    stack = Rpl::Core.add [{ value: "'a'", type: :name },
                           { value: '"b"', type: :string }]
    assert_equal [{ value: "'ab'", type: :name }],
                 stack

    stack = Rpl::Core.add [{ value: "'a'", type: :name },
                           { value: "'b'", type: :name }]
    assert_equal [{ value: "'ab'", type: :name }],
                 stack

    stack = Rpl::Core.add [{ value: '"a"', type: :string },
                           { value: '"b"', type: :string }]
    assert_equal [{ value: '"ab"', type: :string }],
                 stack

    stack = Rpl::Core.add [{ value: '"a"', type: :string },
                           { value: "'b'", type: :name }]
    assert_equal [{ value: '"ab"', type: :string }],
                 stack

    stack = Rpl::Core.add [{ value: '"a"', type: :string },
                           { value: 1, type: :numeric, base: 10 }]
    assert_equal [{ value: '"a1"', type: :string }],
                 stack
  end

  def test_subtract
    stack = Rpl::Core.subtract [{ value: 1, type: :numeric, base: 10 },
                                { value: 2, type: :numeric, base: 10 }]
    assert_equal [{ value: -1, type: :numeric, base: 10 }],
                 stack

    stack = Rpl::Core.subtract [{ value: 2, type: :numeric, base: 10 },
                                { value: 1, type: :numeric, base: 10 }]
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_negate
    stack = Rpl::Core.negate [{ value: -1, type: :numeric, base: 10 }]

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack

    stack = Rpl::Core.negate [{ value: 1, type: :numeric, base: 10 }]

    assert_equal [{ value: -1, type: :numeric, base: 10 }],
                 stack
  end

  def test_multiply
    stack = Rpl::Core.multiply [{ value: 3, type: :numeric, base: 10 },
                                { value: 4, type: :numeric, base: 10 }]
    assert_equal [{ value: 12, type: :numeric, base: 10 }],
                 stack
  end

  def test_divide
    stack = Rpl::Core.divide [{ value: 3.0, type: :numeric, base: 10 },
                              { value: 4, type: :numeric, base: 10 }]
    assert_equal [{ value: 0.75, type: :numeric, base: 10 }],
                 stack

    # stack = Rpl::Core.divide [{ value: 3, type: :numeric, base: 10 },
    #                                       { value: 4, type: :numeric, base: 10 }]
    # assert_equal [{ value: 0.75, type: :numeric, base: 10 }],
    #              stack
  end

  def test_inverse
    stack = Rpl::Core.inverse [{ value: 4, type: :numeric, base: 10 }]
    assert_equal [{ value: 0.25, type: :numeric, base: 10 }],
                 stack
  end

  def test_power
    stack = Rpl::Core.power [{ value: 3, type: :numeric, base: 10 },
                             { value: 4, type: :numeric, base: 10 }]
    assert_equal [{ value: 81, type: :numeric, base: 10 }],
                 stack
  end

  def test_sqrt
    stack = Rpl::Core.sqrt [{ value: 16, type: :numeric, base: 10 }]
    assert_equal [{ value: 4, type: :numeric, base: 10 }],
                 stack
  end

  def test_sq
    stack = Rpl::Core.sq [{ value: 4, type: :numeric, base: 10 }]
    assert_equal [{ value: 16, type: :numeric, base: 10 }],
                 stack
  end

  def test_abs
    stack = Rpl::Core.abs [{ value: -1, type: :numeric, base: 10 }]

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack

    stack = Rpl::Core.abs [{ value: 1, type: :numeric, base: 10 }]

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_dec
    stack = Rpl::Core.dec [{ value: 1, type: :numeric, base: 16 }]

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_hex
    stack = Rpl::Core.hex [{ value: 1, type: :numeric, base: 10 }]

    assert_equal [{ value: 1, type: :numeric, base: 16 }],
                 stack
  end

  def test_bin
    stack = Rpl::Core.bin [{ value: 1, type: :numeric, base: 10 }]

    assert_equal [{ value: 1, type: :numeric, base: 2 }],
                 stack
  end

  def test_base
    stack = Rpl::Core.base [{ value: 1, type: :numeric, base: 10 },
                            { value: 31, type: :numeric, base: 10 }]

    assert_equal [{ value: 1, type: :numeric, base: 31 }],
                 stack
  end

  def test_sign
    stack = Rpl::Core.sign [{ value: -10, type: :numeric, base: 10 }]

    assert_equal [{ value: -1, type: :numeric, base: 10 }],
                 stack

    stack = Rpl::Core.sign [{ value: 10, type: :numeric, base: 10 }]

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack
    stack = Rpl::Core.sign [{ value: 0, type: :numeric, base: 10 }]

    assert_equal [{ value: 0, type: :numeric, base: 10 }],
                 stack
  end

  def test_percent
    stack = Rpl::Core.percent [{ value: 2, type: :numeric, base: 10 },
                               { value: 33, type: :numeric, base: 10 }]

    assert_equal [{ value: 0.66, type: :numeric, base: 10 }],
                 stack
  end

  def test_inverse_percent
    stack = Rpl::Core.inverse_percent [{ value: 2, type: :numeric, base: 10 },
                                       { value: 0.66, type: :numeric, base: 10 }]

    assert_equal [{ value: 33, type: :numeric, base: 10 }],
                 stack
  end

  def test_mod
    stack = Rpl::Core.mod [{ value: 9, type: :numeric, base: 10 },
                           { value: 4, type: :numeric, base: 10 }]

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_fact
    stack = Rpl::Core.fact [{ value: 5, type: :numeric, base: 10 }]

    assert_equal [{ value: 24, type: :numeric, base: 10 }],
                 stack
  end

  def test_floor
    stack = Rpl::Core.floor [{ value: 5.23, type: :numeric, base: 10 }]

    assert_equal [{ value: 5, type: :numeric, base: 10 }],
                 stack
  end

  def test_ceil
    stack = Rpl::Core.ceil [{ value: 5.23, type: :numeric, base: 10 }]

    assert_equal [{ value: 6, type: :numeric, base: 10 }],
                 stack
  end

  def test_min
    stack = Rpl::Core.min [{ value: 1, type: :numeric, base: 10 },
                           { value: 2, type: :numeric, base: 10 }]

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack

    stack = Rpl::Core.min [{ value: 2, type: :numeric, base: 10 },
                           { value: 1, type: :numeric, base: 10 }]

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_max
    stack = Rpl::Core.max [{ value: 1, type: :numeric, base: 10 },
                           { value: 2, type: :numeric, base: 10 }]

    assert_equal [{ value: 2, type: :numeric, base: 10 }],
                 stack

    stack = Rpl::Core.max [{ value: 2, type: :numeric, base: 10 },
                           { value: 1, type: :numeric, base: 10 }]

    assert_equal [{ value: 2, type: :numeric, base: 10 }],
                 stack
  end
end
