# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TestLanguageString < Test::Unit::TestCase
  def test_to_string
    lang = Rpl::Language.new
    lang.run '2 →str'

    assert_equal [{ value: '"2"', type: :string }],
                 lang.stack
  end

  def test_from_string
    lang = Rpl::Language.new
    lang.run '"2" str→'

    assert_equal [{ value: 2, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '"« dup * » \'carré\' sto" str→'

    assert_equal [{ value: '« dup * »', type: :program },
                  { value: "'carré'", type: :name },
                  { value: 'sto', type: :word }],
                 lang.stack
  end

  def test_chr
    lang = Rpl::Language.new
    lang.run '71 chr'

    assert_equal [{ value: '"G"', type: :string }],
                 lang.stack
  end

  def test_num
    lang = Rpl::Language.new
    lang.run '"G" num'

    assert_equal [{ value: 71, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_size
    lang = Rpl::Language.new
    lang.run '"test" size'

    assert_equal [{ value: 4, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_pos
    lang = Rpl::Language.new
    lang.run '"test of POS" "of" pos'

    assert_equal [{ value: 5, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_sub
    lang = Rpl::Language.new
    lang.run '"my string to sub" 4 6 sub'

    assert_equal [{ value: '"str"', type: :string }],
                 lang.stack
  end

  def test_rev
    lang = Rpl::Language.new
    lang.run '"my string to sub" rev'

    assert_equal [{ value: '"my string to sub"'.reverse, type: :string }],
                 lang.stack
  end

  def test_split
    lang = Rpl::Language.new
    lang.run '"my string to sub" " " split'

    assert_equal [{ value: '"my"', type: :string },
                  { value: '"string"', type: :string },
                  { value: '"to"', type: :string },
                  { value: '"sub"', type: :string }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '"my,string,to sub" "," split'

    assert_equal [{ value: '"my"', type: :string },
                  { value: '"string"', type: :string },
                  { value: '"to sub"', type: :string }],
                 lang.stack
  end
end
