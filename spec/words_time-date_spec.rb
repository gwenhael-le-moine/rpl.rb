# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestLanguageTimeDate < MiniTest::Test
  include Types

  def test_time
    now = Time.now.to_s.split[1]
    interpreter = Rpl.new
    interpreter.run! 'time'

    assert_equal [Types.new_object( RplString, "\"#{now}\"" )],
                 interpreter.stack
  end

  def test_date
    now = Date.today.to_s
    interpreter = Rpl.new
    interpreter.run! 'date'

    assert_equal [Types.new_object( RplString, "\"#{now}\"" )],
                 interpreter.stack
  end

  def test_ticks
    interpreter = Rpl.new
    interpreter.run! 'ticks'

    # TODO: better test, but how?
    assert_equal RplNumeric,
                 interpreter.stack[0].class
  end
end
