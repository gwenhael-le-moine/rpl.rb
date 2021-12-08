# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TestLanguageProgram < Test::Unit::TestCase
  def test_eval
    lang = Rpl::Language.new
    lang.run '« 2 dup * dup » eval'

    assert_equal [{ value: 4, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '4 \'dup\' eval'

    assert_equal [{ value: 4, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 lang.stack
  end
end
