# frozen_string_literal: true

module RplLang
  module Words
    module Graphics
      include Types

      def populate_dictionary
        super

        category = 'Graphics'

        @dictionary.add_word!( ['lcdon'],
                               category,
                               '( -- ) display lcd',
                               proc do
                                 # Sets on a boolean that the REPL will survey and show the Gosu window when true
                                 @show_lcd = true
                               end )

        @dictionary.add_word!( ['lcdoff'],
                               category,
                               '( -- ) hide lcd',
                               proc do
                                 # Sets on a boolean that the REPL will survey and hide the Gosu window when false
                                 @show_lcd = false
                               end )

        @dictionary.add_word!( ['pixon'],
                               category,
                               '( x y -- ) turn on pixel at x y coordinates',
                               proc do
                                 args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                 puts "DEBUG: turn on pixel(x: #{args[1].value}, y: #{args[0].value})"
                                 x = args[1].value.to_i
                                 y = args[0].value.to_i

                                 @frame_buffer[ ( y * @lcd_height ) + x ] = 1
                               end )
        @dictionary.add_word!( ['pixoff'],
                               category,
                               '( x y -- ) turn off pixel at x y coordinates',
                               proc do
                                 args = stack_extract( [[RplNumeric], [RplNumeric]] )

                                 puts "DEBUG: turn off pixel(x: #{args[1].value}, y: #{args[0].value})"
                               end )
      end
    end
  end
end
