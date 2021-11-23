# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../lib/core'

class TestLanguageTimeDate < Test::Unit::TestCase
  def test_time
    now = Time.now.to_s
    stack = Rpl::Core.time( [] )

    assert_equal [{ value: now, type: :string }],
                 stack
  end

  def test_date
    now = Date.today.to_s
    stack = Rpl::Core.date( [] )

    assert_equal [{ value: now, type: :string }],
                 stack
  end

  def test_ticks
    stack = Rpl::Core.ticks( [] )

    # TODO: better test, but how?
    assert_equal :numeric,
                 stack[0][:type]
  end
end
