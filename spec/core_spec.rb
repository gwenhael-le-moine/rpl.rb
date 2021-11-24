# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../lib/core'

class TestParser < Test::Unit::TestCase
  def test_stack_extract
    stack, args = Rpl::Core.stack_extract [{ value: 1, type: :numeric },
                                           { value: 2, type: :numeric }],
                                          [:any]
    assert_equal [{ value: 1, type: :numeric }],
                 stack
    assert_equal [{ value: 2, type: :numeric }],
                 args

    stack, args = Rpl::Core.stack_extract [{ value: 1, type: :numeric },
                                           { value: 2, type: :numeric }],
                                          [:any, [:numeric]]
    assert_equal [],
                 stack
    assert_equal [{ value: 1, type: :numeric },
                  { value: 2, type: :numeric }],
                 args
  end
end
