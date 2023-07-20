# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/math'
require 'bigdecimal/util'

require 'rpl/dictionary'
require 'rpl/types'

class Interpreter
  include BigMath
  include Types

  attr_reader :stack,
              :lcd_grob,
              :dictionary,
              :version

  attr_accessor :show_lcd

  def initialize( stack: [], dictionary: Dictionary.new )
    @dictionary = dictionary
    @stack = stack

    @show_lcd = false

    @lcd_grob = RplGrOb.new( 'GROB:131:64:0' )
  end

  def run!( input )
    @dictionary.add_local_vars_layer!

    Parser.parse( input.to_s ).each do |elt|
      if elt.instance_of?( RplName )
        break if %w[break quit exit].include?( elt.value )

        if elt.not_to_evaluate
          @stack << elt
        else
          command = @dictionary.lookup( elt.value )

          if command.nil?
            @stack << elt
          elsif command.is_a?( Proc )
            command.call
          elsif command.instance_of?( RplProgram )
            run!( command.value )
          else
            @stack << command
          end
        end
      else
        @stack << elt
      end
    end

    @dictionary.remove_local_vars_layer!

    # superfluous but feels nice
    @stack
  end

  def stack_extract( needs )
    raise ArgumentError, 'Not enough elements' if @stack.size < needs.size

    needs.each_with_index do |need, index|
      stack_index = (index + 1) * -1

      raise ArgumentError, "Type Error, needed #{need} got #{@stack[stack_index]}" unless need == :any || need.include?( @stack[stack_index].class )
    end

    args = []
    needs.size.times do
      args << @stack.pop
    end

    args
  end

  def export_vars
    vars_as_string = "@ variables:\n"
    vars_as_string += @dictionary.vars
                                 .map { |name, value| "#{value}\n'#{name}' sto\n" }
                                 .join("\n")

    vars_as_string
  end

  def export_stack
    stack_as_string = "@ stack:\n"
    stack_as_string += @stack.map(&:to_s)
                             .join("\n")

    stack_as_string
  end
end
