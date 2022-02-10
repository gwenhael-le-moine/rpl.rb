# frozen_string_literal: true

module Rpl
  module Lang
    module Core
      module_function

      # swap 2 first stack entries
      def swap
        args = stack_extract( %i[any any] )

        @stack << args[0] << args[1]
      end

      # drop n first stack entries
      def dropn
        args = stack_extract( [%i[numeric]] )

        _args = stack_extract( %i[any] * args[0][:value] )
      end

      # drop all stack entries
      def del
        @stack = []
      end

      # rotate 3 first stack entries
      def rot
        args = stack_extract( %i[any any any] )

        @stack << args[1] << args[0] << args[2]
      end

      # duplicate n first stack entries
      def dupn
        args = stack_extract( [%i[numeric]] )
        n = args[0][:value].to_i
        args = stack_extract( %i[any] * args[0][:value] )

        args.reverse!

        2.times do
          n.times.each do |i|
            @stack << Marshal.load(Marshal.dump( args[i] ))
          end
        end
      end

      # push a copy of the given stack level onto the stack
      def pick
        args = stack_extract( [%i[numeric]] )
        n = args[0][:value].to_i
        args = stack_extract( %i[any] * args[0][:value] )

        args.reverse!

        n.times.each do |i|
          @stack << args[ i ]
        end

        @stack << args[0]
      end

      # give stack depth
      def depth
        @stack << { type: :numeric, base: 10, value: stack.size }
      end

      # move a stack entry to the top of the stack
      def roll
        args = stack_extract( [%i[numeric]] )
        n = args[0][:value]
        args = stack_extract( %i[any] * args[0][:value] )

        args.reverse!

        (1..(n - 1)).each do |i|
          @stack << args[ i ]
        end

        @stack << args[0]
      end

      # move the element on top of the stack to a higher stack position
      def rolld
        args = stack_extract( [%i[numeric]] )
        n = args[0][:value]
        args = stack_extract( %i[any] * args[0][:value] )

        args.reverse!

        @stack << args[n - 1]

        (0..(n - 2)).each do |i|
          @stack << args[ i ]
        end
      end

      # implemented in Rpl
      # push a copy of the element in stack level 2 onto the stack
      def over
        run( '2 pick' )
      end

      # drop first stack entry
      def drop
        run( '1 dropn' )
      end

      # drop 2 first stack entries
      def drop2
        run( '2 dropn' )
      end

      # duplicate first stack entry
      def dup
        run( '1 dupn' )
      end

      # duplicate 2 first stack entries
      def dup2
        run( '2 dupn' )
      end
    end
  end
end
