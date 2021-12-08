# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TestLanguageProgram < Test::Unit::TestCase
  def test_sto
    lang = Rpl::Language.new
    lang.run '« 2 dup * » \'quatre\' sto'
    assert_empty lang.stack

    lang.run 'quatre'
    assert_equal [{ value: 4, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_rcl
    lang = Rpl::Language.new
    lang.run '« 2 dup * » \'quatre\' sto \'quatre\' rcl'
    assert_equal [{ value: '« 2 dup * »', type: :program }],
                 lang.stack
  end

  def test_purge
    lang = Rpl::Language.new
    lang.run '« 2 dup * » \'quatre\' sto \'quatre\' purge'
    assert_nil lang.dictionary.lookup( 'quatre' )
  end

  def test_vars
    lang = Rpl::Language.new
    lang.run '« 2 dup * » \'quatre\' sto 1 \'un\' sto vars'
    assert_equal [{ value: ["'quatre'", "'un'"], type: :list }],
                 lang.stack
  end

  def test_clusr
    lang = Rpl::Language.new
    lang.run '« 2 dup * » \'quatre\' sto 1 \'un\' sto clusr'
    assert_empty lang.dictionary.vars
  end

  def test_sto_add
    lang = Rpl::Language.new
    lang.run '1 \'test\' sto \'test\' 3 sto+ \'test\' rcl'
    assert_equal [{ value: 4, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '1 \'test\' sto 3 \'test\' sto+ \'test\' rcl'
    assert_equal [{ value: 4, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_sto_subtract
    lang = Rpl::Language.new
    lang.run '1 \'test\' sto \'test\' 3 sto- \'test\' rcl'
    assert_equal [{ value: -2, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '1 \'test\' sto 3 \'test\' sto- \'test\' rcl'
    assert_equal [{ value: -2, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_sto_multiply
    lang = Rpl::Language.new
    lang.run '2 \'test\' sto \'test\' 3 sto* \'test\' rcl'
    assert_equal [{ value: 6, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '2 \'test\' sto 3 \'test\' sto* \'test\' rcl'
    assert_equal [{ value: 6, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_sto_divide
    lang = Rpl::Language.new
    lang.run '3 \'test\' sto \'test\' 2.0 sto÷ \'test\' rcl'
    assert_equal [{ value: 1.5, type: :numeric, base: 10 }],
                 lang.stack

    lang = Rpl::Language.new
    lang.run '3 \'test\' sto 2.0 \'test\' sto÷ \'test\' rcl'
    assert_equal [{ value: 1.5, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_sto_negate
    lang = Rpl::Language.new
    lang.run '3 \'test\' sto \'test\' sneg \'test\' rcl'
    assert_equal [{ value: -3, type: :numeric, base: 10 }],
                 lang.stack
  end

  def test_sto_inverse
    lang = Rpl::Language.new
    lang.run '2 \'test\' sto \'test\' sinv \'test\' rcl'
    assert_equal [{ value: 0.5, type: :numeric, base: 10 }],
                 lang.stack
  end
end
