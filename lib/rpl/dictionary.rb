# frozen_string_literal: true

class Dictionary
  attr_reader :words,
              :vars,
              :local_vars_layers

  def initialize
    @words = {}
    @vars = {}
    @local_vars_layers = []
  end

  def add_word( names, category, help, implementation )
    names.each do |name|
      @words[ name ] = { category: category,
                         help: help,
                         implementation: implementation }
    end
  end

  def add_var( name, implementation )
    @vars[ name ] = implementation
  end

  def remove_vars( names )
    names.each do |name|
      @vars.delete( name )
    end
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
    names.each do |name|
      @local_vars_layers.last.delete( name )
    end
  end

  def remove_local_var( name )
    remove_local_vars( [name] )
  end

  def remove_local_vars_layer
    @local_vars_layers.pop
  end

  def lookup( name )
    # look in local variables from the deepest layer up
    local_vars_layer = @local_vars_layers.reverse.find { |layer| layer[ name ] }
    word = local_vars_layer.nil? ? nil : local_vars_layer[ name ]

    # otherwise look in (global) variables
    word ||= @vars[ name ]

    # or is it a core word
    word ||= @words[ name ].nil? ? nil : @words[ name ][:implementation]

    word
  end
end
