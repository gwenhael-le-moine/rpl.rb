# coding: utf-8
# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TesttLanguageOperationsRealsAndComplexes < MiniTest::Test
  include Types

  # TODO: test complexes

  def test_add
    interpreter = Rpl.new
    interpreter.run '1 2 +'
    assert_equal [Types.new_object( RplNumeric, 3 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 "a" +'
    assert_equal [Types.new_object( RplString, '"1a"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 \'a\' +'
    assert_equal [Types.new_object( RplName, "'1a'" )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 dup dup →list +'
    assert_equal [Types.new_object( RplList, [Types.new_object( RplNumeric, 1 ),
                                              Types.new_object( RplNumeric, 1 )] )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" "b" +'
    assert_equal [Types.new_object( RplString, '"ab"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" \'b\' +'
    assert_equal [Types.new_object( RplString, '"ab"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" 1 +'
    assert_equal [Types.new_object( RplString, '"a1"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" 1 dup →list +'
    assert_equal [Types.new_object( RplList, [Types.new_object( RplString, '"a"' ),
                                              Types.new_object( RplNumeric, 1 )] )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'a\' 1 +'
    assert_equal [Types.new_object( RplName, 'a1' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'a\' "b" +'
    assert_equal [Types.new_object( RplString, '"ab"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'a\' \'b\' +'
    assert_equal [Types.new_object( RplName, "'ab'" )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'a\' 1 dup →list +'
    assert_equal [Types.new_object( RplList, [Types.new_object( RplName, 'a' ),
                                              Types.new_object( RplNumeric, 1 )] )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 a "test" 3 →list dup rev +'
    assert_equal [Types.new_object( RplList, [Types.new_object( RplNumeric, 1 ),
                                              Types.new_object( RplName, 'a' ),
                                              Types.new_object( RplString, '"test"' ),
                                              Types.new_object( RplString, '"test"' ),
                                              Types.new_object( RplName, 'a' ),
                                              Types.new_object( RplNumeric, 1 )] )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 a "test" 3 →list 9 +'
    assert_equal [Types.new_object( RplList, [Types.new_object( RplNumeric, 1 ),
                                              Types.new_object( RplName, 'a' ),
                                              Types.new_object( RplString, '"test"' ),
                                              Types.new_object( RplNumeric, 9 )] )],
                 interpreter.stack

    #################
    # now with vars #
    #################

    interpreter = Rpl.new
    interpreter.run '1 \'a\' sto 2 \'b\' sto a b + a b'
    assert_equal [Types.new_object( RplNumeric, 3 ),
                  Types.new_object( RplNumeric, 1 ),
                  Types.new_object( RplNumeric, 2 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 \'a\' sto "a" \'b\' sto a b + a b'
    assert_equal [Types.new_object( RplString, '"1a"' ),
                  Types.new_object( RplNumeric, 1 ),
                  Types.new_object( RplString, '"a"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 \'a\' sto \'z\' \'b\' sto a b + a b'
    assert_equal [Types.new_object( RplName, "'1z'" ),
                  Types.new_object( RplNumeric, 1 ),
                  Types.new_object( RplName, "'z'" )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 \'a\' sto a dup →list \'b\' sto a b + a b'
    assert_equal [Types.new_object( RplList, [Types.new_object( RplNumeric, 1 ),
                                              Types.new_object( RplNumeric, 1 )] ),
                  Types.new_object( RplNumeric, 1 ),
                  Types.new_object( RplList, [Types.new_object( RplNumeric, 1 )] )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" \'a\' sto "b" \'b\' sto a b + a b'
    assert_equal [Types.new_object( RplString, '"ab"' ),
                  Types.new_object( RplString, '"a"' ),
                  Types.new_object( RplString, '"b"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" \'a\' sto \'z\' \'b\' sto a b + a b'
    assert_equal [Types.new_object( RplString, '"az"' ),
                  Types.new_object( RplString, '"a"' ),
                  Types.new_object( RplName, "'z'" )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" \'a\' sto 1 \'b\' sto a b + a b'
    assert_equal [Types.new_object( RplString, '"a1"' ),
                  Types.new_object( RplString, '"a"' ),
                  Types.new_object( RplNumeric, 1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '"a" \'a\' sto 1 dup →list \'b\' sto a b + a b'
    assert_equal [Types.new_object( RplList, [Types.new_object( RplString, '"a"' ),
                                              Types.new_object( RplNumeric, 1 )] ),
                  Types.new_object( RplString, '"a"' ),
                  Types.new_object( RplList, [Types.new_object( RplNumeric, 1 )] )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'z\' \'a\' sto 1 \'b\' sto a b + a b'
    assert_equal [Types.new_object( RplName, 'z1' ),
                  Types.new_object( RplName, 'z' ),
                  Types.new_object( RplNumeric, 1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'z\' \'a\' sto "b" \'b\' sto a b + a b'
    assert_equal [Types.new_object( RplString, '"zb"' ),
                  Types.new_object( RplName, "'z'" ),
                  Types.new_object( RplString, '"b"' )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'z\' \'a\' sto \'y\' \'b\' sto a b + a b'
    assert_equal [Types.new_object( RplName, "'zy'" ),
                  Types.new_object( RplName, "'z'" ),
                  Types.new_object( RplName, "'y'" )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '\'z\' \'a\' sto 1 dup →list \'b\' sto a b + a b'
    assert_equal [Types.new_object( RplList, [Types.new_object( RplName, "'z'" ),
                                              Types.new_object( RplNumeric, 1 )] ),
                  Types.new_object( RplName, "'z'" ),
                  Types.new_object( RplList, [Types.new_object( RplNumeric, 1 )] )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 z "test" 3 →list \'a\' sto a rev \'b\' sto a b + a b'
    assert_equal [Types.new_object( RplList, [Types.new_object( RplNumeric, 1 ),
                                              Types.new_object( RplName, 'z' ),
                                              Types.new_object( RplString, '"test"' ),
                                              Types.new_object( RplString, '"test"' ),
                                              Types.new_object( RplName, 'z' ),
                                              Types.new_object( RplNumeric, 1 )] ),
                  Types.new_object( RplList, [Types.new_object( RplNumeric, 1 ),
                                              Types.new_object( RplName, 'z' ),
                                              Types.new_object( RplString, '"test"' )] ),
                  Types.new_object( RplList, [Types.new_object( RplString, '"test"' ),
                                              Types.new_object( RplName, 'z' ),
                                              Types.new_object( RplNumeric, 1 )] )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 a "test" 3 →list \'a\' sto 9 \'b\' sto a b + a b'
    assert_equal [Types.new_object( RplList, [Types.new_object( RplNumeric, 1 ),
                                              Types.new_object( RplName, 'a' ),
                                              Types.new_object( RplString, '"test"' ),
                                              Types.new_object( RplNumeric, 9 )] ),
                  Types.new_object( RplList, [Types.new_object( RplNumeric, 1 ),
                                              Types.new_object( RplName, 'a' ),
                                              Types.new_object( RplString, '"test"' )] ),
                  Types.new_object( RplNumeric, 9 )],
                 interpreter.stack
  end

  def test_subtract
    interpreter = Rpl.new
    interpreter.run '1 2 -'
    assert_equal [Types.new_object( RplNumeric, -1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '2 1 -'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack
  end

  def test_negate
    interpreter = Rpl.new
    interpreter.run '-1 chs'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 chs'
    assert_equal [Types.new_object( RplNumeric, -1 )],
                 interpreter.stack
  end

  def test_multiply
    interpreter = Rpl.new
    interpreter.run '3 4 *'
    assert_equal [Types.new_object( RplNumeric, 12 )],
                 interpreter.stack
  end

  def test_divide
    interpreter = Rpl.new
    interpreter.run '3.0 4 /'
    assert_equal [Types.new_object( RplNumeric, 0.75 )],
                 interpreter.stack
  end

  def test_inverse
    interpreter = Rpl.new
    interpreter.run '4 inv'
    assert_equal [Types.new_object( RplNumeric, 0.25 )],
                 interpreter.stack
  end

  def test_power
    interpreter = Rpl.new
    interpreter.run '3 4 ^'
    assert_equal [Types.new_object( RplNumeric, 81 )],
                 interpreter.stack
  end

  def test_sqrt
    interpreter = Rpl.new
    interpreter.run '16 √'
    assert_equal [Types.new_object( RplNumeric, 4 )],
                 interpreter.stack
  end

  def test_sq
    interpreter = Rpl.new
    interpreter.run '4 sq'
    assert_equal [Types.new_object( RplNumeric, 16 )],
                 interpreter.stack
  end

  def test_abs
    interpreter = Rpl.new
    interpreter.run '-1 abs'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 abs'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack
  end

  def test_dec
    interpreter = Rpl.new
    interpreter.run '0x1 dec'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack
  end

  def test_hex
    interpreter = Rpl.new
    interpreter.run '1 hex'
    expected_value = Types.new_object( RplNumeric, 1 )
    expected_value.base = 16
    assert_equal [expected_value],
                 interpreter.stack
  end

  def test_bin
    interpreter = Rpl.new
    interpreter.run '1 bin'
    expected_value = Types.new_object( RplNumeric, 1 )
    expected_value.base = 2
    assert_equal [expected_value],
                 interpreter.stack
  end

  def test_base
    interpreter = Rpl.new
    interpreter.run '1 31 base'
    expected_value = Types.new_object( RplNumeric, 1 )
    expected_value.base = 31
    assert_equal [expected_value],
                 interpreter.stack
  end

  def test_sign
    interpreter = Rpl.new
    interpreter.run '-10 sign'
    assert_equal [Types.new_object( RplNumeric, -1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '10 sign'
    assert_equal [Types.new_object( RplNumeric, 1 )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '0 sign'
    assert_equal [Types.new_object( RplNumeric, 0 )],
                 interpreter.stack
  end
end
