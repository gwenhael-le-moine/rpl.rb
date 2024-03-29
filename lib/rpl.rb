# frozen_string_literal: true

require 'rpl/interpreter'
require 'rpl/types'
require 'rpl/words'

class Rpl < Interpreter
  VERSION = '0.17.1'

  include Types

  attr_accessor :live_persistence

  def initialize( stack: [],
                  dictionary: Dictionary.new,
                  persistence_filename: nil,
                  live_persistence: true )
    super( stack:, dictionary: )

    @persistence_filename = persistence_filename
    @live_persistence = live_persistence

    populate_dictionary if @dictionary.words.empty?

    load_persisted_state!
  end

  def load_persisted_state!
    return if @persistence_filename.nil?

    FileUtils.mkdir_p( File.dirname( @persistence_filename ) )
    FileUtils.touch( @persistence_filename )

    run!( "\"#{@persistence_filename}\" feval" )
  end

  def persist_state
    return if @persistence_filename.nil?

    File.write(@persistence_filename, "#{export_lcd}\n#{export_vars}\n#{export_stack}")
  end

  def run!( input )
    stack = super( input )

    persist_state if @live_persistence

    stack
  end

  prepend RplLang::Words::Branch
  prepend RplLang::Words::FileSystem
  prepend RplLang::Words::General
  prepend RplLang::Words::Graphics
  prepend RplLang::Words::List
  prepend RplLang::Words::Logarithm
  prepend RplLang::Words::Mode
  prepend RplLang::Words::OperationsReals
  prepend RplLang::Words::OperationsComplexes
  prepend RplLang::Words::OperationsRealsAndComplexes
  prepend RplLang::Words::Program
  prepend RplLang::Words::REPL
  prepend RplLang::Words::Stack
  prepend RplLang::Words::Store
  prepend RplLang::Words::String
  prepend RplLang::Words::StringAndList
  prepend RplLang::Words::Test
  prepend RplLang::Words::TimeAndDate
  prepend RplLang::Words::Trig

  def populate_dictionary; end
end
