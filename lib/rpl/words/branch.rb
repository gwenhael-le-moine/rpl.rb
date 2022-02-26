# frozen_string_literal: true

module RplLang
  module Words
    module Branch
      include Types

      def populate_dictionary
        super

        @dictionary.add_word( ['ift'],
                              'Branch',
                              '( t pt -- … ) eval pt or not based on the value of boolean t',
                              RplProgram.new( '« « nop » ifte »' ) )

        @dictionary.add_word( ['ifte'],
                              'Branch',
                              '( t pt pf -- … ) eval pt or pf based on the value of boolean t',
                              proc do
                                args = stack_extract( [:any, :any, [RplBoolean]] )

                                run( args[ args[2].value ? 1 : 0 ].value )
                              end )

        @dictionary.add_word( ['times'],
                              'Branch',
                              '( p n -- … ) eval p n times while pushing counter on stack before',
                              proc do
                                args = stack_extract( [[RplNumeric], :any] )

                                args[0].value.to_i.times do |counter|
                                  @stack << RplNumeric.new( counter )

                                  run( args[1].value )
                                end
                              end )

        @dictionary.add_word( ['loop'],
                              'Branch',
                              '( p n1 n2 -- … ) eval p looping from n1 to n2 while pushing counter on stack before',
                              proc do
                                args = stack_extract( [[RplNumeric], [RplNumeric], :any] )

                                ((args[1].value.to_i)..(args[0].value.to_i)).each do |counter|
                                  @stack << RplNumeric.new( counter )

                                  run( args[2].value )
                                end
                              end )
      end
    end
  end
end
