# coding: utf-8
# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestLanguageString < MiniTest::Test
  include Types

  def test_to_string
    interpreter = Rpl.new
    interpreter.run '2 →str'

    assert_equal [Types.new_object( RplString, '"2"' )],
                 interpreter.stack
  end

  def test_from_string
    interpreter = Rpl.new
    interpreter.run '"2" str→'

    assert_equal [Types.new_object( RplNumeric, 2 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"« dup * » \'carré\' sto" str→'

    assert_equal [Types.new_object( RplProgram, '« dup * »' ),
                  Types.new_object( RplName, 'carré' ),
                  Types.new_object( RplName, 'sto' )],
                 interpreter.stack
  end

  def test_chr
    interpreter = Rpl.new
    interpreter.run '71 chr'

    assert_equal [Types.new_object( RplString, '"G"' )],
                 interpreter.stack
  end

  def test_num
    interpreter = Rpl.new
    interpreter.run '"G" num'

    assert_equal [Types.new_object( RplNumeric, 71 )],
                 interpreter.stack
  end

  def test_size
    interpreter = Rpl.new
    interpreter.run '"test" size'

    assert_equal [Types.new_object( RplNumeric, 4 )],
                 interpreter.stack
  end

  def test_pos
    interpreter = Rpl.new
    interpreter.run '"test of POS" "of" pos'

    assert_equal [Types.new_object( RplNumeric, 5 )],
                 interpreter.stack
  end

  def test_sub
    interpreter = Rpl.new
    interpreter.run '"my string to sub" 4 6 sub'

    assert_equal [Types.new_object( RplString, '"str"' )],
                 interpreter.stack
  end

  def test_split
    interpreter = Rpl.new
    interpreter.run '"my string to sub" " " split'

    assert_equal [Types.new_object( RplString, '"my"' ),
                  Types.new_object( RplString, '"string"' ),
                  Types.new_object( RplString, '"to"' ),
                  Types.new_object( RplString, '"sub"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"my,string,to sub" "," split'

    assert_equal [Types.new_object( RplString, '"my"' ),
                  Types.new_object( RplString, '"string"' ),
                  Types.new_object( RplString, '"to sub"' )],
                 interpreter.stack
  end
end
