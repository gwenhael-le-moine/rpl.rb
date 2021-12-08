# frozen_string_literal: true

require 'test/unit'

require_relative '../language'

class TestLanguageProgram < Test::Unit::TestCase
  def test_sto
    stack, dictionary = Rpl::Lang::Core.sto( [{ value: '« 2 dup * »', type: :program },
                                              { value: "'quatre'", type: :name }],
                                             Rpl::Lang::Dictionary.new )
    assert_equal [], stack

    stack, _dictionary = Rpl::Lang::Core.eval( [{ value: 'quatre', type: :word }],
                                               dictionary )
    assert_equal [{ value: 4, type: :numeric, base: 10 }],
                 stack
  end

  def test_rcl
    _stack, dictionary = Rpl::Lang::Core.sto( [{ value: '« 2 dup * »', type: :program },
                                               { value: "'quatre'", type: :name }],
                                              Rpl::Lang::Dictionary.new )

    stack, _dictionary = Rpl::Lang::Core.rcl( [{ value: "'quatre'", type: :name }],
                                              dictionary )
    assert_equal [{ value: '« 2 dup * »', type: :program }],
                 stack
  end

  def test_purge
    _stack, dictionary = Rpl::Lang::Core.sto( [{ value: '« 2 dup * »', type: :program },
                                               { value: "'quatre'", type: :name }],
                                              Rpl::Lang::Dictionary.new )

    _stack, dictionary = Rpl::Lang::Core.purge( [{ value: "'quatre'", type: :name }],
                                                dictionary )
    assert_equal nil,
                 dictionary['quatre']
  end

  def test_vars
    _stack, dictionary = Rpl::Lang::Core.sto( [{ value: '« 2 dup * »', type: :program },
                                               { value: "'quatre'", type: :name }],
                                              Rpl::Lang::Dictionary.new )
    _stack, dictionary = Rpl::Lang::Core.sto( [{ value: 1, type: :numeric, base: 10 },
                                               { value: "'un'", type: :name }],
                                              dictionary )

    stack, _dictionary = Rpl::Lang::Core.vars( [],
                                               dictionary )
    assert_equal [{ value: ["'quatre'", "'un'"], type: :list }],
                 stack
  end

  def test_clusr
    _stack, dictionary = Rpl::Lang::Core.sto( [{ value: '« 2 dup * »', type: :program },
                                               { value: "'quatre'", type: :name }],
                                              Rpl::Lang::Dictionary.new )
    _stack, dictionary = Rpl::Lang::Core.sto( [{ value: 1, type: :numeric, base: 10 },
                                               { value: "'un'", type: :name }],
                                              dictionary )

    _stack, dictionary = Rpl::Lang::Core.clusr( [],
                                                dictionary )
    assert_equal( {},
                  dictionary.vars )
  end

  def test_sto_add
    _stack, dictionary = Rpl::Lang::Core.sto( [{ value: 1, type: :numeric, base: 10 },
                                               { value: "'un'", type: :name }],
                                              Rpl::Lang::Dictionary.new )

    _stack, dictionary = Rpl::Lang::Core.sto_add( [{ value: "'un'", type: :name },
                                                   { value: 3, type: :numeric, base: 10 }],
                                                  dictionary )
    stack, _dictionary = Rpl::Lang::Core.rcl( [{ value: "'un'", type: :name }],
                                              dictionary )
    assert_equal [{ value: 4, type: :numeric, base: 10 }],
                 stack

    _stack, dictionary = Rpl::Lang::Core.sto_add( [{ value: 3, type: :numeric, base: 10 },
                                                   { value: "'un'", type: :name }],
                                                  dictionary )
    stack, _dictionary = Rpl::Lang::Core.rcl( [{ value: "'un'", type: :name }],
                                              dictionary )
    assert_equal [{ value: 7, type: :numeric, base: 10 }],
                 stack
  end

  def test_sto_subtract
    _stack, dictionary = Rpl::Lang::Core.sto( [{ value: 1, type: :numeric, base: 10 },
                                               { value: "'un'", type: :name }],
                                              Rpl::Lang::Dictionary.new )

    _stack, dictionary = Rpl::Lang::Core.sto_subtract( [{ value: "'un'", type: :name },
                                                        { value: 3, type: :numeric, base: 10 }],
                                                       dictionary )
    stack, _dictionary = Rpl::Lang::Core.rcl( [{ value: "'un'", type: :name }],
                                              dictionary )
    assert_equal [{ value: -2, type: :numeric, base: 10 }],
                 stack

    _stack, dictionary = Rpl::Lang::Core.sto_subtract( [{ value: 3, type: :numeric, base: 10 },
                                                        { value: "'un'", type: :name }],
                                                       dictionary )
    stack, _dictionary = Rpl::Lang::Core.rcl( [{ value: "'un'", type: :name }],
                                              dictionary )
    assert_equal [{ value: -5, type: :numeric, base: 10 }],
                 stack
  end

  def test_sto_multiply
    _stack, dictionary = Rpl::Lang::Core.sto( [{ value: 2, type: :numeric, base: 10 },
                                               { value: "'un'", type: :name }],
                                              Rpl::Lang::Dictionary.new )

    _stack, dictionary = Rpl::Lang::Core.sto_multiply( [{ value: "'un'", type: :name },
                                                        { value: 3, type: :numeric, base: 10 }],
                                                       dictionary )
    stack, _dictionary = Rpl::Lang::Core.rcl( [{ value: "'un'", type: :name }],
                                              dictionary )
    assert_equal [{ value: 6, type: :numeric, base: 10 }],
                 stack

    _stack, dictionary = Rpl::Lang::Core.sto_multiply( [{ value: 3, type: :numeric, base: 10 },
                                                        { value: "'un'", type: :name }],
                                                       dictionary )
    stack, _dictionary = Rpl::Lang::Core.rcl( [{ value: "'un'", type: :name }],
                                              dictionary )
    assert_equal [{ value: 18, type: :numeric, base: 10 }],
                 stack
  end

  def test_sto_divide
    _stack, dictionary = Rpl::Lang::Core.sto( [{ value: 2, type: :numeric, base: 10 },
                                               { value: "'un'", type: :name }],
                                              Rpl::Lang::Dictionary.new )

    _stack, dictionary = Rpl::Lang::Core.sto_divide( [{ value: "'un'", type: :name },
                                                      { value: 4.0, type: :numeric, base: 10 }],
                                                     dictionary )
    stack, _dictionary = Rpl::Lang::Core.rcl( [{ value: "'un'", type: :name }],
                                              dictionary )
    assert_equal [{ value: 0.5, type: :numeric, base: 10 }],
                 stack

    _stack, dictionary = Rpl::Lang::Core.sto_divide( [{ value: 5, type: :numeric, base: 10 },
                                                      { value: "'un'", type: :name }],
                                                     dictionary )
    stack, _dictionary = Rpl::Lang::Core.rcl( [{ value: "'un'", type: :name }],
                                              dictionary )
    assert_equal [{ value: 0.1, type: :numeric, base: 10 }],
                 stack
  end

  def test_sto_negate
    _stack, dictionary = Rpl::Lang::Core.sto( [{ value: 2, type: :numeric, base: 10 },
                                               { value: "'un'", type: :name }],
                                              Rpl::Lang::Dictionary.new )

    _stack, dictionary = Rpl::Lang::Core.sto_negate( [{ value: "'un'", type: :name }],
                                                     dictionary )
    stack, _dictionary = Rpl::Lang::Core.rcl( [{ value: "'un'", type: :name }],
                                              dictionary )
    assert_equal [{ value: -2, type: :numeric, base: 10 }],
                 stack
  end

  def test_sto_inverse
    _stack, dictionary = Rpl::Lang::Core.sto( [{ value: 2, type: :numeric, base: 10 },
                                               { value: "'un'", type: :name }],
                                              Rpl::Lang::Dictionary.new )

    _stack, dictionary = Rpl::Lang::Core.sto_inverse( [{ value: "'un'", type: :name }],
                                                      dictionary )
    stack, _dictionary = Rpl::Lang::Core.rcl( [{ value: "'un'", type: :name }],
                                              dictionary )
    assert_equal [{ value: 0.5, type: :numeric, base: 10 }],
                 stack
  end
end
