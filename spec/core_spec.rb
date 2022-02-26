# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestParser < MiniTest::Test
  include Types

  def test_stack_extract
    interpreter = Rpl.new
    interpreter.run '1 2'
    args = interpreter.stack_extract [:any]
    assert_equal [RplNumeric.new( 1 )],
                 interpreter.stack
    assert_equal [RplNumeric.new( 2 )],
                 args

    interpreter = Rpl.new
    interpreter.run '"test" 2'
    args = interpreter.stack_extract [[RplNumeric], :any]
    assert_equal [],
                 interpreter.stack
    assert_equal [RplNumeric.new( 2 ),
                  RplString.new( '"test"' )],
                 args
  end
end
