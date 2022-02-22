# coding: utf-8
# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestLanguageFileSystem < MiniTest::Test
  def test_fread
    interpreter = Rpl.new
    interpreter.run '"./spec/test.rpl" fread'

    assert_equal [{:type=>:string, :value=>"1 2 +\n\n« dup dup * * »\n'trrr' sto\n\ntrrr\n"}],
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

    assert_equal true,
                 File.exist?( 'spec/test_fwrite.txt' )

    written_content = File.read( 'spec/test_fwrite.txt' )
    assert_equal 'Ceci est un test de fwrite',
                 written_content

    FileUtils.rm 'spec/test_fwrite.txt'
  end
end
