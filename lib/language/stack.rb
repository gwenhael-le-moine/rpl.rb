module Rpl
  module Lang
    module Core
      module_function

      # swap 2 first stack entries
      def swap( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any any] )

        stack << args[0] << args[1]
      end

      # drop first stack entry
      def drop( stack )
        dropn( stack << { type: :numeric, base: 10, value: 1 } )
      end

      # drop 2 first stack entries
      def drop2( stack )
        dropn( stack << { type: :numeric, base: 10, value: 2 } )
      end

      # drop n first stack entries
      def dropn( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )
        stack, _args = Rpl::Lang::Core.stack_extract( stack, %i[any] * args[0][:value] )

        stack
      end

      # drop all stack entries
      def del( _stack )
        []
      end

      # rotate 3 first stack entries
      def rot( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any any any] )

        stack << args[1] << args[0] << args[2]
      end

      # duplicate first stack entry
      def dup( stack )
        dupn( stack << { type: :numeric, base: 10, value: 1 } )
      end

      # duplicate 2 first stack entries
      def dup2( stack )
        dupn( stack << { type: :numeric, base: 10, value: 2 } )
      end

      # duplicate n first stack entries
      def dupn( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )
        n = args[0][:value]
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any] * args[0][:value] )

        args.reverse!

        2.times do
          n.times.each do |i|
            stack << args[ i ]
          end
        end

        stack
      end

      # push a copy of the given stack level onto the stack
      def pick( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )
        n = args[0][:value]
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any] * args[0][:value] )

        args.reverse!

        n.times.each do |i|
          stack << args[ i ]
        end
        stack << args[0]

        stack
      end

      # give stack depth
      def depth( stack )
        stack << { type: :numeric, base: 10, value: stack.size }
      end

      # move a stack entry to the top of the stack
      def roll( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )
        n = args[0][:value]
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any] * args[0][:value] )

        args.reverse!

        (1..(n - 1)).each do |i|
          stack << args[ i ]
        end
        stack << args[0]

        stack
      end

      # move the element on top of the stack to a higher stack position
      def rolld( stack )
        stack, args = Rpl::Lang::Core.stack_extract( stack, [%i[numeric]] )
        n = args[0][:value]
        stack, args = Rpl::Lang::Core.stack_extract( stack, %i[any] * args[0][:value] )

        args.reverse!

        stack << args[n - 1]

        (0..(n - 2)).each do |i|
          stack << args[ i ]
        end

        stack
      end

      # push a copy of the element in stack level 2 onto the stack
      def over( stack )
        pick( stack << { type: :numeric, base: 10, value: 2 } )
      end
    end
  end
end
