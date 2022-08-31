# coding: utf-8
# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestLanguageTest < MiniTest::Test
  include Types

  def test_greater_than
    interpreter = Rpl.new
    interpreter.run '0 0.1 >'

    assert_equal [Types.new_object( RplBoolean, false )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '0.1 0 >'

    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 1 >'

    assert_equal [Types.new_object( RplBoolean, false )],
                 interpreter.stack
  end

  def test_greater_than_or_equal
    interpreter = Rpl.new
    interpreter.run '0 0.1 >='

    assert_equal [Types.new_object( RplBoolean, false )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '0.1 0 ≥'

    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 1 ≥'

    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack
  end

  def test_less_than
    interpreter = Rpl.new
    interpreter.run '0 0.1 <'

    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '0.1 0 <'

    assert_equal [Types.new_object( RplBoolean, false )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 1 <'

    assert_equal [Types.new_object( RplBoolean, false )],
                 interpreter.stack
  end

  def test_less_than_or_equal
    interpreter = Rpl.new
    interpreter.run '0 0.1 <='

    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '0.1 0 ≤'

    assert_equal [Types.new_object( RplBoolean, false )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 1 ≤'

    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack
  end

  def test_different
    interpreter = Rpl.new
    interpreter.run '1 1 !='

    assert_equal [Types.new_object( RplBoolean, false )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 2 ≠'

    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack
  end

  def test_and
    interpreter = Rpl.new
    interpreter.run 'true true and'

    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run 'false false and'

    assert_equal [Types.new_object( RplBoolean, false )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run 'true false and'

    assert_equal [Types.new_object( RplBoolean, false )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run 'false true and'

    assert_equal [Types.new_object( RplBoolean, false )],
                 interpreter.stack
  end

  def test_or
    interpreter = Rpl.new
    interpreter.run 'true true or'

    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run 'false false or'

    assert_equal [Types.new_object( RplBoolean, false )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run 'true false or'

    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run 'false true or'

    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack
  end

  def test_xor
    interpreter = Rpl.new
    interpreter.run 'true true xor'

    assert_equal [Types.new_object( RplBoolean, false )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run 'false false xor'

    assert_equal [Types.new_object( RplBoolean, false )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run 'true false xor'

    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run 'false true xor'

    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack
  end

  def test_not
    interpreter = Rpl.new
    interpreter.run 'true not'

    assert_equal [Types.new_object( RplBoolean, false )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run 'false not'

    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack
  end

  def test_same
    interpreter = Rpl.new
    interpreter.run '1 1 same'

    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 2 =='

    assert_equal [Types.new_object( RplBoolean, false )],
                 interpreter.stack
  end

  def test_true
    interpreter = Rpl.new
    interpreter.run 'true'

    assert_equal [Types.new_object( RplBoolean, true )],
                 interpreter.stack
  end

  def test_false
    interpreter = Rpl.new
    interpreter.run 'false'

    assert_equal [Types.new_object( RplBoolean, false )],
                 interpreter.stack
  end
end
