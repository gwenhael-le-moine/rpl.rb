# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../lib/core'
require_relative '../lib/dictionary'
require_relative '../lib/parser'
require_relative '../lib/runner'

class TestLanguageProgram < Test::Unit::TestCase
  def test_eval
    stack = Rpl::Lang::Core.eval( [{ value: '« 2 dup * dup »', type: :program }], Rpl::Lang::Dictionary.new )

    assert_equal [{ value: 4, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 stack

    stack = Rpl::Lang::Core.eval( [{ value: 4, type: :numeric, base: 10 },
                                   { value: "'dup'", type: :name }], Rpl::Lang::Dictionary.new )

    assert_equal [{ value: 4, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 stack

    stack = Rpl::Lang::Core.eval( [{ value: 4, type: :numeric, base: 10 },
                                   { value: 'dup', type: :word }], Rpl::Lang::Dictionary.new )

    assert_equal [{ value: 4, type: :numeric, base: 10 },
                  { value: 4, type: :numeric, base: 10 }],
                 stack
  end

  def test_sto
    stack = Rpl::Lang::Core.sto( [{ value: '« 2 dup  »', type: :program },
                                  { value: "'quatre'", type: :name }], Rpl::Lang::Dictionary.new )

    assert_equal [], stack
  end
end
