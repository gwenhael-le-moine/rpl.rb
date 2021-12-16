# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TestLanguageFileSystem < Test::Unit::TestCase
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

  def test_feval
    lang = Rpl::Language.new
    lang.run '"spec/test.rpl" feval vars'
    assert_equal [{ value: 27, base: 10, type: :numeric },
                  { value: ["'trrr'"], type: :list }],
                 lang.stack
  end

  def test_fwrite
    lang = Rpl::Language.new
    lang.run '"Ceci est un test de fwrite" "spec/test_fwrite.txt" fwrite'
    assert_equal [],
                 lang.stack

    assert_true File.exist?( 'spec/test_fwrite.txt' )

    written_content = File.read( 'spec/test_fwrite.txt' )
    assert_equal '"Ceci est un test de fwrite"',
                 written_content

    FileUtils.rm 'spec/test_fwrite.txt'
  end
end
