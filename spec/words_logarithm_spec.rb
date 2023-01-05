# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'
require 'rpl/types'

class TesttLanguageLogarithm < MiniTest::Test
  include Types

  def test_e
    interpreter = Rpl.new
    interpreter.run! 'e'
    assert_equal [Types.new_object( RplNumeric, BigMath.E( RplNumeric.precision ) )],
                 interpreter.stack
  end
end
