# frozen_string_literal: true

require 'rpl/types'

require 'rpl/interpreter'

require 'rpl/words'

class Rpl < Interpreter
  def initialize( stack = [], dictionary = Dictionary.new )
    super

    populate_dictionary if @dictionary.words.empty?
  end

  prepend RplLang::Words::Branch
  prepend RplLang::Words::FileSystem
  prepend RplLang::Words::General
  prepend RplLang::Words::Logarithm
  prepend RplLang::Words::Mode
  prepend RplLang::Words::Operations
  prepend RplLang::Words::Program
  prepend RplLang::Words::Stack
  prepend RplLang::Words::Store
  prepend RplLang::Words::StringAndList
  prepend RplLang::Words::Test
  prepend RplLang::Words::TimeAndDate
  prepend RplLang::Words::Trig

  def populate_dictionary; end
end
