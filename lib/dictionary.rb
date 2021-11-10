# coding: utf-8

module Rpn
  class Dictionary
    def initialize
      @parser = Parser.new
      @words = {
        '+' => proc { |stack|
          stack + @parser.parse_input( (stack.pop[:value] + stack.pop[:value]).to_s )
        },
      }
    end

    def add( word )
      @words[ word[:name] ] = word[:value]
    end

    def lookup( name )
      @words[ name ] if @words.include?( name )
    end

    # TODO: alias
  end
end
