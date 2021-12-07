# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TesttLanguageOperations < Test::Unit::TestCase
  def test_add
    stack, _dictionary = Rpl::Lang::Core.add [{ value: 1, type: :numeric, base: 10 },
                                              { value: 2, type: :numeric, base: 10 }],
                                             Rpl::Lang::Dictionary.new
    assert_equal [{ value: 3, type: :numeric, base: 10 }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.add [{ value: 1, type: :numeric, base: 10 },
                                              { value: '"a"', type: :string }],
                                             Rpl::Lang::Dictionary.new
    assert_equal [{ value: '"1a"', type: :string }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.add [{ value: 1, type: :numeric, base: 10 },
                                              { value: "'a'", type: :name }],
                                             Rpl::Lang::Dictionary.new
    assert_equal [{ value: '"1a"', type: :string }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.add [{ value: "'a'", type: :name },
                                              { value: 1, type: :numeric, base: 10 }],
                                             Rpl::Lang::Dictionary.new
    assert_equal [{ value: "'a1'", type: :name }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.add [{ value: "'a'", type: :name },
                                              { value: '"b"', type: :string }],
                                             Rpl::Lang::Dictionary.new
    assert_equal [{ value: "'ab'", type: :name }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.add [{ value: "'a'", type: :name },
                                              { value: "'b'", type: :name }],
                                             Rpl::Lang::Dictionary.new
    assert_equal [{ value: "'ab'", type: :name }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.add [{ value: '"a"', type: :string },
                                              { value: '"b"', type: :string }],
                                             Rpl::Lang::Dictionary.new
    assert_equal [{ value: '"ab"', type: :string }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.add [{ value: '"a"', type: :string },
                                              { value: "'b'", type: :name }],
                                             Rpl::Lang::Dictionary.new
    assert_equal [{ value: '"ab"', type: :string }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.add [{ value: '"a"', type: :string },
                                              { value: 1, type: :numeric, base: 10 }],
                                             Rpl::Lang::Dictionary.new
    assert_equal [{ value: '"a1"', type: :string }],
                 stack
  end

  def test_subtract
    stack, _dictionary = Rpl::Lang::Core.subtract [{ value: 1, type: :numeric, base: 10 },
                                                   { value: 2, type: :numeric, base: 10 }],
                                                  Rpl::Lang::Dictionary.new
    assert_equal [{ value: -1, type: :numeric, base: 10 }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.subtract [{ value: 2, type: :numeric, base: 10 },
                                                   { value: 1, type: :numeric, base: 10 }],
                                                  Rpl::Lang::Dictionary.new
    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_negate
    stack, _dictionary = Rpl::Lang::Core.negate [{ value: -1, type: :numeric, base: 10 }],
                                                Rpl::Lang::Dictionary.new

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.negate [{ value: 1, type: :numeric, base: 10 }],
                                                Rpl::Lang::Dictionary.new

    assert_equal [{ value: -1, type: :numeric, base: 10 }],
                 stack
  end

  def test_multiply
    stack, _dictionary = Rpl::Lang::Core.multiply [{ value: 3, type: :numeric, base: 10 },
                                                   { value: 4, type: :numeric, base: 10 }],
                                                  Rpl::Lang::Dictionary.new
    assert_equal [{ value: 12, type: :numeric, base: 10 }],
                 stack
  end

  def test_divide
    stack, _dictionary = Rpl::Lang::Core.divide [{ value: 3.0, type: :numeric, base: 10 },
                                                 { value: 4, type: :numeric, base: 10 }],
                                                Rpl::Lang::Dictionary.new
    assert_equal [{ value: 0.75, type: :numeric, base: 10 }],
                 stack

    # stack, _dictionary = Rpl::Lang::Core.divide [{ value: 3, type: :numeric, base: 10 },
    #                                       { value: 4, type: :numeric, base: 10 }]
    # assert_equal [{ value: 0.75, type: :numeric, base: 10 }],
    #              stack
  end

  def test_inverse
    stack, _dictionary = Rpl::Lang::Core.inverse [{ value: 4, type: :numeric, base: 10 }],
                                                 Rpl::Lang::Dictionary.new
    assert_equal [{ value: 0.25, type: :numeric, base: 10 }],
                 stack
  end

  def test_power
    stack, _dictionary = Rpl::Lang::Core.power [{ value: 3, type: :numeric, base: 10 },
                                                { value: 4, type: :numeric, base: 10 }],
                                               Rpl::Lang::Dictionary.new
    assert_equal [{ value: 81, type: :numeric, base: 10 }],
                 stack
  end

  def test_sqrt
    stack, _dictionary = Rpl::Lang::Core.sqrt [{ value: 16, type: :numeric, base: 10 }],
                                              Rpl::Lang::Dictionary.new
    assert_equal [{ value: 4, type: :numeric, base: 10 }],
                 stack
  end

  def test_sq
    stack, _dictionary = Rpl::Lang::Core.sq [{ value: 4, type: :numeric, base: 10 }],
                                            Rpl::Lang::Dictionary.new
    assert_equal [{ value: 16, type: :numeric, base: 10 }],
                 stack
  end

  def test_abs
    stack, _dictionary = Rpl::Lang::Core.abs [{ value: -1, type: :numeric, base: 10 }],
                                             Rpl::Lang::Dictionary.new

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.abs [{ value: 1, type: :numeric, base: 10 }],
                                             Rpl::Lang::Dictionary.new

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_dec
    stack, _dictionary = Rpl::Lang::Core.dec [{ value: 1, type: :numeric, base: 16 }],
                                             Rpl::Lang::Dictionary.new

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_hex
    stack, _dictionary = Rpl::Lang::Core.hex [{ value: 1, type: :numeric, base: 10 }],
                                             Rpl::Lang::Dictionary.new

    assert_equal [{ value: 1, type: :numeric, base: 16 }],
                 stack
  end

  def test_bin
    stack, _dictionary = Rpl::Lang::Core.bin [{ value: 1, type: :numeric, base: 10 }],
                                             Rpl::Lang::Dictionary.new

    assert_equal [{ value: 1, type: :numeric, base: 2 }],
                 stack
  end

  def test_base
    stack, _dictionary = Rpl::Lang::Core.base [{ value: 1, type: :numeric, base: 10 },
                                               { value: 31, type: :numeric, base: 10 }],
                                              Rpl::Lang::Dictionary.new

    assert_equal [{ value: 1, type: :numeric, base: 31 }],
                 stack
  end

  def test_sign
    stack, _dictionary = Rpl::Lang::Core.sign [{ value: -10, type: :numeric, base: 10 }],
                                              Rpl::Lang::Dictionary.new

    assert_equal [{ value: -1, type: :numeric, base: 10 }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.sign [{ value: 10, type: :numeric, base: 10 }],
                                              Rpl::Lang::Dictionary.new

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack
    stack, _dictionary = Rpl::Lang::Core.sign [{ value: 0, type: :numeric, base: 10 }],
                                              Rpl::Lang::Dictionary.new

    assert_equal [{ value: 0, type: :numeric, base: 10 }],
                 stack
  end

  def test_percent
    stack, _dictionary = Rpl::Lang::Core.percent [{ value: 2, type: :numeric, base: 10 },
                                                  { value: 33, type: :numeric, base: 10 }],
                                                 Rpl::Lang::Dictionary.new

    assert_equal [{ value: 0.66, type: :numeric, base: 10 }],
                 stack
  end

  def test_inverse_percent
    stack, _dictionary = Rpl::Lang::Core.inverse_percent [{ value: 2, type: :numeric, base: 10 },
                                                          { value: 0.66, type: :numeric, base: 10 }],
                                                         Rpl::Lang::Dictionary.new

    assert_equal [{ value: 33, type: :numeric, base: 10 }],
                 stack
  end

  def test_mod
    stack, _dictionary = Rpl::Lang::Core.mod [{ value: 9, type: :numeric, base: 10 },
                                              { value: 4, type: :numeric, base: 10 }],
                                             Rpl::Lang::Dictionary.new

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_fact
    stack, _dictionary = Rpl::Lang::Core.fact [{ value: 5, type: :numeric, base: 10 }],
                                              Rpl::Lang::Dictionary.new

    assert_equal [{ value: 24, type: :numeric, base: 10 }],
                 stack
  end

  def test_floor
    stack, _dictionary = Rpl::Lang::Core.floor [{ value: 5.23, type: :numeric, base: 10 }],
                                               Rpl::Lang::Dictionary.new

    assert_equal [{ value: 5, type: :numeric, base: 10 }],
                 stack
  end

  def test_ceil
    stack, _dictionary = Rpl::Lang::Core.ceil [{ value: 5.23, type: :numeric, base: 10 }],
                                              Rpl::Lang::Dictionary.new

    assert_equal [{ value: 6, type: :numeric, base: 10 }],
                 stack
  end

  def test_min
    stack, _dictionary = Rpl::Lang::Core.min [{ value: 1, type: :numeric, base: 10 },
                                              { value: 2, type: :numeric, base: 10 }],
                                             Rpl::Lang::Dictionary.new

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.min [{ value: 2, type: :numeric, base: 10 },
                                              { value: 1, type: :numeric, base: 10 }],
                                             Rpl::Lang::Dictionary.new

    assert_equal [{ value: 1, type: :numeric, base: 10 }],
                 stack
  end

  def test_max
    stack, _dictionary = Rpl::Lang::Core.max [{ value: 1, type: :numeric, base: 10 },
                                              { value: 2, type: :numeric, base: 10 }],
                                             Rpl::Lang::Dictionary.new

    assert_equal [{ value: 2, type: :numeric, base: 10 }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.max [{ value: 2, type: :numeric, base: 10 },
                                              { value: 1, type: :numeric, base: 10 }],
                                             Rpl::Lang::Dictionary.new

    assert_equal [{ value: 2, type: :numeric, base: 10 }],
                 stack
  end
end
