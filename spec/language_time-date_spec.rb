# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TestLanguageTimeDate < Test::Unit::TestCase
  def test_time
    now = Time.now.to_s
    stack, _dictionary = Rpl::Lang::Core.time( [],
                                               Rpl::Lang::Dictionary.new )

    assert_equal [{ value: now, type: :string }],
                 stack
  end

  def test_date
    now = Date.today.to_s
    stack, _dictionary = Rpl::Lang::Core.date( [],
                                               Rpl::Lang::Dictionary.new )

    assert_equal [{ value: now, type: :string }],
                 stack
  end

  def test_ticks
    stack, _dictionary = Rpl::Lang::Core.ticks( [],
                                                Rpl::Lang::Dictionary.new )

    # TODO: better test, but how?
    assert_equal :numeric,
                 stack[0][:type]
  end
end
