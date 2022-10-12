# coding: utf-8
# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestLanguageStringAndList < MiniTest::Test
  include Types

  def test_rev
    interpreter = Rpl.new
    interpreter.run! '"my string to sub" rev'
    assert_equal [Types.new_object( RplString, '"my string to sub"'.reverse )],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run! '{ 1 2 3 } rev'
    assert_equal [Types.new_object( RplList, '{ 3 2 1 }' )],
                 interpreter.stack
  end
end
