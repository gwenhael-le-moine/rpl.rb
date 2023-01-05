# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestLanguageList < MiniTest::Test
  include Types

  def test_2list
    interpreter = Rpl.new
    interpreter.run! '1 2 3 dup →list'
    assert_equal [Types.new_object( RplList, '{ 1 2 3 }' )],
                 interpreter.stack
  end

  def test_from_list
    interpreter = Rpl.new
    interpreter.run! '{ 1 2 3 } list→'
    assert_equal [Types.new_object( RplNumeric, 1 ),
                  Types.new_object( RplNumeric, 2 ),
                  Types.new_object( RplNumeric, 3 )],
                 interpreter.stack
  end

  def test_dolist
    interpreter = Rpl.new
    interpreter.run! '{ 1 2 3 } « 3 + » dolist'
    assert_equal [Types.new_object( RplList, '{ 4 5 6 }' )],
                 interpreter.stack
  end
end
