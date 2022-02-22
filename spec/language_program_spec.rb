# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestLanguageProgram < MiniTest::Test
  def test_eval
    interpreter = Rpl.new
    interpreter.run '« 2 dup * dup » eval'

    assert_equal [{ value: 4, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '4 \'dup\' eval'

    assert_equal [{ value: 4, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '4
 \'dup\'
eval'

    assert_equal [{ value: 4, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 interpreter.stack
  end
end
