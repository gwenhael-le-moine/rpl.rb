# coding: utf-8
# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestLanguageString < MiniTest::Test
  include Types

  def test_to_string
    interpreter = Rpl.new
    interpreter.run '2 →str'

    assert_equal [RplString.new( '"2"' )],
                 interpreter.stack
  end

  def test_from_string
    interpreter = Rpl.new
    interpreter.run '"2" str→'

    assert_equal [RplNumeric.new( 2 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"« dup * » \'carré\' sto" str→'

    assert_equal [RplProgram.new( '« dup * »' ),
                  RplName.new( 'carré' ),
                  RplName.new( 'sto' )],
                 interpreter.stack
  end

  def test_chr
    interpreter = Rpl.new
    interpreter.run '71 chr'

    assert_equal [RplString.new( '"G"' )],
                 interpreter.stack
  end

  def test_num
    interpreter = Rpl.new
    interpreter.run '"G" num'

    assert_equal [RplNumeric.new( 71 )],
                 interpreter.stack
  end

  def test_size
    interpreter = Rpl.new
    interpreter.run '"test" size'

    assert_equal [RplNumeric.new( 4 )],
                 interpreter.stack
  end

  def test_pos
    interpreter = Rpl.new
    interpreter.run '"test of POS" "of" pos'

    assert_equal [RplNumeric.new( 5 )],
                 interpreter.stack
  end

  def test_sub
    interpreter = Rpl.new
    interpreter.run '"my string to sub" 4 6 sub'

    assert_equal [RplString.new( '"str"' )],
                 interpreter.stack
  end

  def test_rev
    interpreter = Rpl.new
    interpreter.run '"my string to sub" rev'

    assert_equal [RplString.new( '"my string to sub"'.reverse )],
                 interpreter.stack
  end

  def test_split
    interpreter = Rpl.new
    interpreter.run '"my string to sub" " " split'

    assert_equal [RplString.new( '"my"' ),
                  RplString.new( '"string"' ),
                  RplString.new( '"to"' ),
                  RplString.new( '"sub"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"my,string,to sub" "," split'

    assert_equal [RplString.new( '"my"' ),
                  RplString.new( '"string"' ),
                  RplString.new( '"to sub"' )],
                 interpreter.stack
  end
end
