# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # swap 2 first stack entries
      def swap( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any any] )

        stack << args[0] << args[1]

        [stack, dictionary]
      end

      # drop n first stack entries
      def dropn( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )
        stack, _args = Rpl::Lang::Core.stack_extract( stack, %i[any] * args[0][:value] )

        [stack, dictionary]
      end

      # drop all stack entries
      def del( _stack, dictionary )
        [[], dictionary]
      end

      # rotate 3 first stack entries
      def rot( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any any any] )

        stack << args[1] << args[0] << args[2]

        [stack, dictionary]
      end

      # duplicate n first stack entries
      def dupn( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )
        n = args[0][:value].to_i
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any] * args[0][:value] )

        args.reverse!

        2.times do
          n.times.each do |i|
            stack << Marshal.load(Marshal.dump( args[i] ))
          end
        end

        [stack, dictionary]
      end

      # push a copy of the given stack level onto the stack
      def pick( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )
        n = args[0][:value].to_i
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any] * args[0][:value] )

        args.reverse!

        n.times.each do |i|
          stack << args[ i ]
        end
        stack << args[0]

        [stack, dictionary]
      end

      # give stack depth
      def depth( stack, dictionary )
        stack << { type: :numeric, base: 10, value: stack.size }

        [stack, dictionary]
      end

      # move a stack entry to the top of the stack
      def roll( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )
        n = args[0][:value]
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any] * args[0][:value] )

        args.reverse!

        (1..(n - 1)).each do |i|
          stack << args[ i ]
        end
        stack << args[0]

        [stack, dictionary]
      end

      # move the element on top of the stack to a higher stack position
      def rolld( stack, dictionary )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )
        n = args[0][:value]
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any] * args[0][:value] )

        args.reverse!

        stack << args[n - 1]

        (0..(n - 2)).each do |i|
          stack << args[ i ]
        end

        [stack, dictionary]
      end

      # implemented in Rpl
      # push a copy of the element in stack level 2 onto the stack
      def over( stack, dictionary )
        stack << { value: '2 pick',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end

      # drop first stack entry
      def drop( stack, dictionary )
        stack << { value: '1 dropn',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end

      # drop 2 first stack entries
      def drop2( stack, dictionary )
        stack << { value: '2 dropn',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end

      # duplicate first stack entry
      def dup( stack, dictionary )
        stack << { value: '1 dupn',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end

      # duplicate 2 first stack entries
      def dup2( stack, dictionary )
        stack << { value: '2 dupn',
                   type: :program }

        Rpl::Lang::Core.eval( stack, dictionary )
      end
    end
  end
end
