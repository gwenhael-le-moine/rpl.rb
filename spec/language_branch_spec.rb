# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TestLanguageBranch < Test::Unit::TestCase
  def test_loop
    lang = Rpl::Language.new
    lang.run '11 16 « "hello no." swap + » loop'

    assert_equal [{ value: 'hello no.11', type: :string },
                  { value: 'hello no.12', type: :string },
                  { value: 'hello no.13', type: :string },
                  { value: 'hello no.14', type: :string },
                  { value: 'hello no.15', type: :string },
                  { value: 'hello no.16', type: :string }],
                 lang.stack
  end

  def test_times
    lang = Rpl::Language.new
    lang.run '5 « "hello no." swap + » times'

    assert_equal [{ value: 'hello no.0', type: :string },
                  { value: 'hello no.1', type: :string },
                  { value: 'hello no.2', type: :string },
                  { value: 'hello no.3', type: :string },
                  { value: 'hello no.4', type: :string }],
                 lang.stack
  end

  def test_ifte
    lang = Rpl::Language.new
    lang.run 'true « 2 3 + » « 2 3 - » ifte'

    assert_equal [{ value: 5, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run 'false « 2 3 + » « 2 3 - » ifte'

    assert_equal [{ value: -1, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_ift
    lang = Rpl::Language.new
    lang.run 'true « 2 3 + » ift'

    assert_equal [{ value: 5, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run 'false « 2 3 + » ift'

    assert_equal [],
                 lang.stack
  end
end
