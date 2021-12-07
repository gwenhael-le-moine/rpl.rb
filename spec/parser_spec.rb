# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../lib/parser'

class TestParser < Test::Unit::TestCase
  def test_number
    result = Rpl::Lang::Parser.new.parse_input( '1' )
    assert_equal [{ value: 1, type: :numeric, base: 10 }], result
  end

  def test_word
    result = Rpl::Lang::Parser.new.parse_input( 'dup' )
    assert_equal [{ value: 'dup', type: :word }], result
  end

  def test_string
    result = Rpl::Lang::Parser.new.parse_input( '"test"' )
    assert_equal [{ value: '"test"', type: :string }], result

    result = Rpl::Lang::Parser.new.parse_input( '" test"' )
    assert_equal [{ value: '" test"', type: :string }], result

    result = Rpl::Lang::Parser.new.parse_input( '"test "' )
    assert_equal [{ value: '"test "', type: :string }], result

    result = Rpl::Lang::Parser.new.parse_input( '" test "' )
    assert_equal [{ value: '" test "', type: :string }], result
  end

  def test_name
    result = Rpl::Lang::Parser.new.parse_input( "'test'" )
    assert_equal [{ value: "'test'", type: :name }], result
  end

  def test_program
    result = Rpl::Lang::Parser.new.parse_input( '« test »' )
    assert_equal [{ value: '« test »', type: :program }], result

    result = Rpl::Lang::Parser.new.parse_input( '«test »' )
    assert_equal [{ value: '« test »', type: :program }], result

    result = Rpl::Lang::Parser.new.parse_input( '« test»' )
    assert_equal [{ value: '« test »', type: :program }], result

    result = Rpl::Lang::Parser.new.parse_input( '«test»' )
    assert_equal [{ value: '« test »', type: :program }], result

    result = Rpl::Lang::Parser.new.parse_input( '« test test »' )
    assert_equal [{ value: '« test test »', type: :program }], result

    result = Rpl::Lang::Parser.new.parse_input( '« test « test » »' )
    assert_equal [{ value: '« test « test » »', type: :program }], result

    result = Rpl::Lang::Parser.new.parse_input( '« test "test" test »' )
    assert_equal [{ value: '« test "test" test »', type: :program }], result
  end

  def test_number_number
    result = Rpl::Lang::Parser.new.parse_input( '2 3' )
    assert_equal [{ value: 2, type: :numeric, base: 10 }, { value: 3, type: :numeric, base: 10 }], result
  end

  def test_number_number_word
    result = Rpl::Lang::Parser.new.parse_input( '2 3 +' )
    assert_equal [{ value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: '+', type: :word }], result
  end

  def test_number_string
    result = Rpl::Lang::Parser.new.parse_input( '4 "test"' )
    assert_equal [{ value: 4, type: :numeric, base: 10 }, { value: '"test"', type: :string }], result
  end

  def test_program_name
    result = Rpl::Lang::Parser.new.parse_input( "« 2 dup * » 'carré' sto" )

    assert_equal [{ value: '« 2 dup * »', type: :program },
                  { value: "'carré'", type: :name },
                  { value: 'sto', type: :word }],
                 result
  end
end
