# coding: utf-8
require_relative "../lib/parser"

require 'test/unit'

class TestParser < Test::Unit::TestCase
    def test_parse_input_number
        result = parse_input( "1" )
        assert_equal [ { 'value' => 1, 'type' => 'NUMBER' } ], result
    end

    def test_parse_input_word
        result = parse_input( "dup" )
        assert_equal [ { 'value' => "dup", 'type' => 'WORD' } ], result
    end

    def test_parse_input_string
        result = parse_input( "\"test\"" )
        assert_equal [ { 'value' => "test", 'type' => 'STRING' } ], result
    end

    def test_parse_input_name
        result = parse_input( "'test'" )
        assert_equal [ { 'value' => "test", 'type' => 'NAME' } ], result
    end

    def test_parse_input_program
        result = parse_input( "« test »" )
        assert_equal [ { 'value' => "test", 'type' => 'PROGRAM' } ], result

        result = parse_input( "«test »" )
        assert_equal [ { 'value' => "test", 'type' => 'PROGRAM' } ], result

        result = parse_input( "« test test »" )
        assert_equal [ { 'value' => "test test", 'type' => 'PROGRAM' } ], result

        result = parse_input( "« test \"test\" test »" )
        assert_equal [ { 'value' => "test \"test\" test", 'type' => 'PROGRAM' } ], result
    end

    def test_parse_input_number_number
        result = parse_input( "2 3" )
        assert_equal [ { 'value' => 2, 'type' => 'NUMBER' }, { 'value' => 3, 'type' => 'NUMBER' } ], result
    end

    def test_parse_input_number_string
        result = parse_input( "4 \"test\"" )
        assert_equal [ { 'value' => 4, 'type' => 'NUMBER' }, { 'value' => "test", 'type' => 'STRING' } ], result
    end
end
