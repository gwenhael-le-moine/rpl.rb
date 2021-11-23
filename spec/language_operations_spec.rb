# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../lib/core'

class TesttLanguageOperations < Test::Unit::TestCase
  def test_add
    stack = Rpl::Core.add [{ value: 1, type: :numeric },
                           { value: 2, type: :numeric }]
    assert_equal [{ value: 3, type: :numeric }],
                 stack

    stack = Rpl::Core.add [{ value: 1, type: :numeric },
                           { value: '"a"', type: :string }]
    assert_equal [{ value: '"1a"', type: :string }],
                 stack

    stack = Rpl::Core.add [{ value: 1, type: :numeric },
                           { value: "'a'", type: :name }]
    assert_equal [{ value: '"1a"', type: :string }],
                 stack

    stack = Rpl::Core.add [{ value: "'a'", type: :name },
                           { value: 1, type: :numeric }]
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
                           { value: 1, type: :numeric }]
    assert_equal [{ value: '"a1"', type: :string }],
                 stack
  end

  def test_subtract
    stack = Rpl::Core.subtract [{ value: 1, type: :numeric },
                                { value: 2, type: :numeric }]
    assert_equal [{ value: -1, type: :numeric }],
                 stack

    stack = Rpl::Core.subtract [{ value: 2, type: :numeric },
                                { value: 1, type: :numeric }]
    assert_equal [{ value: 1, type: :numeric }],
                 stack
  end

  def test_negate
    stack = Rpl::Core.negate [{ value: -1, type: :numeric }]

    assert_equal [{ value: 1, type: :numeric }],
                 stack

    stack = Rpl::Core.negate [{ value: 1, type: :numeric }]

    assert_equal [{ value: -1, type: :numeric }],
                 stack
  end

  def test_multiply
    stack = Rpl::Core.multiply [{ value: 3, type: :numeric },
                                { value: 4, type: :numeric }]
    assert_equal [{ value: 12, type: :numeric }],
                 stack
  end

  def test_divide
    stack = Rpl::Core.divide [{ value: 3.0, type: :numeric },
                              { value: 4, type: :numeric }]
    assert_equal [{ value: 0.75, type: :numeric }],
                 stack

    # stack = Rpl::Core.divide [{ value: 3, type: :numeric },
    #                                       { value: 4, type: :numeric }]
    # assert_equal [{ value: 0.75, type: :numeric }],
    #              stack
  end

  def test_inverse
    stack = Rpl::Core.inverse [{ value: 4, type: :numeric }]
    assert_equal [{ value: 0.25, type: :numeric }],
                 stack
  end

  def test_power
    stack = Rpl::Core.power [{ value: 3, type: :numeric },
                             { value: 4, type: :numeric }]
    assert_equal [{ value: 81, type: :numeric }],
                 stack
  end

  def test_sqrt
    stack = Rpl::Core.sqrt [{ value: 16, type: :numeric }]
    assert_equal [{ value: 4, type: :numeric }],
                 stack
  end

  def test_sq
    stack = Rpl::Core.sq [{ value: 4, type: :numeric }]
    assert_equal [{ value: 16, type: :numeric }],
                 stack
  end

  def test_abs
    stack = Rpl::Core.abs [{ value: -1, type: :numeric }]

    assert_equal [{ value: 1, type: :numeric }],
                 stack

    stack = Rpl::Core.abs [{ value: 1, type: :numeric }]

    assert_equal [{ value: 1, type: :numeric }],
                 stack
  end

  def test_dec
  end

  def test_hex
  end

  def test_bin
  end

  def test_base
  end

  def test_sign
    stack = Rpl::Core.sign [{ value: -10, type: :numeric }]

    assert_equal [{ value: -1, type: :numeric }],
                 stack

    stack = Rpl::Core.sign [{ value: 10, type: :numeric }]

    assert_equal [{ value: 1, type: :numeric }],
                 stack
    stack = Rpl::Core.sign [{ value: 0, type: :numeric }]

    assert_equal [{ value: 0, type: :numeric }],
                 stack
  end
end
