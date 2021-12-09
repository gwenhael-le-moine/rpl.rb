# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TestLanguageTest < Test::Unit::TestCase

  def test_greater_than
    lang = Rpl::Language.new
    lang.run '0 0.1 >'

    assert_equal [{ value: false, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '0.1 0 >'

    assert_equal [{ value: true, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '1 1 >'

    assert_equal [{ value: false, type: :boolean }],
                 lang.stack
  end

  def test_greater_than_or_equal
    lang = Rpl::Language.new
    lang.run '0 0.1 >='

    assert_equal [{ value: false, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '0.1 0 ≥'

    assert_equal [{ value: true, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '1 1 ≥'

    assert_equal [{ value: true, type: :boolean }],
                 lang.stack
  end

  def test_less_than
    lang = Rpl::Language.new
    lang.run '0 0.1 <'

    assert_equal [{ value: true, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '0.1 0 <'

    assert_equal [{ value: false, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '1 1 <'

    assert_equal [{ value: false, type: :boolean }],
                 lang.stack
  end

  def test_less_than_or_equal
    lang = Rpl::Language.new
    lang.run '0 0.1 <='

    assert_equal [{ value: true, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '0.1 0 ≤'

    assert_equal [{ value: false, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '1 1 ≤'

    assert_equal [{ value: true, type: :boolean }],
                 lang.stack
  end

  def test_different
    lang = Rpl::Language.new
    lang.run '1 1 !='

    assert_equal [{ value: false, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '1 2 !='

    assert_equal [{ value: true, type: :boolean }],
                 lang.stack
  end

  def test_and
    lang = Rpl::Language.new
    lang.run 'true true and'

    assert_equal [{ value: true, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run 'false false and'

    assert_equal [{ value: false, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run 'true false and'

    assert_equal [{ value: false, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run 'false true and'

    assert_equal [{ value: false, type: :boolean }],
                 lang.stack
  end

  def test_or
    lang = Rpl::Language.new
    lang.run 'true true or'

    assert_equal [{ value: true, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run 'false false or'

    assert_equal [{ value: false, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run 'true false or'

    assert_equal [{ value: true, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run 'false true or'

    assert_equal [{ value: true, type: :boolean }],
                 lang.stack
  end

  def test_xor
    lang = Rpl::Language.new
    lang.run 'true true xor'

    assert_equal [{ value: false, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run 'false false xor'

    assert_equal [{ value: false, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run 'true false xor'

    assert_equal [{ value: true, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run 'false true xor'

    assert_equal [{ value: true, type: :boolean }],
                 lang.stack
  end

  def test_not
    lang = Rpl::Language.new
    lang.run 'true not'

    assert_equal [{ value: false, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run 'false not'

    assert_equal [{ value: true, type: :boolean }],
                 lang.stack
  end

  def test_same
    lang = Rpl::Language.new
    lang.run '1 1 same'

    assert_equal [{ value: true, type: :boolean }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '1 2 =='

    assert_equal [{ value: false, type: :boolean }],
                 lang.stack
  end

  def test_true
    lang = Rpl::Language.new
    lang.run 'true'

    assert_equal [{ value: true, type: :boolean }],
                 lang.stack
  end

  def test_false
    lang = Rpl::Language.new
    lang.run 'false'

    assert_equal [{ value: false, type: :boolean }],
                 lang.stack
  end
end
