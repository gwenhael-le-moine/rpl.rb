# frozen_string_literal: true

module RplLang
  module Words
    module Display
      include Types

      def populate_dictionary
        super

        @dictionary.add_word( ['erase'],
                              'Display',
                              '( -- ) erase display',
                              proc do
                                initialize_frame_buffer
                              end )

        @dictionary.add_word( ['display→', 'display->'],
                              'Display',
                              '( -- pict ) put current display state on stack',
                              proc do
                                @stack << @frame_buffer # FIXME: RplPict type
                              end )
      end
    end
  end
end
