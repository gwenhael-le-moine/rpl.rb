# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../lib/core'
require_relative '../lib/parser'

class TestLanguageString < Test::Unit::TestCase
  def test_to_string
    stack = Rpl::Lang::Core.to_string( [{ value: 2, type: :numeric, base: 10 }] )

    assert_equal [{ value: '2', type: :string }],
                 stack
  end

  def test_from_string
    stack = Rpl::Lang::Core.from_string( [{ value: '2', type: :string }] )

    assert_equal [{ value: 2, type: :numeric, base: 10 }],
                 stack

    stack = Rpl::Lang::Core.from_string( [{ value: "« 2 dup * » 'carré' sto", type: :string }] )

    assert_equal [{ value: '« 2 dup * »', type: :program },
                  { value: "'carré'", type: :name },
                  { value: 'sto', type: :word }],
                 stack
  end

  def test_chr
    stack = Rpl::Lang::Core.chr( [{ value: 71, type: :numeric, base: 10 }] )

    assert_equal [{ value: 'G', type: :string }],
                 stack
  end

  def test_num
    stack = Rpl::Lang::Core.num( [{ value: 'G', type: :string }] )

    assert_equal [{ value: 71, type: :numeric, base: 10 }],
                 stack
  end

  def test_size
    stack = Rpl::Lang::Core.size( [{ value: 'test', type: :string }] )

    assert_equal [{ value: 4, type: :numeric, base: 10 }],
                 stack
  end

  def test_pos
    stack = Rpl::Lang::Core.pos( [{ value: 'test of POS', type: :string },
                                  { value: 'of', type: :string }] )

    assert_equal [{ value: 5, type: :numeric, base: 10 }],
                 stack
  end

  def test_sub
    stack = Rpl::Lang::Core.sub( [{ value: 'test', type: :string },
                                  { value: 1, type: :numeric, base: 10 },
                                  { value: 2, type: :numeric, base: 10 }] )

    assert_equal [{ value: 'es', type: :string }],
                 stack
  end
end
