# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require 'rpl'

class TestParser < Test::Unit::TestCase
  def test_number
    result = Rpl.new.parse( '1' )
    assert_equal [{ value: 1, type: :numeric, base: 10 }], result
  end

  def test_word
    result = Rpl.new.parse( 'dup' )
    assert_equal [{ value: 'dup', type: :word }], result
  end

  def test_string
    result = Rpl.new.parse( '"test"' )
    assert_equal [{ value: 'test', type: :string }], result

    result = Rpl.new.parse( '" test"' )
    assert_equal [{ value: ' test', type: :string }], result

    result = Rpl.new.parse( '"test "' )
    assert_equal [{ value: 'test ', type: :string }], result

    result = Rpl.new.parse( '" test "' )
    assert_equal [{ value: ' test ', type: :string }], result

    result = Rpl.new.parse( '" « test » "' )
    assert_equal [{ value: ' « test » ', type: :string }], result
  end

  def test_name
    result = Rpl.new.parse( "'test'" )
    assert_equal [{ value: 'test', type: :name }], result
  end

  def test_program
    result = Rpl.new.parse( '« test »' )
    assert_equal [{ value: 'test', type: :program }], result

    result = Rpl.new.parse( '«test »' )
    assert_equal [{ value: 'test', type: :program }], result

    result = Rpl.new.parse( '« test»' )
    assert_equal [{ value: 'test', type: :program }], result

    result = Rpl.new.parse( '«test»' )
    assert_equal [{ value: 'test', type: :program }], result

    result = Rpl.new.parse( '« test test »' )
    assert_equal [{ value: 'test test', type: :program }], result

    result = Rpl.new.parse( '« test « test » »' )
    assert_equal [{ value: 'test « test »', type: :program }], result

    result = Rpl.new.parse( '« test "test" test »' )
    assert_equal [{ value: 'test "test" test', type: :program }], result
  end

  def test_number_number
    result = Rpl.new.parse( '2 3' )
    assert_equal [{ value: 2, type: :numeric, base: 10 }, { value: 3, type: :numeric, base: 10 }], result
  end

  def test_number_number_word
    result = Rpl.new.parse( '2 3 +' )
    assert_equal [{ value: 2, type: :numeric, base: 10 },
                  { value: 3, type: :numeric, base: 10 },
                  { value: '+', type: :word }], result
  end

  def test_number_string
    result = Rpl.new.parse( '4 "test"' )
    assert_equal [{ value: 4, type: :numeric, base: 10 }, { value: 'test', type: :string }], result
  end

  def test_emptystring
    result = Rpl.new.parse( '""' )

    assert_equal [{ value: '', type: :string }], result
  end

  def test_spacestring
    result = Rpl.new.parse( '" "' )

    assert_equal [{ value: ' ', type: :string }], result
  end

  def test_string_spacestring
    result = Rpl.new.parse( '"test string" " "' )

    assert_equal [{ value: 'test string', type: :string },
                  { value: ' ', type: :string }], result
  end

  def test_string_word
    result = Rpl.new.parse( '"test string" split' )

    assert_equal [{ value: 'test string', type: :string },
                  { value: 'split', type: :word }], result
  end

  def test_spacestring_word
    result = Rpl.new.parse( '" " split' )

    assert_equal [{ value: ' ', type: :string },
                  { value: 'split', type: :word }], result
  end

  def test_program_name
    result = Rpl.new.parse( "« 2 dup * » 'carré' sto" )

    assert_equal [{ value: '2 dup *', type: :program },
                  { value: 'carré', type: :name },
                  { value: 'sto', type: :word }],
                 result
  end
end
