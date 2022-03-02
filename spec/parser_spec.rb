# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl/parser'
require 'rpl/types'

class TestParser < MiniTest::Test
  include Types

  def test_number
    result = Parser.parse( '1' )
    assert_equal 1, result.size
    assert_equal RplNumeric, result.first.class
    assert_equal BigDecimal( 1 ), result.first.value

    result = Parser.parse( '0b101' )
    assert_equal 1, result.size
    assert_equal RplNumeric, result.first.class
    assert_equal 2, result.first.base
    assert_equal BigDecimal( 5 ), result.first.value

    result = Parser.parse( '0o57' )
    assert_equal 1, result.size
    assert_equal RplNumeric, result.first.class
    assert_equal 8, result.first.base
    assert_equal BigDecimal( 47 ), result.first.value

    result = Parser.parse( '0xfa' )
    assert_equal 1, result.size
    assert_equal RplNumeric, result.first.class
    assert_equal 16, result.first.base
    assert_equal BigDecimal( 250 ), result.first.value

    result = Parser.parse( '3b10' )
    assert_equal 1, result.size
    assert_equal RplNumeric, result.first.class
    assert_equal 3, result.first.base
    assert_equal BigDecimal( 3 ), result.first.value
  end

  def test_word
    result = Parser.parse( 'dup' )
    assert_equal 1, result.size
    assert_equal RplName, result.first.class
    assert_equal 'dup', result.first.value
    assert_equal false, result.first.not_to_evaluate
  end

  def test_string
    result = Parser.parse( '"test"' )
    assert_equal 1, result.size
    assert_equal RplString, result.first.class
    assert_equal 'test', result.first.value

    result = Parser.parse( '" test"' )
    assert_equal 1, result.size
    assert_equal RplString, result.first.class
    assert_equal ' test', result.first.value

    result = Parser.parse( '"test "' )
    assert_equal 1, result.size
    assert_equal RplString, result.first.class
    assert_equal 'test ', result.first.value

    result = Parser.parse( '" test "' )
    assert_equal 1, result.size
    assert_equal RplString, result.first.class
    assert_equal ' test ', result.first.value

    result = Parser.parse( '" « test » "' )
    assert_equal 1, result.size
    assert_equal RplString, result.first.class
    assert_equal ' « test » ', result.first.value
  end

  def test_name
    result = Parser.parse( "'test'" )
    assert_equal 1, result.size
    assert_equal RplName, result.first.class
    assert_equal 'test', result.first.value
    assert_equal true, result.first.not_to_evaluate

    result = Parser.parse( 'test' )
    assert_equal 1, result.size
    assert_equal RplName, result.first.class
    assert_equal 'test', result.first.value
    assert_equal false, result.first.not_to_evaluate

    result = Parser.parse( '+' )
    assert_equal 1, result.size
    assert_equal RplName, result.first.class
    assert_equal '+', result.first.value
    assert_equal false, result.first.not_to_evaluate

    result = Parser.parse( '√' )
    assert_equal 1, result.size
    assert_equal RplName, result.first.class
    assert_equal '√', result.first.value
    assert_equal false, result.first.not_to_evaluate
  end

  def test_program
    result = Parser.parse( '« test »' )
    assert_equal 1, result.size
    assert_equal RplProgram, result.first.class
    assert_equal 'test', result.first.value

    result = Parser.parse( '«test »' )
    assert_equal 1, result.size
    assert_equal RplProgram, result.first.class
    assert_equal 'test', result.first.value

    result = Parser.parse( '« test»' )
    assert_equal 1, result.size
    assert_equal RplProgram, result.first.class
    assert_equal 'test', result.first.value

    result = Parser.parse( '«test»' )
    assert_equal 1, result.size
    assert_equal RplProgram, result.first.class
    assert_equal 'test', result.first.value

    result = Parser.parse( '« test test »' )
    assert_equal 1, result.size
    assert_equal RplProgram, result.first.class
    assert_equal 'test test', result.first.value

    result = Parser.parse( '« test « test » »' )
    assert_equal 1, result.size
    assert_equal RplProgram, result.first.class
    assert_equal 'test « test »', result.first.value

    result = Parser.parse( '« test "test" test »' )
    assert_equal 1, result.size
    assert_equal RplProgram, result.first.class
    assert_equal 'test "test" test', result.first.value
  end

  def test_list
    result = Parser.parse( '{ test }' )
    assert_equal 1, result.size
    assert_equal RplList, result.first.class
    assert_equal 1, result.first.value.size
    assert_equal RplName, result.first.value.first.class
    assert_equal 'test', result.first.value.first.value

    result = Parser.parse( '{test }' )
    assert_equal 1, result.size
    assert_equal RplList, result.first.class
    assert_equal 1, result.first.value.size
    assert_equal RplName, result.first.value.first.class
    assert_equal 'test', result.first.value.first.value

    result = Parser.parse( '{ test}' )
    assert_equal 1, result.size
    assert_equal RplList, result.first.class
    assert_equal 1, result.first.value.size
    assert_equal RplName, result.first.value.first.class
    assert_equal 'test', result.first.value.first.value

    result = Parser.parse( '{test}' )
    assert_equal 1, result.size
    assert_equal RplList, result.first.class
    assert_equal 1, result.first.value.size
    assert_equal RplName, result.first.value.first.class
    assert_equal 'test', result.first.value.first.value

    result = Parser.parse( '{ test test }' )
    assert_equal 1, result.size
    assert_equal RplList, result.first.class
    assert_equal 2, result.first.value.size
    assert_equal RplName, result.first.value.first.class
    assert_equal 'test', result.first.value.first.value
    assert_equal RplName, result.last.value.first.class
    assert_equal 'test', result.last.value.first.value

    result = Parser.parse( '{ test { test } }' )
    # we have one list
    assert_equal 1, result.size
    assert_equal RplList, result.first.class
    # that list has 2 elements
    assert_equal 2, result.first.value.size
    # first element is a name
    assert_equal RplName, result.first.value.first.class
    assert_equal 'test', result.first.value.first.value
    # second is a list
    assert_equal RplList, result.first.value.last.class
    # that list has one element
    assert_equal 1, result.first.value.last.value.size
    # and it's a name
    assert_equal RplName, result.first.value.last.value.first.class
    assert_equal 'test', result.first.value.last.value.first.value

    result = Parser.parse( '{ test "test" test }' )
    # we have one list
    assert_equal 1, result.size
    assert_equal RplList, result.first.class
    # that list has 3 elements
    assert_equal 3, result.first.value.size
    # first and last element is a name
    assert_equal RplName, result.first.value[0].class
    assert_equal 'test', result.first.value[0].value
    assert_equal RplName, result.first.value[2].class
    assert_equal 'test', result.first.value[2].value
    # middle element is a string
    assert_equal RplString, result.first.value[1].class
    assert_equal 'test', result.first.value[1].value
  end

  def test_number_number
    result = Parser.parse( '2 3' )
    assert_equal 2, result.size
    assert_equal RplNumeric, result.first.class
    assert_equal BigDecimal( 2 ), result.first.value
    assert_equal RplNumeric, result.last.class
    assert_equal BigDecimal( 3 ), result.last.value
  end

  def test_number_number_word
    result = Parser.parse( '2 3 +' )
    assert_equal 3, result.size
    assert_equal RplNumeric, result.first.class
    assert_equal BigDecimal( 2 ), result.first.value
    assert_equal RplNumeric, result[1].class
    assert_equal BigDecimal( 3 ), result[1].value
    assert_equal RplName, result[2].class
    assert_equal '+', result[2].value
  end

  def test_number_string
    result = Parser.parse( '4 "test"' )
    assert_equal 2, result.size
    assert_equal RplNumeric, result.first.class
    assert_equal BigDecimal( 4 ), result.first.value
    assert_equal RplString, result.last.class
    assert_equal 'test', result.last.value
  end

  def test_emptystring
    result = Parser.parse( '""' )
    assert_equal 1, result.size
    assert_equal RplString, result.first.class
    assert_equal '', result.first.value
  end

  def test_spacestring
    result = Parser.parse( '" "' )
    assert_equal 1, result.size
    assert_equal RplString, result.first.class
    assert_equal ' ', result.first.value
  end

  def test_string_spacestring
    result = Parser.parse( '"test string" " "' )
    assert_equal 2, result.size
    assert_equal RplString, result.first.class
    assert_equal 'test string', result.first.value
    assert_equal RplString, result.last.class
    assert_equal ' ', result.last.value
  end

  def test_string_word
    result = Parser.parse( '"test string" split' )
    assert_equal 2, result.size
    assert_equal RplString, result.first.class
    assert_equal 'test string', result.first.value
    assert_equal RplName, result.last.class
    assert_equal 'split', result.last.value
    assert_equal false, result.last.not_to_evaluate
  end

  def test_spacestring_word
    result = Parser.parse( '" " split' )
    assert_equal 2, result.size
    assert_equal RplString, result.first.class
    assert_equal ' ', result.first.value
    assert_equal RplName, result.last.class
    assert_equal 'split', result.last.value
    assert_equal false, result.last.not_to_evaluate
  end

  def test_program_name
    result = Parser.parse( "« 2 dup * » 'carré' sto" )
    assert_equal 3, result.size
    assert_equal RplProgram, result.first.class
    assert_equal '2 dup *', result.first.value
    assert_equal RplName, result[1].class
    assert_equal 'carré', result[1].value
    assert_equal true, result[1].not_to_evaluate
    assert_equal RplName, result.last.class
    assert_equal 'sto', result.last.value
    assert_equal false, result.last.not_to_evaluate
  end

  def test_with_multiline
    result = Parser.parse( "« 2

dup * »

 'carré' sto" )
    assert_equal 3, result.size
    assert_equal RplProgram, result.first.class
    assert_equal '2 dup *', result.first.value
    assert_equal RplName, result[1].class
    assert_equal 'carré', result[1].value
    assert_equal true, result[1].not_to_evaluate
    assert_equal RplName, result.last.class
    assert_equal 'sto', result.last.value
    assert_equal false, result.last.not_to_evaluate
  end

  def test_with_comments
    result = Parser.parse( "« 2 #deux
# on duplique le deux
dup * »

# on va STOcker ce programme dans la variable 'carré'
 'carré' sto" )
    assert_equal 3, result.size
    assert_equal RplProgram, result.first.class
    assert_equal '2 dup *', result.first.value
    assert_equal RplName, result[1].class
    assert_equal 'carré', result[1].value
    assert_equal true, result[1].not_to_evaluate
    assert_equal RplName, result.last.class
    assert_equal 'sto', result.last.value
    assert_equal false, result.last.not_to_evaluate
  end
end
