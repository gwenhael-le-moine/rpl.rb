# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../lib/core'

class TestLanguageString < Test::Unit::TestCase
  def test_sub
    stack = Rpl::Core.sub( [{ value: 'test', type: :string },
                            { value: 1, type: :numeric, base: 10 },
                            { value: 2, type: :numeric, base: 10 }] )

    assert_equal [{ value: 'es', type: :string }],
                 stack
  end
end
