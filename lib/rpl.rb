# frozen_string_literal: true

require 'rpl/interpreter'

require 'rpl/core/branch'
require 'rpl/core/general'
require 'rpl/core/mode'
require 'rpl/core/operations'
require 'rpl/core/program'
require 'rpl/core/stack'
require 'rpl/core/store'
require 'rpl/core/string'
require 'rpl/core/test'
require 'rpl/core/time-date'
require 'rpl/core/trig'
require 'rpl/core/logarithm'
require 'rpl/core/filesystem'
require 'rpl/core/list'

class Rpl < Interpreter
  def initialize( stack = [], dictionary = Dictionary.new )
    super

    populate_dictionary if @dictionary.words.empty?
  end

  prepend RplLang::Core::Branch
  prepend RplLang::Core::FileSystem
  prepend RplLang::Core::General
  prepend RplLang::Core::List
  prepend RplLang::Core::Logarithm
  prepend RplLang::Core::Mode
  prepend RplLang::Core::Operations
  prepend RplLang::Core::Program
  prepend RplLang::Core::Stack
  prepend RplLang::Core::Store
  prepend RplLang::Core::String
  prepend RplLang::Core::Test
  prepend RplLang::Core::TimeAndDate
  prepend RplLang::Core::Trig

  def populate_dictionary; end
end
