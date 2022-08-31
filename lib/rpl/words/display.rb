# frozen_string_literal: true

module RplLang
  module Words
    module Display
      include Types

      def populate_dictionary
        super

        category = 'Display'

        @dictionary.add_word( ['erase'],
                              category,
                              '( -- ) erase display',
                              proc do
                                initialize_frame_buffer
                              end )

        @dictionary.add_word( ['display→', 'display->'],
                              category,
                              '( -- pict ) put current display state on stack',
                              proc do
                                @stack << @frame_buffer # FIXME: RplPict type
                              end )
      end
    end
  end
end
