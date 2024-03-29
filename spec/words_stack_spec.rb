# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestLanguageStack < Minitest::Test
  include Types

  def test_swap
    interpreter = Rpl.new
    interpreter.run! '1 2 swap'

    assert_equal [Types.new_object( RplNumeric, 2 ),
                  Types.new_object( RplNumeric, 1 )],
                 interpreter.stack
  end

  def test_drop
    interpreter = Rpl.new
    interpreter.run! '1 2 drop'

    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack
  end

  def test_drop2
    interpreter = Rpl.new
    interpreter.run! '1 2 drop2'

    assert_equal [],
                 interpreter.stack
  end

  def test_dropn
    interpreter = Rpl.new
    interpreter.run! '1 2 3 4 3 dropn'

    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack
  end

  def test_del
    interpreter = Rpl.new
    interpreter.run! '1 2 del'

    assert_empty interpreter.stack
  end

  def test_rot
    interpreter = Rpl.new
    interpreter.run! '1 2 3 rot'

    assert_equal [Types.new_object( RplNumeric, 2 ),
                  Types.new_object( RplNumeric, 3 ),
                  Types.new_object( RplNumeric, 1 )],
                 interpreter.stack
  end

  def test_dup
    interpreter = Rpl.new
    interpreter.run! '1 2 dup'

    assert_equal [Types.new_object( RplNumeric, 1 ),
                  Types.new_object( RplNumeric, 2 ),
                  Types.new_object( RplNumeric, 2 )],
                 interpreter.stack
  end

  def test_dup2
    interpreter = Rpl.new
    interpreter.run! '1 2 dup2'

    assert_equal [Types.new_object( RplNumeric, 1 ),
                  Types.new_object( RplNumeric, 2 ),
                  Types.new_object( RplNumeric, 1 ),
                  Types.new_object( RplNumeric, 2 )],
                 interpreter.stack
  end

  def test_dupn
    interpreter = Rpl.new
    interpreter.run! '1 2 3 4 3 dupn'

    assert_equal [Types.new_object( RplNumeric, 1 ),
                  Types.new_object( RplNumeric, 2 ),
                  Types.new_object( RplNumeric, 3 ),
                  Types.new_object( RplNumeric, 4 ),
                  Types.new_object( RplNumeric, 2 ),
                  Types.new_object( RplNumeric, 3 ),
                  Types.new_object( RplNumeric, 4 )],
                 interpreter.stack
  end

  def test_pick
    interpreter = Rpl.new
    interpreter.run! '1 2 3 4 3 pick'

    assert_equal [Types.new_object( RplNumeric, 1 ),
                  Types.new_object( RplNumeric, 2 ),
                  Types.new_object( RplNumeric, 3 ),
                  Types.new_object( RplNumeric, 4 ),
                  Types.new_object( RplNumeric, 2 )],
                 interpreter.stack
  end

  def test_depth
    interpreter = Rpl.new
    interpreter.run! 'depth'

    assert_equal [Types.new_object( RplNumeric, 0 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run! '1 2 depth'

    assert_equal [Types.new_object( RplNumeric, 1 ),
                  Types.new_object( RplNumeric, 2 ),
                  Types.new_object( RplNumeric, 2 )],
                 interpreter.stack
  end

  def test_roll
    interpreter = Rpl.new
    interpreter.run! '1 2 3 4 3 roll'

    assert_equal [Types.new_object( RplNumeric, 1 ),
                  Types.new_object( RplNumeric, 3 ),
                  Types.new_object( RplNumeric, 4 ),
                  Types.new_object( RplNumeric, 2 )],
                 interpreter.stack
  end

  def test_rolld
    interpreter = Rpl.new
    interpreter.run! '1 2 4 3 2 rolld'

    assert_equal [Types.new_object( RplNumeric, 1 ),
                  Types.new_object( RplNumeric, 2 ),
                  Types.new_object( RplNumeric, 3 ),
                  Types.new_object( RplNumeric, 4 )],
                 interpreter.stack
  end

  def test_over
    interpreter = Rpl.new
    interpreter.run! '1 2 3 4 over'

    assert_equal [Types.new_object( RplNumeric, 1 ),
                  Types.new_object( RplNumeric, 2 ),
                  Types.new_object( RplNumeric, 3 ),
                  Types.new_object( RplNumeric, 4 ),
                  Types.new_object( RplNumeric, 3 )],
                 interpreter.stack
  end
end
