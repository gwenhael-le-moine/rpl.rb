# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TestLanguageBranch < Test::Unit::TestCase
  def test_ifte
    stack, _dictionary = Rpl::Lang::Core.ifte( [{ type: :boolean, value: true },
                                                { type: :program, value: '« 2 3 + »' },
                                                { type: :program, value: '« 2 3 - »' }],
                                               Rpl::Lang::Dictionary.new )

    assert_equal [{ value: 5, type: :numeric, base: 10 }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.ifte( [{ type: :boolean, value: false },
                                                { type: :program, value: '« 2 3 + »' },
                                                { type: :program, value: '« 2 3 - »' }],
                                               Rpl::Lang::Dictionary.new )

    assert_equal [{ value: -1, type: :numeric, base: 10 }],
                 stack
  end
end
