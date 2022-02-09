# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../interpreter'

class TestLanguageTest < Test::Unit::TestCase
  def test_greater_than
    interpreter = Rpl::Interpreter.new
    interpreter.run '0 0.1 >'

    assert_equal [{ value: false, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run '0.1 0 >'

    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run '1 1 >'

    assert_equal [{ value: false, type: :boolean }],
                 interpreter.stack
  end

  def test_greater_than_or_equal
    interpreter = Rpl::Interpreter.new
    interpreter.run '0 0.1 >='

    assert_equal [{ value: false, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run '0.1 0 ≥'

    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run '1 1 ≥'

    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack
  end

  def test_less_than
    interpreter = Rpl::Interpreter.new
    interpreter.run '0 0.1 <'

    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run '0.1 0 <'

    assert_equal [{ value: false, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run '1 1 <'

    assert_equal [{ value: false, type: :boolean }],
                 interpreter.stack
  end

  def test_less_than_or_equal
    interpreter = Rpl::Interpreter.new
    interpreter.run '0 0.1 <='

    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run '0.1 0 ≤'

    assert_equal [{ value: false, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run '1 1 ≤'

    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack
  end

  def test_different
    interpreter = Rpl::Interpreter.new
    interpreter.run '1 1 !='

    assert_equal [{ value: false, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run '1 2 ≠'

    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack
  end

  def test_and
    interpreter = Rpl::Interpreter.new
    interpreter.run 'true true and'

    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run 'false false and'

    assert_equal [{ value: false, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run 'true false and'

    assert_equal [{ value: false, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run 'false true and'

    assert_equal [{ value: false, type: :boolean }],
                 interpreter.stack
  end

  def test_or
    interpreter = Rpl::Interpreter.new
    interpreter.run 'true true or'

    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run 'false false or'

    assert_equal [{ value: false, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run 'true false or'

    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run 'false true or'

    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack
  end

  def test_xor
    interpreter = Rpl::Interpreter.new
    interpreter.run 'true true xor'

    assert_equal [{ value: false, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run 'false false xor'

    assert_equal [{ value: false, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run 'true false xor'

    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run 'false true xor'

    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack
  end

  def test_not
    interpreter = Rpl::Interpreter.new
    interpreter.run 'true not'

    assert_equal [{ value: false, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run 'false not'

    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack
  end

  def test_same
    interpreter = Rpl::Interpreter.new
    interpreter.run '1 1 same'

    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run '1 2 =='

    assert_equal [{ value: false, type: :boolean }],
                 interpreter.stack
  end

  def test_true
    interpreter = Rpl::Interpreter.new
    interpreter.run 'true'

    assert_equal [{ value: true, type: :boolean }],
                 interpreter.stack
  end

  def test_false
    interpreter = Rpl::Interpreter.new
    interpreter.run 'false'

    assert_equal [{ value: false, type: :boolean }],
                 interpreter.stack
  end
end
