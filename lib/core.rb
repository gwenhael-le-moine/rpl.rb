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

    def version
      0
    end

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

    def eval( stack, dictionary, rplcode )
      preparsed_input = rplcode.gsub( '\n', ' ' ).strip if rplcode.is_a?( String )

      interpreter = Rpl::Interpreter.new( stack, dictionary )
      interpreter.run( preparsed_input )

      [interpreter.stack, interpreter.dictionary]
    end

    def stringify( elt )
      case elt[:type]
      when :numeric
        prefix = case elt[:base]
                 when 2
                   '0b'
                 when 8
                   '0o'
                 when 10
                   ''
                 when 16
                   '0x'
                 else
                   "0#{elt[:base]}_"
                 end

        suffix = if elt[:value].to_i == elt[:value]
                   elt[:value].to_i
                 else
                   elt[:value].to_s('F')
                 end
        suffix = elt[:value].to_s( elt[:base] ) unless elt[:base] == 10

        "#{prefix}#{suffix}"
      when :list
        "[#{elt[:value].map { |e| format_element( e ) }.join(', ')}]"
      when :program
        "« #{elt[:value]} »"
      when :string
        "\"#{elt[:value]}\""
      when :name
        "'#{elt[:value]}'"
      else
        elt[:value]
      end
    end

    def infer_resulting_base( numerics )
      10 if numerics.length.zero?

      numerics.last[:base]
    end

    ### DEBUG ###
    def __pp_stack( stack, dictionary )
      pp stack

      [stack, dictionary]
    end
  end
end
