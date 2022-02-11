# frozen_string_literal: true

module RplLang
  module Core
    module Branch
      def populate_dictionary
        super

        @dictionary.add_word( ['ift'],
                              'Branch',
                              '( t pt -- … ) eval pt or not based on the value of boolean t',
                              proc do
                                run( '« nop » ifte' )
                              end )
        @dictionary.add_word( ['ifte'],
                              'Branch',
                              '( t pt pf -- … ) eval pt or pf based on the value of boolean t',
                              proc do
                                args = stack_extract( [:any, :any, %i[boolean]] )

                                run( args[ args[2][:value] ? 1 : 0 ][:value] )
                              end )
        @dictionary.add_word( ['times'],
                              'Branch',
                              '( n p -- … ) eval p n times while pushing counter on stack before',
                              proc do
                                args = stack_extract( [:any, %i[numeric]] )

                                args[1][:value].to_i.times do |i|
                                  counter = { value: BigDecimal( i, @precision ), type: :numeric, base: 10 }
                                  @stack << counter

                                  run( args[0][:value] )
                                end

                              end ) # specific
        @dictionary.add_word( ['loop'],
                              'Branch',
                              '( n1 n2 p -- … ) eval p looping from n1 to n2 while pushing counter on stack before',
                              proc do
                                args = stack_extract( [:any, %i[numeric], %i[numeric]] )

                                ((args[2][:value].to_i)..(args[1][:value].to_i)).each do |i|
                                  counter = { value: BigDecimal( i, @precision ), type: :numeric, base: 10 }
                                  @stack << counter

                                  run( args[0][:value] )
                                end
                              end ) # specific
      end
    end
  end
end
