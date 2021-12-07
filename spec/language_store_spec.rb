# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TestLanguageProgram < Test::Unit::TestCase
  def test_sto
    stack, _dictionary = Rpl::Lang::Core.sto( [{ value: '« 2 dup  »', type: :program },
                                               { value: "'quatre'", type: :name }],
                                              Rpl::Lang::Dictionary.new )

    assert_equal [], stack
  end
end
