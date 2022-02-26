# coding: utf-8
# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestLanguageStack < MiniTest::Test
  include Types

  def test_swap
    interpreter = Rpl.new
    interpreter.run '1 2 swap'

    assert_equal [RplNumeric.new( 2 ),
                  RplNumeric.new( 1 )],
                 interpreter.stack
  end

  def test_drop
    interpreter = Rpl.new
    interpreter.run '1 2 drop'

    assert_equal [RplNumeric.new( 1 )],
                 interpreter.stack
  end

  def test_drop2
    interpreter = Rpl.new
    interpreter.run '1 2 drop2'

    assert_equal [],
                 interpreter.stack
  end

  def test_dropn
    interpreter = Rpl.new
    interpreter.run '1 2 3 4 3 dropn'

    assert_equal [RplNumeric.new( 1 )],
                 interpreter.stack
  end

  def test_del
    interpreter = Rpl.new
    interpreter.run '1 2 del'

    assert_empty interpreter.stack
  end

  def test_rot
    interpreter = Rpl.new
    interpreter.run '1 2 3 rot'

    assert_equal [RplNumeric.new( 2 ),
                  RplNumeric.new( 3 ),
                  RplNumeric.new( 1 )],
                 interpreter.stack
  end

  def test_dup
    interpreter = Rpl.new
    interpreter.run '1 2 dup'

    assert_equal [RplNumeric.new( 1 ),
                  RplNumeric.new( 2 ),
                  RplNumeric.new( 2 )],
                 interpreter.stack
  end

  def test_dup2
    interpreter = Rpl.new
    interpreter.run '1 2 dup2'

    assert_equal [RplNumeric.new( 1 ),
                  RplNumeric.new( 2 ),
                  RplNumeric.new( 1 ),
                  RplNumeric.new( 2 )],
                 interpreter.stack
  end

  def test_dupn
    interpreter = Rpl.new
    interpreter.run '1 2 3 4 3 dupn'

    assert_equal [RplNumeric.new( 1 ),
                  RplNumeric.new( 2 ),
                  RplNumeric.new( 3 ),
                  RplNumeric.new( 4 ),
                  RplNumeric.new( 2 ),
                  RplNumeric.new( 3 ),
                  RplNumeric.new( 4 )],
                 interpreter.stack
  end

  def test_pick
    interpreter = Rpl.new
    interpreter.run '1 2 3 4 3 pick'

    assert_equal [RplNumeric.new( 1 ),
                  RplNumeric.new( 2 ),
                  RplNumeric.new( 3 ),
                  RplNumeric.new( 4 ),
                  RplNumeric.new( 2 )],
                 interpreter.stack
  end

  def test_depth
    interpreter = Rpl.new
    interpreter.run 'depth'

    assert_equal [RplNumeric.new( 0 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 2 depth'

    assert_equal [RplNumeric.new( 1 ),
                  RplNumeric.new( 2 ),
                  RplNumeric.new( 2 )],
                 interpreter.stack
  end

  def test_roll
    interpreter = Rpl.new
    interpreter.run '1 2 3 4 3 roll'

    assert_equal [RplNumeric.new( 1 ),
                  RplNumeric.new( 3 ),
                  RplNumeric.new( 4 ),
                  RplNumeric.new( 2 )],
                 interpreter.stack
  end

  def test_rolld
    interpreter = Rpl.new
    interpreter.run '1 2 4 3 2 rolld'

    assert_equal [RplNumeric.new( 1 ),
                  RplNumeric.new( 2 ),
                  RplNumeric.new( 3 ),
                  RplNumeric.new( 4 )],
                 interpreter.stack
  end

  def test_over
    interpreter = Rpl.new
    interpreter.run '1 2 3 4 over'

    assert_equal [RplNumeric.new( 1 ),
                  RplNumeric.new( 2 ),
                  RplNumeric.new( 3 ),
                  RplNumeric.new( 4 ),
                  RplNumeric.new( 3 )],
                 interpreter.stack
  end
end
