# frozen_string_literal: true

require 'test/unit'

require_relative '../interpreter'

class TestLanguageProgram < Test::Unit::TestCase
  def test_eval
    interpreter = Rpl::Interpreter.new
    interpreter.run '« 2 dup * dup » eval'

    assert_equal [{ value: 4, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl::Interpreter.new
    interpreter.run '4 \'dup\' eval'

    assert_equal [{ value: 4, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 interpreter.stack
  end
end
