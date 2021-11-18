# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../lib/core'
require_relative '../lib/dictionary'
require_relative '../lib/parser'
require_relative '../lib/runner'

class TestParser < Test::Unit::TestCase
  def test_eval
    stack, _dico = Rpn::Core::Program.eval( [{ value: '« 2 dup * »', type: :program }], Rpn::Dictionary.new )
    assert_equal [{ value: 4, type: :numeric }],
                 stack
  end
end
