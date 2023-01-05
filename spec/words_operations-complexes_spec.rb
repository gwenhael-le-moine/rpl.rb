# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TesttLanguageOperationsComplexes < MiniTest::Test
  include Types

  def test_re
    interpreter = Rpl.new
    interpreter.run! '(2+3i) re'
    assert_equal [Types.new_object( RplNumeric, 2 )],
                 interpreter.stack
  end

  def test_im
    interpreter = Rpl.new
    interpreter.run! '(2+3i) im'
    assert_equal [Types.new_object( RplNumeric, 3 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run! '(2-4i) im'
    assert_equal [Types.new_object( RplNumeric, -4 )],
                 interpreter.stack
  end

  def test_conj
    interpreter = Rpl.new
    interpreter.run! '(2+3i) conj'
    assert_equal [Types.new_object( RplComplex, Complex( 2, -3 ) )],
                 interpreter.stack
  end

  def test_arg
    interpreter = Rpl.new
    interpreter.run! '(2+3i) arg'
    assert_equal [Types.new_object( RplNumeric, 0.982793723247329 )],
                 interpreter.stack
  end

  def test_c2r
    interpreter = Rpl.new
    interpreter.run! '(2+3i) c→r'
    assert_equal [Types.new_object( RplNumeric, 2 ),
                  Types.new_object( RplNumeric, 3 )],
                 interpreter.stack
  end

  def test_r2c
    interpreter = Rpl.new
    interpreter.run! '2 -3 r→c'
    assert_equal [Types.new_object( RplComplex, Complex( 2, -3 ) )],
                 interpreter.stack
  end
end
