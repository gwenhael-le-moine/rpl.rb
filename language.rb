# frozen_string_literal: true

require './lib/core'
require './lib/dictionary'
require './lib/parser'
require './lib/runner'

module Rpl
  class Language
    attr_reader :stack

    def initialize( stack = [] )
      @stack = stack
      @dictionary = Rpl::Lang::Dictionary.new
      @parser = Rpl::Lang::Parser.new
      @runner = Rpl::Lang::Runner.new
    end

    def run( input )
      @stack, @dictionary = @runner.run_input( @parser.parse_input( input ),
                                               @stack, @dictionary )
    end
  end
end
