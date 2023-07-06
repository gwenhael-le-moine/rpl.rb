# frozen_string_literal: true

module RplLang
  module Words
    module Graphics
      include Types

      def populate_dictionary
        super

        category = 'GrOb (Graphic Objects)'

        @dictionary.add_word!( ['→grob', '->grob'],
                               category,
                               '( w h d -- g ) make a GrOb from 3 numerics: width, height, data',
                               proc do
                                 args = stack_extract( [[RplNumeric], [RplNumeric], [RplNumeric]] )

                                 @stack << RplGrOb.new( "GROB:#{args[2].value.to_i}:#{args[1].value.to_i}:#{args[0].value.to_i.to_s( 16 )}" )
                               end )
        @dictionary.add_word!( ['grob→', 'grob->'],
                               category,
                               '( g -- w h d ) split a GrOb into its 3 basic numerics',
                               proc do
                                 args = stack_extract( [[RplGrOb]] )

                                 @stack << RplNumeric.new( args[0].width )
                                 @stack << RplNumeric.new( args[0].height )
                                 @stack << RplNumeric.new( args[0].bits, 16 )
                               end )
        @dictionary.add_word!( ['grob2asciiart'],
                               category,
                               '( g -- s ) render a GrOb as a string',
                               proc do
                                 args = stack_extract( [[RplGrOb]] )

                                 @stack << RplString.new( "\"#{args[0].bits.to_s(2).scan(/.{1,#{args[0].width}}/).join("\n")}\"" )
                               end )

        category = 'Display management and manipulation'

        @dictionary.add_word!( ['displayon'],
                               category,
                               '( -- ) display display',
                               proc do
                                 @show_display = true
                               end )
        @dictionary.add_word!( ['displayoff'],
                               category,
                               '( -- ) hide display',
                               proc do
                                 @show_display = false
                               end )

        @dictionary.add_word!( ['displaywidth→', 'displaywidth->'],
                               category,
                               '( -- i ) put framebuffer\'s width on stack',
                               proc do
                                 @stack << RplNumeric.new( @display_width.to_i )
                               end )
        @dictionary.add_word!( ['displayheight→', 'displayheight->'],
                               category,
                               '( -- i ) put framebuffer\'s height on stack',
                               proc do
                                 @stack << RplNumeric.new( @display_height.to_i )
                               end )

        @dictionary.add_word!( ['→displaywidth', '->displaywidth'],
                               category,
                               '( i -- ) set framebuffer\'s width',
                               proc do
                                 args = stack_extract( [[RplNumeric]] )

                                 @display_width = args[0].value.to_i
                               end )
        @dictionary.add_word!( ['→displayheight', '->displayheight'],
                               category,
                               '( i -- ) set framebuffer\'s height',
                               proc do
                                 args = stack_extract( [[RplNumeric]] )

                                 @display_height = args[0].value.to_i
                               end )

        @dictionary.add_word!( ['display→', 'display->'],
                               category,
                               '( -- g ) export framebuffer to GrOb',
                               proc do
                                 @stack << RplGrOb.new( "GROB:#{@display_width}:#{@display_height}:#{@framebuffer.to_i.to_s( 16 )}" )
                               end )
        # @dictionary.add_word!( ['→display', '->display'],
        #                        category,
        #                        '( g -- ) import GrOb into framebuffer',
        #                        proc do
        #                          args = stack_extract( [[RplNumeric]] )

        #                          @framebuffer = args[0].value.to_i
        #                        end )

        @dictionary.add_word!( ['pixon'],
                               category,
                               '( x y -- ) turn on pixel at x y coordinates',
                               proc do
                                 args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                 x = args[1].value.to_i
                                 y = args[0].value.to_i

                                 @framebuffer[ ( y * @display_height ) + x ] = 1
                               end )
        @dictionary.add_word!( ['pixoff'],
                               category,
                               '( x y -- ) turn off pixel at x y coordinates',
                               proc do
                                 args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                 x = args[1].value.to_i
                                 y = args[0].value.to_i

                                 @framebuffer[ ( y * @display_height ) + x ] = 0
                               end )
      end
    end
  end
end
