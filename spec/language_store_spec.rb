# frozen_string_literal: true

require 'minitest/autorun'

require 'rpl'

class TestLanguageProgram < MiniTest::Test
  def test_sto
    interpreter = Rpl.new
    interpreter.run '« 2 dup * » \'quatre\' sto'
    assert_empty interpreter.stack

    interpreter.run 'quatre'
    assert_equal [{ value: 4, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_lsto
    interpreter = Rpl.new
    interpreter.run "« 2 'deux' lsto deux dup * » eval 'deux' rcl"

    assert_empty interpreter.dictionary.local_vars_layers
    assert_equal [{ value: 4, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run "« 2 'deux' lsto « 3 'trois' lsto trois drop » eval deux dup * » eval 'deux' rcl 'trois' rcl"

    assert_empty interpreter.dictionary.local_vars_layers
    assert_equal [{ value: 4, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_rcl
    interpreter = Rpl.new
    interpreter.run '« 2 dup * » \'quatre\' sto \'quatre\' rcl'
    assert_equal [{ value: '2 dup *', type: :program }],
                 interpreter.stack
  end

  def test_purge
    interpreter = Rpl.new
    interpreter.run '« 2 dup * » \'quatre\' sto \'quatre\' purge'
    assert_nil interpreter.dictionary.lookup( 'quatre' )
  end

  def test_vars
    interpreter = Rpl.new
    interpreter.run '« 2 dup * » \'quatre\' sto 1 \'un\' sto vars'
    assert_equal [{ value: [{ type: :name, value: 'quatre' },
                            { type: :name, value: 'un' }], type: :list }],
                 interpreter.stack
  end

  def test_clusr
    interpreter = Rpl.new
    interpreter.run '« 2 dup * » \'quatre\' sto 1 \'un\' sto clusr'
    assert_empty interpreter.dictionary.vars
  end

  def test_sto_add
    interpreter = Rpl.new
    interpreter.run '1 \'test\' sto \'test\' 3 sto+ \'test\' rcl'
    assert_equal [{ value: 4, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 \'test\' sto 3 \'test\' sto+ \'test\' rcl'
    assert_equal [{ value: 4, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_sto_subtract
    interpreter = Rpl.new
    interpreter.run '1 \'test\' sto \'test\' 3 sto- \'test\' rcl'
    assert_equal [{ value: -2, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '1 \'test\' sto 3 \'test\' sto- \'test\' rcl'
    assert_equal [{ value: -2, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_sto_multiply
    interpreter = Rpl.new
    interpreter.run '2 \'test\' sto \'test\' 3 sto* \'test\' rcl'
    assert_equal [{ value: 6, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '2 \'test\' sto 3 \'test\' sto* \'test\' rcl'
    assert_equal [{ value: 6, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_sto_divide
    interpreter = Rpl.new
    interpreter.run '3 \'test\' sto \'test\' 2.0 sto÷ \'test\' rcl'
    assert_equal [{ value: 1.5, type: :numeric, base: 10 }],
                 interpreter.stack

    interpreter = Rpl.new
    interpreter.run '3 \'test\' sto 2.0 \'test\' sto÷ \'test\' rcl'
    assert_equal [{ value: 1.5, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_sto_negate
    interpreter = Rpl.new
    interpreter.run '3 \'test\' sto \'test\' sneg \'test\' rcl'
    assert_equal [{ value: -3, type: :numeric, base: 10 }],
                 interpreter.stack
  end

  def test_sto_inverse
    interpreter = Rpl.new
    interpreter.run '2 \'test\' sto \'test\' sinv \'test\' rcl'
    assert_equal [{ value: 0.5, type: :numeric, base: 10 }],
                 interpreter.stack
  end
end
