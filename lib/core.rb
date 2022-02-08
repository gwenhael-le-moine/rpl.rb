# frozen_string_literal: true

require 'bigdecimal/math'

require_relative './core/branch'
require_relative './core/general'
require_relative './core/mode'
require_relative './core/operations'
require_relative './core/program'
require_relative './core/stack'
require_relative './core/store'
require_relative './core/string'
require_relative './core/test'
require_relative './core/time-date'
require_relative './core/trig'
require_relative './core/logs'
require_relative './core/filesystem'
require_relative './core/list'

module Rpl
  module Lang
    module_function

    include BigMath

    def precision
      @precision or 12
    end

    def precision=( value )
      @precision = value
    end

    def stack_extract( stack, needs )
      raise ArgumentError, 'Not enough elements' if stack.size < needs.size

      args = []
      needs.each do |need|
        elt = stack.pop

        raise ArgumentError, "Type Error, needed #{need} got #{elt[:type]}" unless need == :any || need.include?( elt[:type] )

        args << elt
      end

      [stack, args]
    end

    def infer_resulting_base( numerics )
      10 if numerics.length.zero?

      numerics.last[:base]
    end

    def eval( stack, dictionary, rplcode )
      preparsed_input = rplcode.gsub( '\n', ' ' ).strip if rplcode.is_a?( String )
      parsed_input = Rpl::Lang.parse_input( preparsed_input.to_s )

      Rpl::Lang.run_input( parsed_input,
                           stack, dictionary )
    end

    ### DEBUG ###
    def __pp_stack( stack, dictionary )
      pp stack

      [stack, dictionary]
    end
  end
end
