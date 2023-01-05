# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestLanguageBranch < MiniTest::Test
  include Types

  def test_loop
    interpreter = Rpl.new
    interpreter.run! '« "hello no." swap + » 11 16 loop'

    assert_equal [Types.new_object( RplString, '"hello no.11"' ),
                  Types.new_object( RplString, '"hello no.12"' ),
                  Types.new_object( RplString, '"hello no.13"' ),
                  Types.new_object( RplString, '"hello no.14"' ),
                  Types.new_object( RplString, '"hello no.15"' ),
                  Types.new_object( RplString, '"hello no.16"' )],
                 interpreter.stack
  end

  def test_times
    interpreter = Rpl.new
    interpreter.run! '« "hello no." swap + » 5 times'

    assert_equal [Types.new_object( RplString, '"hello no.0"' ),
                  Types.new_object( RplString, '"hello no.1"' ),
                  Types.new_object( RplString, '"hello no.2"' ),
                  Types.new_object( RplString, '"hello no.3"' ),
                  Types.new_object( RplString, '"hello no.4"' )],
                 interpreter.stack
  end

  def test_ifte
    interpreter = Rpl.new
    interpreter.run! 'true « 2 3 + » « 2 3 - » ifte'

    assert_equal [Types.new_object( RplNumeric, 5 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run! 'false « 2 3 + » « 2 3 - » ifte'

    assert_equal [Types.new_object( RplNumeric, -1 )],
                 interpreter.stack
  end

  def test_ift
    interpreter = Rpl.new
    interpreter.run! 'true « 2 3 + » ift'

    assert_equal [Types.new_object( RplNumeric, 5 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run! 'false « 2 3 + » ift'

    assert_equal [],
                 interpreter.stack
  end
end
