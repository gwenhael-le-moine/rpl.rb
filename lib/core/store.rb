# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # store a variable. ex: 1 'name' sto
      def sto( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[name], :any] )

        dictionary.add_var( args[0][:value],
                            proc { |stk, dict, rcl_only = false|
                              stk << args[1]

                              if rcl_only
                                [stk, dict]
                              else
                                Rpl::Lang::Core.eval( stk, dict )
                              end
                            } )

        [stack, dictionary]
      end

      # store a local variable
      def lsto( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[name], :any] )

        dictionary.add_local_var( args[0][:value],
                                  proc { |stk, dict, rcl_only = false|
                                    stk << args[1]

                                    if rcl_only
                                      [stk, dict]
                                    else
                                      Rpl::Lang::Core.eval( stk, dict )
                                    end
                                  } )

        [stack, dictionary]
      end

      # recall a variable. ex: 'name' rcl
      def rcl( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[name]] )

        word = dictionary.lookup( args[0][:value] )

        stack, dictionary = word.call( stack, dictionary, true ) unless word.nil?

        [stack, dictionary]
      end

      # delete a variable. ex: 'name' purge
      def purge( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[name]] )

        dictionary.remove_var( args[0][:value] )

        [stack, dictionary]
      end

      # list all variables
      def vars( stack, dictionary )
        stack << { type: :list,
                   value: dictionary.vars.keys + dictionary.local_vars_layers.reduce([]) { |memo, layer| memo + layer.keys } }

        [stack, dictionary]
      end

      # erase all variables
      def clusr( stack, dictionary )
        dictionary.remove_all_vars

        [stack, dictionary]
      end

      # add to a stored variable. ex: 1 'name' sto+ 'name' 2 sto+
      def sto_add( stack, dictionary )
        stack << { value: '
  dup type "name" ==
  « swap »
  ift
  over rcl + swap sto',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end

      # substract to a stored variable. ex: 1 'name' sto- 'name' 2 sto-
      def sto_subtract( stack, dictionary )
        stack << { value: '
  dup type "name" ==
  « swap »
  ift
  over rcl swap - swap sto',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end

      # multiply a stored variable. ex: 3 'name' sto* 'name' 2 sto*
      def sto_multiply( stack, dictionary )
        stack << { value: '
  dup type "name" ==
  « swap »
  ift
  over rcl * swap sto',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end

      # divide a stored variable. ex: 3 'name' sto/ 'name' 2 sto/
      def sto_divide( stack, dictionary )
        stack << { value: '
  dup type "name" ==
  « swap »
  ift
  over rcl swap / swap sto',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end

      # negate a variable. ex: 'name' sneg
      def sto_negate( stack, dictionary )
        stack << { value: 'dup rcl chs swap sto',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end

      # inverse a variable. ex: 1 'name' sinv
      def sto_inverse( stack, dictionary )
        stack << { value: 'dup rcl inv swap sto',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end
    end
  end
end
