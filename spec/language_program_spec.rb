# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TestLanguageProgram < Test::Unit::TestCase
  def test_eval
    stack, _dictionary = Rpl::Lang::Core.eval( [{ value: '« 2 dup * dup »', type: :program }], Rpl::Lang::Dictionary.new )

    assert_equal [{ value: 4, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.eval( [{ value: 4, type: :numeric, base: 10 },
                                                { value: "'dup'", type: :name }], Rpl::Lang::Dictionary.new )

    assert_equal [{ value: 4, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 stack

    stack, _dictionary = Rpl::Lang::Core.eval( [{ value: 4, type: :numeric, base: 10 },
                                                { value: 'dup', type: :word }], Rpl::Lang::Dictionary.new )

    assert_equal [{ value: 4, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 stack
  end
end
