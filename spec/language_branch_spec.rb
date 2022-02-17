# coding: utf-8
# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestLanguageBranch < MiniTest::Test
  def test_loop
    interpreter = Rpl.new
    interpreter.run '« "hello no." swap + » 11 16 loop'

    assert_equal [{ value: 'hello no.11', type: :string },
                  { value: 'hello no.12', type: :string },
                  { value: 'hello no.13', type: :string },
                  { value: 'hello no.14', type: :string },
                  { value: 'hello no.15', type: :string },
                  { value: 'hello no.16', type: :string }],
                 interpreter.stack
  end

  def test_times
    interpreter = Rpl.new
    interpreter.run '« "hello no." swap + » 5 times'

    assert_equal [{ value: 'hello no.0', type: :string },
                  { value: 'hello no.1', type: :string },
                  { value: 'hello no.2', type: :string },
                  { value: 'hello no.3', type: :string },
                  { value: 'hello no.4', type: :string }],
                 interpreter.stack
  end

  def test_ifte
    interpreter = Rpl.new
    interpreter.run 'true « 2 3 + » « 2 3 - » ifte'

    assert_equal [{ value: 5, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run 'false « 2 3 + » « 2 3 - » ifte'

    assert_equal [{ value: -1, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_ift
    interpreter = Rpl.new
    interpreter.run 'true « 2 3 + » ift'

    assert_equal [{ value: 5, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run 'false « 2 3 + » ift'

    assert_equal [],
                 interpreter.stack
  end
end
