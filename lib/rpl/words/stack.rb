# frozen_string_literal: true

module RplLang
  module Words
    module Stack
      include Types

      def populate_dictionary
        super

        category = 'Stack'

        @dictionary.add_word( ['swap'],
                              category,
                              '( a b -- b a ) swap 2 first stack elements',
                              proc do
                                args = stack_extract( %i[any any] )

                                @stack << args[0] << args[1]
                              end )

        @dictionary.add_word( ['drop'],
                              category,
                              '( a -- ) drop first stack element',
                              Types.new_object( RplProgram, '« 1 dropn »' ) )

        @dictionary.add_word( ['drop2'],
                              category,
                              '( a b -- ) drop first two stack elements',
                              proc do
                                run( '2 dropn' )
                              end )

        @dictionary.add_word( ['dropn'],
                              category,
                              '( a b … n -- ) drop first n stack elements',
                              proc do
                                args = stack_extract( [[RplNumeric]] )

                                _args = stack_extract( %i[any] * args[0].value )
                              end )

        @dictionary.add_word( ['del'],
                              category,
                              '( a b … -- ) drop all stack elements',
                              proc do
                                @stack = []
                              end)

        @dictionary.add_word( ['rot'],
                              category,
                              '( a b c -- b c a ) rotate 3 first stack elements',
                              proc do
                                args = stack_extract( %i[any any any] )

                                @stack << args[1] << args[0] << args[2]
                              end )

        @dictionary.add_word( ['dup'],
                              category,
                              '( a -- a a ) duplicate first stack element',
                              Types.new_object( RplProgram, '« 1 dupn »' ) )

        @dictionary.add_word( ['dup2'],
                              category,
                              '( a b -- a b a b ) duplicate first two stack elements',
                              Types.new_object( RplProgram, '« 2 dupn »' ) )

        @dictionary.add_word( ['dupn'],
                              category,
                              '( a b … n -- a b … a b … ) duplicate first n stack elements',
                              proc do
                                args = stack_extract( [[RplNumeric]] )
                                n = args[0].value.to_i
                                args = stack_extract( %i[any] * args[0].value )

                                args.reverse!

                                2.times do
                                  n.times.each do |i|
                                    @stack << Marshal.load(Marshal.dump( args[i] ))
                                  end
                                end
                              end )

        @dictionary.add_word( ['pick'],
                              category,
                              '( … b … n -- … b … b ) push a copy of the given stack level onto the stack',
                              proc do
                                args = stack_extract( [[RplNumeric]] )
                                n = args[0].value.to_i
                                args = stack_extract( %i[any] * args[0].value )

                                args.reverse!

                                n.times.each do |i|
                                  @stack << args[ i ]
                                end

                                @stack << args[0]
                              end )

        @dictionary.add_word( ['depth'],
                              category,
                              '( … -- … n ) push stack depth onto the stack',
                              proc do
                                @stack << Types.new_object( RplNumeric, stack.size )
                              end )

        @dictionary.add_word( ['roll'],
                              category,
                              '( … a -- a … ) move a stack element to the top of the stack',
                              proc do
                                args = stack_extract( [[RplNumeric]] )
                                n = args[0].value
                                args = stack_extract( %i[any] * args[0].value )

                                args.reverse!

                                (1..(n - 1)).each do |i|
                                  @stack << args[ i ]
                                end

                                @stack << args[0]
                              end )

        @dictionary.add_word( ['rolld'],
                              category,
                              '( a … -- … a ) move the element on top of the stack to a higher stack position',
                              proc do
                                args = stack_extract( [[RplNumeric]] )
                                n = args[0].value
                                args = stack_extract( %i[any] * args[0].value )

                                args.reverse!

                                @stack << args[n - 1]

                                (0..(n - 2)).each do |i|
                                  @stack << args[ i ]
                                end
                              end )

        @dictionary.add_word( ['over'],
                              category,
                              '( a b -- a b a ) push a copy of the element in stack level 2 onto the stack',
                              Types.new_object( RplProgram, '« 2 pick »' ) )
      end
    end
  end
end
