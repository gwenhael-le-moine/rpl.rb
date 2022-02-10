# coding: utf-8
# frozen_string_literal: true

require 'test/unit'

require_relative '../rpl'

class TestLanguageFileSystem < Test::Unit::TestCase
  def test_fread
    interpreter = Rpl.new
    interpreter.run '"spec/test.rpl" fread'

    assert_equal [{ value: "1 2 +

« dup dup * * »
'trrr' sto

trrr
", type: :string }],
                 interpreter.stack

    interpreter.run 'eval vars'
    assert_equal [{ value: 27, base: 10, type: :numeric },
                  { value: [{ type: :name, value: 'trrr' }], type: :list }],
                 interpreter.stack
  end

  def test_feval
    interpreter = Rpl.new
    interpreter.run '"spec/test.rpl" feval vars'
    assert_equal [{ value: 27, base: 10, type: :numeric },
                  { value: [{ type: :name, value: 'trrr' }], type: :list }],
                 interpreter.stack
  end

  def test_fwrite
    interpreter = Rpl.new
    interpreter.run '"Ceci est un test de fwrite" "spec/test_fwrite.txt" fwrite'
    assert_equal [],
                 interpreter.stack

    assert_true File.exist?( 'spec/test_fwrite.txt' )

    written_content = File.read( 'spec/test_fwrite.txt' )
    assert_equal 'Ceci est un test de fwrite',
                 written_content

    FileUtils.rm 'spec/test_fwrite.txt'
  end
end
