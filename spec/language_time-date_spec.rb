# coding: utf-8
# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestLanguageTimeDate < MiniTest::Test
  def test_time
    now = Time.now.to_s
    interpreter = Rpl.new
    interpreter.run 'time'

    assert_equal [{ value: now, type: :string }],
                 interpreter.stack
  end

  def test_date
    now = Date.today.to_s
    interpreter = Rpl.new
    interpreter.run 'date'

    assert_equal [{ value: now, type: :string }],
                 interpreter.stack
  end

  def test_ticks
    interpreter = Rpl.new
    interpreter.run 'ticks'

    # TODO: better test, but how?
    assert_equal :numeric,
                 interpreter.stack[0][:type]
  end
end
