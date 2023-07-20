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

        category = 'Lcd management and manipulation'

        @dictionary.add_word!( ['lcdon'],
                               category,
                               '( -- ) display lcd',
                               proc do
                                 @show_lcd = true
                               end )
        @dictionary.add_word!( ['lcdoff'],
                               category,
                               '( -- ) hide lcd',
                               proc do
                                 @show_lcd = false
                               end )

        @dictionary.add_word!( ['lcdwidth'],
                               category,
                               '( -- i ) put framebuffer\'s width on stack',
                               proc do
                                 @stack << RplNumeric.new( @lcd_grob.width )
                               end )
        @dictionary.add_word!( ['lcdheight'],
                               category,
                               '( -- i ) put framebuffer\'s height on stack',
                               proc do
                                 @stack << RplNumeric.new( @lcd_grob.height )
                               end )

        @dictionary.add_word!( ['→lcdwidth', '->lcdwidth'],
                               category,
                               '( i -- ) set framebuffer\'s width',
                               proc do
                                 args = stack_extract( [[RplNumeric]] )

                                 @lcd_grob.width = args[0].value.to_i
                               end )
        @dictionary.add_word!( ['→lcdheight', '->lcdheight'],
                               category,
                               '( i -- ) set framebuffer\'s height',
                               proc do
                                 args = stack_extract( [[RplNumeric]] )

                                 @lcd_grob.height = args[0].value.to_i
                               end )

        @dictionary.add_word!( ['lcd→', 'lcd->'],
                               category,
                               '( -- g ) export framebuffer to GrOb',
                               proc do
                                 @stack << RplGrOb.new( @lcd_grob )
                               end )
        @dictionary.add_word!( ['→lcd', '->lcd'],
                               category,
                               '( g -- ) import GrOb into framebuffer',
                               proc do
                                 args = stack_extract( [[RplGrOb]] )

                                 @lcd_grob = RplGrOb.new( args[0] )
                               end )

        @dictionary.add_word!( ['pixon'],
                               category,
                               '( x y -- ) turn on pixel at x y coordinates',
                               proc do
                                 args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                 x = args[1].value.to_i
                                 y = args[0].value.to_i

                                 @lcd_grob.set_pixel(x, y, 1)
                               end )
        @dictionary.add_word!( ['pixoff'],
                               category,
                               '( x y -- ) turn off pixel at x y coordinates',
                               proc do
                                 args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                 x = args[1].value.to_i
                                 y = args[0].value.to_i

                                 @lcd_grob.set_pixel(x, y, 0) # FIXME: toggle pixel instead of turning it off
                               end )
        @dictionary.add_word!( ['pix?'],
                               category,
                               '( x y -- b ) return boolean state of pixel at x y coordinates',
                               proc do
                                 args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                 x = args[1].value.to_i
                                 y = args[0].value.to_i

                                 @stack << RplBoolean.new( @lcd_grob.get_pixel(x, y) == 1 )
                               end )

        @dictionary.add_word!( ['blank'],
                               category,
                               '( w h -- g ) create an empty GrOb',
                               proc do
                                 args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                 w = args[1].value.to_i
                                 h = args[0].value.to_i

                                 @stack << RplGrOb.new( "GROB:#{w}:#{h}:0" )
                               end )
      end
    end
  end
end
