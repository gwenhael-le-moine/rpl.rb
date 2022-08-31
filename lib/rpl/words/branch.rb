# frozen_string_literal: true

module RplLang
  module Words
    module Branch
      include Types

      def populate_dictionary
        super

        category = 'Branch'

        @dictionary.add_word( ['ift'],
                              category,
                              '( t pt -- … ) eval pt or not based on the value of boolean t',
                              Types.new_object( RplProgram, '« « nop » ifte »' ) )

        @dictionary.add_word( ['ifte'],
                              category,
                              '( t pt pf -- … ) eval pt or pf based on the value of boolean t',
                              proc do
                                args = stack_extract( [:any, :any, [RplBoolean]] )

                                run( args[ args[2].value ? 1 : 0 ].value )
                              end )

        @dictionary.add_word( ['times'],
                              category,
                              '( p n -- … ) eval p n times while pushing counter on stack before',
                              proc do
                                args = stack_extract( [[RplNumeric], :any] )

                                args[0].value.to_i.times do |counter|
                                  @stack << Types.new_object( RplNumeric, counter )

                                  run( args[1].value )
                                end
                              end )

        @dictionary.add_word( ['loop'],
                              category,
                              '( p n1 n2 -- … ) eval p looping from n1 to n2 while pushing counter on stack before',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric], :any] )

                                ((args[1].value.to_i)..(args[0].value.to_i)).each do |counter|
                                  @stack << Types.new_object( RplNumeric, counter )

                                  run( args[2].value )
                                end
                              end )
      end
    end
  end
end
