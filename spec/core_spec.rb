# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestParser < MiniTest::Test
  include Types

  def test_stack_extract
    interpreter = Rpl.new
    interpreter.run '1 2'
    args = interpreter.stack_extract [:any]
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack
    assert_equal [Types.new_object( RplNumeric, 2 )],
                 args

    interpreter = Rpl.new
    interpreter.run '"test" 2'
    args = interpreter.stack_extract [[RplNumeric], :any]
    assert_equal [],
                 interpreter.stack
    assert_equal [Types.new_object( RplNumeric, 2 ),
                  Types.new_object( RplString, '"test"' )],
                 args
  end
end
