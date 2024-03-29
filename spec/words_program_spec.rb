# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestLanguageProgram < Minitest::Test
  include Types

  def test_eval
    interpreter = Rpl.new
    interpreter.run! '« 2 dup * dup » eval'

    assert_equal [Types.new_object( RplNumeric, 4 ),
                  Types.new_object( RplNumeric, 4 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run! '4 \'dup\' eval'

    assert_equal [Types.new_object( RplNumeric, 4 ),
                  Types.new_object( RplNumeric, 4 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run! '4
 \'dup\'
eval'

    assert_equal [Types.new_object( RplNumeric, 4 ),
                  Types.new_object( RplNumeric, 4 )],
                 interpreter.stack
  end
end
