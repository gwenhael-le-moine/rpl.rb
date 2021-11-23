# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../lib/core'

class TesttLanguageOperations < Test::Unit::TestCase
  def test_add
    stack = Rpn::Core::Operations.add [{ value: 1, type: :numeric },
                                       { value: 2, type: :numeric }]
    assert_equal [{ value: 3, type: :numeric }],
                 stack

    stack = Rpn::Core::Operations.add [{ value: 1, type: :numeric },
                                       { value: '"a"', type: :string }]
    assert_equal [{ value: '"1a"', type: :string }],
                 stack

    stack = Rpn::Core::Operations.add [{ value: 1, type: :numeric },
                                       { value: "'a'", type: :name }]
    assert_equal [{ value: '"1a"', type: :string }],
                 stack

    stack = Rpn::Core::Operations.add [{ value: "'a'", type: :name },
                                       { value: 1, type: :numeric }]
    assert_equal [{ value: "'a1'", type: :name }],
                 stack

    stack = Rpn::Core::Operations.add [{ value: "'a'", type: :name },
                                       { value: '"b"', type: :string }]
    assert_equal [{ value: "'ab'", type: :name }],
                 stack

    stack = Rpn::Core::Operations.add [{ value: "'a'", type: :name },
                                       { value: "'b'", type: :name }]
    assert_equal [{ value: "'ab'", type: :name }],
                 stack

    stack = Rpn::Core::Operations.add [{ value: '"a"', type: :string },
                                       { value: '"b"', type: :string }]
    assert_equal [{ value: '"ab"', type: :string }],
                 stack

    stack = Rpn::Core::Operations.add [{ value: '"a"', type: :string },
                                       { value: "'b'", type: :name }]
    assert_equal [{ value: '"ab"', type: :string }],
                 stack

    stack = Rpn::Core::Operations.add [{ value: '"a"', type: :string },
                                       { value: 1, type: :numeric }]
    assert_equal [{ value: '"a1"', type: :string }],
                 stack
  end

  def test_subtract
    stack = Rpn::Core::Operations.subtract [{ value: 1, type: :numeric },
                                            { value: 2, type: :numeric }]
    assert_equal [{ value: -1, type: :numeric }],
                 stack

    stack = Rpn::Core::Operations.subtract [{ value: 2, type: :numeric },
                                            { value: 1, type: :numeric }]
    assert_equal [{ value: 1, type: :numeric }],
                 stack
  end

  def test_negate
    stack = Rpn::Core::Operations.negate [{ value: -1, type: :numeric }]

    assert_equal [{ value: 1, type: :numeric }],
                 stack

    stack = Rpn::Core::Operations.negate [{ value: 1, type: :numeric }]

    assert_equal [{ value: -1, type: :numeric }],
                 stack
  end

  def test_multiply
    stack = Rpn::Core::Operations.multiply [{ value: 3, type: :numeric },
                                            { value: 4, type: :numeric }]
    assert_equal [{ value: 12, type: :numeric }],
                 stack
  end

  def test_divide
    stack = Rpn::Core::Operations.divide [{ value: 3.0, type: :numeric },
                                          { value: 4, type: :numeric }]
    assert_equal [{ value: 0.75, type: :numeric }],
                 stack

    # stack = Rpn::Core::Operations.divide [{ value: 3, type: :numeric },
    #                                       { value: 4, type: :numeric }]
    # assert_equal [{ value: 0.75, type: :numeric }],
    #              stack
  end

  def test_inverse
    stack = Rpn::Core::Operations.inverse [{ value: 4, type: :numeric }]
    assert_equal [{ value: 0.25, type: :numeric }],
                 stack
  end

  def test_power
    stack = Rpn::Core::Operations.power [{ value: 3, type: :numeric },
                                         { value: 4, type: :numeric }]
    assert_equal [{ value: 81, type: :numeric }],
                 stack
  end

  def test_sqrt
    stack = Rpn::Core::Operations.sqrt [{ value: 16, type: :numeric }]
    assert_equal [{ value: 4, type: :numeric }],
                 stack
  end

  def test_sq
    stack = Rpn::Core::Operations.sq [{ value: 4, type: :numeric }]
    assert_equal [{ value: 16, type: :numeric }],
                 stack
  end

  def test_abs
    stack = Rpn::Core::Operations.abs [{ value: -1, type: :numeric }]

    assert_equal [{ value: 1, type: :numeric }],
                 stack

    stack = Rpn::Core::Operations.abs [{ value: 1, type: :numeric }]

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
    stack = Rpn::Core::Operations.sign [{ value: -10, type: :numeric }]

    assert_equal [{ value: -1, type: :numeric }],
                 stack

    stack = Rpn::Core::Operations.sign [{ value: 10, type: :numeric }]

    assert_equal [{ value: 1, type: :numeric }],
                 stack
    stack = Rpn::Core::Operations.sign [{ value: 0, type: :numeric }]

    assert_equal [{ value: 0, type: :numeric }],
                 stack
  end
end
