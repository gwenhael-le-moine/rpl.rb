# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TestLanguageBranch < Test::Unit::TestCase
  def test_ifte
    lang = Rpl::Language.new
    lang.run 'true « 2 3 + » « 2 3 - » ifte'

    assert_equal [{ value: 5, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run 'false « 2 3 + » « 2 3 - » ifte'

    assert_equal [{ value: -1, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_ift
    lang = Rpl::Language.new
    lang.run 'true « 2 3 + » ift'

    assert_equal [{ value: 5, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run 'false « 2 3 + » ift'

    assert_equal [],
                 lang.stack
  end
end
