# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TestLanguageTimeDate < Test::Unit::TestCase
  def test_time
    now = Time.now.to_s
    lang = Rpl::Language.new
    lang.run 'time'

    assert_equal [{ value: "\"#{now}\"", type: :string }],
                 lang.stack
  end

  def test_date
    now = Date.today.to_s
    lang = Rpl::Language.new
    lang.run 'date'

    assert_equal [{ value: "\"#{now}\"", type: :string }],
                 lang.stack
  end

  def test_ticks
    lang = Rpl::Language.new
    lang.run 'ticks'

    # TODO: better test, but how?
    assert_equal :numeric,
                 lang.stack[0][:type]
  end
end
