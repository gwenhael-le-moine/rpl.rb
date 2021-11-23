# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../lib/core'

class TesttLanguageOperations < Test::Unit::TestCase
  def test_add
    stack = Rpn::Core::Operations.add [{ value: 1, type: :numeric },
                                       { value: 2, type: :numeric }]
    assert_equal [{ value: 3, type: :numeric }],
                 stack

    stack = Rpn::Core::Operations.add [{ value: 1, type: :numeric },
                                       { value: '"a"', type: :string }]
    assert_equal [{ value: '"1a"', type: :string }],
                 stack

    stack = Rpn::Core::Operations.add [{ value: 1, type: :numeric },
                                       { value: "'a'", type: :name }]
    assert_equal [{ value: '"1a"', type: :string }],
                 stack

    stack = Rpn::Core::Operations.add [{ value: "'a'", type: :name },
                                       { value: 1, type: :numeric }]
    assert_equal [{ value: "'a1'", type: :name }],
                 stack

    stack = Rpn::Core::Operations.add [{ value: "'a'", type: :name },
                                       { value: '"b"', type: :string }]
    assert_equal [{ value: "'ab'", type: :name }],
                 stack

    stack = Rpn::Core::Operations.add [{ value: "'a'", type: :name },
                                       { value: "'b'", type: :name }]
    assert_equal [{ value: "'ab'", type: :name }],
                 stack

    stack = Rpn::Core::Operations.add [{ value: '"a"', type: :string },
                                       { value: '"b"', type: :string }]
    assert_equal [{ value: '"ab"', type: :string }],
                 stack

    stack = Rpn::Core::Operations.add [{ value: '"a"', type: :string },
                                       { value: "'b'", type: :name }]
    assert_equal [{ value: '"ab"', type: :string }],
                 stack

    stack = Rpn::Core::Operations.add [{ value: '"a"', type: :string },
                                       { value: 1, type: :numeric }]
    assert_equal [{ value: '"a1"', type: :string }],
                 stack
  end
end
