# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../lib/parser'

class TestParser < Test::Unit::TestCase
  def test_number
    result = Rpn::Parser.new.parse_input( '1' )
    assert_equal [{ value: 1, type: :numeric }], result
  end

  def test_word
    result = Rpn::Parser.new.parse_input( 'dup' )
    assert_equal [{ value: 'dup', type: :word }], result
  end

  def test_string
    result = Rpn::Parser.new.parse_input( '"test"' )
    assert_equal [{ value: '"test"', type: :string }], result

    result = Rpn::Parser.new.parse_input( '" test"' )
    assert_equal [{ value: '" test"', type: :string }], result

    result = Rpn::Parser.new.parse_input( '"test "' )
    assert_equal [{ value: '"test "', type: :string }], result

    result = Rpn::Parser.new.parse_input( '" test "' )
    assert_equal [{ value: '" test "', type: :string }], result
  end

  def test_name
    result = Rpn::Parser.new.parse_input( "'test'" )
    assert_equal [{ value: "'test'", type: :name }], result
  end

  def test_program
    result = Rpn::Parser.new.parse_input( '« test »' )
    assert_equal [{ value: '« test »', type: :program }], result

    result = Rpn::Parser.new.parse_input( '«test »' )
    assert_equal [{ value: '«test »', type: :program }], result

    result = Rpn::Parser.new.parse_input( '« test»' )
    assert_equal [{ value: '« test»', type: :program }], result

    result = Rpn::Parser.new.parse_input( '« test test »' )
    assert_equal [{ value: '« test test »', type: :program }], result

    result = Rpn::Parser.new.parse_input( '« test « test » »' )
    assert_equal [{ value: '« test « test » »', type: :program }], result

    result = Rpn::Parser.new.parse_input( '« test "test" test »' )
    assert_equal [{ value: '« test "test" test »', type: :program }], result
  end

  def test_number_number
    result = Rpn::Parser.new.parse_input( '2 3' )
    assert_equal [{ value: 2, type: :numeric }, { value: 3, type: :numeric }], result
  end

  def test_number_string
    result = Rpn::Parser.new.parse_input( '4 "test"' )
    assert_equal [{ value: 4, type: :numeric }, { value: '"test"', type: :string }], result
  end
end
