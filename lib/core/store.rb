# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # store a variable. ex: 1 'name' sto
      def sto
        args = stack_extract( [%i[name], :any] )

        @dictionary.add_var( args[0][:value],
                             args[1] )
      end

      # store a local variable
      def lsto
        args = stack_extract( [%i[name], :any] )

        @dictionary.add_local_var( args[0][:value],
                                   args[1] )
      end

      # recall a variable. ex: 'name' rcl
      def rcl
        args = stack_extract( [%i[name]] )

        content = @dictionary.lookup( args[0][:value] )

        @stack << content unless content.nil?
      end

      # delete a variable. ex: 'name' purge
      def purge
        args = stack_extract( [%i[name]] )

        @dictionary.remove_var( args[0][:value] )
      end

      # list all variables
      def vars
        @stack << { type: :list,
                    value: (@dictionary.vars.keys + @dictionary.local_vars_layers.reduce([]) { |memo, layer| memo + layer.keys }).map { |name| { type: :name, value: name } } }
      end

      # erase all variables
      def clusr
        @dictionary.remove_all_vars
      end

      # add to a stored variable. ex: 1 'name' sto+ 'name' 2 sto+
      def sto_add
        run( '
  dup type "name" ==
  « swap »
  ift
  over rcl + swap sto' )
      end

      # substract to a stored variable. ex: 1 'name' sto- 'name' 2 sto-
      def sto_subtract
        run( '
  dup type "name" ==
  « swap »
  ift
  over rcl swap - swap sto' )
      end

      # multiply a stored variable. ex: 3 'name' sto* 'name' 2 sto*
      def sto_multiply
        run( '
  dup type "name" ==
  « swap »
  ift
  over rcl * swap sto' )
      end

      # divide a stored variable. ex: 3 'name' sto/ 'name' 2 sto/
      def sto_divide
        run( '
  dup type "name" ==
  « swap »
  ift
  over rcl swap / swap sto' )
      end

      # negate a variable. ex: 'name' sneg
      def sto_negate
        run( 'dup rcl chs swap sto' )
      end

      # inverse a variable. ex: 1 'name' sinv
      def sto_inverse
        run( 'dup rcl inv swap sto' )
      end
    end
  end
end
