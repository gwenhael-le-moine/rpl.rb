# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TestLanguageTimeDate < Test::Unit::TestCase
  def test_fread
    lang = Rpl::Language.new
    lang.run '"spec/test.rpl" fread'

    assert_equal [{ value: "\"1 2 +

« dup dup * * »
'trrr' sto

trrr
\"", type: :string }],
                 lang.stack

    lang.run 'eval vars'
    assert_equal [{ value: 27, base: 10, type: :numeric },
                  { value: ["'trrr'"], type: :list }],
                 lang.stack
  end
end
