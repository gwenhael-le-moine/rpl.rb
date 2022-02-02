# frozen_string_literal: true

module Rpl
  module Lang
    class Dictionary
      attr_reader :vars,
                  :local_vars_layers

      def initialize
        @parser = Parser.new
        @words = {}
        @vars = {}
        @local_vars_layers = []
      end

      def add( name, implementation )
        @words[ name ] = implementation
      end

      def add_var( name, implementation )
        @vars[ name ] = implementation
      end

      def remove_vars( names )
        names.each { |name| @vars.delete( name ) }
      end

      def remove_var( name )
        remove_vars( [name] )
      end

      def remove_all_vars
        @vars = {}
      end

      def add_local_vars_layer
        @local_vars_layers << {}
      end

      def add_local_var( name, implementation )
        @local_vars_layers.last[ name ] = implementation
      end

      def remove_local_vars( names )
        names.each { |name| @local_vars_layers.last.delete( name ) }
      end

      def remove_local_var( name )
        remove_local_vars( [name] )
      end

      def remove_local_vars_layer
        @local_vars_layers.pop
      end

      def lookup( name )
        local_var = @local_vars_layers.reverse.find { |layer| layer[ name ] }
        word = local_var.nil? ? nil : local_var[name]
        word ||= @vars[ name ]
        word ||= @words[ name ]

        word
      end
    end
  end
end
