# coding: utf-8
# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestLanguageBranch < MiniTest::Test
  include Types

  def test_loop
    interpreter = Rpl.new
    interpreter.run '« "hello no." swap + » 11 16 loop'

    assert_equal [RplString.new( '"hello no.11"' ),
                  RplString.new( '"hello no.12"' ),
                  RplString.new( '"hello no.13"' ),
                  RplString.new( '"hello no.14"' ),
                  RplString.new( '"hello no.15"' ),
                  RplString.new( '"hello no.16"' )],
                 interpreter.stack
  end

  def test_times
    interpreter = Rpl.new
    interpreter.run '« "hello no." swap + » 5 times'

    assert_equal [RplString.new( '"hello no.0"' ),
                  RplString.new( '"hello no.1"' ),
                  RplString.new( '"hello no.2"' ),
                  RplString.new( '"hello no.3"' ),
                  RplString.new( '"hello no.4"' )],
                 interpreter.stack
  end

  def test_ifte
    interpreter = Rpl.new
    interpreter.run 'true « 2 3 + » « 2 3 - » ifte'

    assert_equal [RplNumeric.new( 5 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run 'false « 2 3 + » « 2 3 - » ifte'

    assert_equal [RplNumeric.new( -1 )],
                 interpreter.stack
  end

  def test_ift
    interpreter = Rpl.new
    interpreter.run 'true « 2 3 + » ift'

    assert_equal [RplNumeric.new( 5 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run 'false « 2 3 + » ift'

    assert_equal [],
                 interpreter.stack
  end
end
