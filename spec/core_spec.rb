# frozen_string_literal: true

require 'test/unit'

require_relative '../interpreter'

class TestParser < Test::Unit::TestCase
  def test_stack_extract
    interpreter = Rpl::Interpreter.new( [{ value: 1, type: :numeric },
                                         { value: 2, type: :numeric }] )
    args = interpreter.stack_extract [:any]
    assert_equal [{ value: 1, type: :numeric }],
                 interpreter.stack
    assert_equal [{ value: 2, type: :numeric }],
                 args

    interpreter = Rpl::Interpreter.new( [{ value: 'test', type: :string },
                                         { value: 2, type: :numeric }] )
    args = interpreter.stack_extract [[:numeric], :any]
    assert_equal [],
                 interpreter.stack
    assert_equal [{ value: 2, type: :numeric },
                  { value: 'test', type: :string }],
                 args
  end

  def test_stringify
    assert_equal '∞',
                 Rpl::Interpreter.new.stringify( { value: Float::INFINITY,
                                                   base: 10,
                                                   type: :numeric } )
  end
end
