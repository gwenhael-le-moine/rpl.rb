# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestLanguageFileSystem < Minitest::Test
  include Types

  def test_fread
    interpreter = Rpl.new
    interpreter.run! '"./spec/test.rpl" fread'

    assert_equal [Types.new_object( RplString, "\"1 2 +\n\n« dup dup * * »\n'trrr' sto\n\ntrrr\n\"" )],
                 interpreter.stack

    interpreter.run! 'eval vars'
    assert_equal [Types.new_object( RplNumeric, 27 ),
                  Types.new_object( RplList, [Types.new_object( RplName, 'trrr' )] )],
                 interpreter.stack
  end

  def test_feval
    interpreter = Rpl.new
    interpreter.run! '"spec/test.rpl" feval vars'
    assert_equal [Types.new_object( RplNumeric, 27 ),
                  Types.new_object( RplList, [Types.new_object( RplName, 'trrr' )] )],
                 interpreter.stack
  end

  def test_fwrite
    interpreter = Rpl.new
    interpreter.run! '"Ceci est un test de fwrite" "spec/test_fwrite.txt" fwrite'
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
