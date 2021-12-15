# frozen_string_literal: true

module Rpl
  module Lang
    class Dictionary
      attr_reader :vars

      def initialize
        @parser = Parser.new
        @words = {}
        @vars = {}
      end

      def add( name, implementation )
        @words[ name ] = implementation
      end

      def add_var( name, implementation )
        @vars[ name ] = implementation
      end

      def remove_var( name )
        @vars.delete( name )
      end

      def remove_all_vars
        @vars = {}
      end

      def lookup( name )
        word = @words[ name ]
        word ||= @vars[ name ]

        word
      end
    end
  end
end
