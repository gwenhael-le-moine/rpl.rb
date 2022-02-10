# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../rpl'

class TestLanguageString < Test::Unit::TestCase
  def test_to_string
    interpreter = Rpl.new
    interpreter.run '2 →str'

    assert_equal [{ value: '2', type: :string }],
                 interpreter.stack
  end

  def test_from_string
    interpreter = Rpl.new
    interpreter.run '"2" str→'

    assert_equal [{ value: 2, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"« dup * » \'carré\' sto" str→'

    assert_equal [{ value: 'dup *', type: :program },
                  { value: 'carré', type: :name },
                  { value: 'sto', type: :word }],
                 interpreter.stack
  end

  def test_chr
    interpreter = Rpl.new
    interpreter.run '71 chr'

    assert_equal [{ value: 'G', type: :string }],
                 interpreter.stack
  end

  def test_num
    interpreter = Rpl.new
    interpreter.run '"G" num'

    assert_equal [{ value: 71, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_size
    interpreter = Rpl.new
    interpreter.run '"test" size'

    assert_equal [{ value: 4, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_pos
    interpreter = Rpl.new
    interpreter.run '"test of POS" "of" pos'

    assert_equal [{ value: 5, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_sub
    interpreter = Rpl.new
    interpreter.run '"my string to sub" 4 6 sub'

    assert_equal [{ value: 'str', type: :string }],
                 interpreter.stack
  end

  def test_rev
    interpreter = Rpl.new
    interpreter.run '"my string to sub" rev'

    assert_equal [{ value: 'my string to sub'.reverse, type: :string }],
                 interpreter.stack
  end

  def test_split
    interpreter = Rpl.new
    interpreter.run '"my string to sub" " " split'

    assert_equal [{ value: 'my', type: :string },
                  { value: 'string', type: :string },
                  { value: 'to', type: :string },
                  { value: 'sub', type: :string }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"my,string,to sub" "," split'

    assert_equal [{ value: 'my', type: :string },
                  { value: 'string', type: :string },
                  { value: 'to sub', type: :string }],
                 interpreter.stack
  end
end
