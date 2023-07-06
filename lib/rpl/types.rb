# frozen_string_literal: true

require 'rpl/types/boolean'
require 'rpl/types/name'
require 'rpl/types/list'
require 'rpl/types/string'
require 'rpl/types/program'
require 'rpl/types/numeric'
require 'rpl/types/complex'
require 'rpl/types/grob'

module Types
  module_function

  def new_object( type_class, value )
    if type_class.can_parse?( value )
      type_class.new( value )
    else
      RplString.new( "\"Error: cannot create #{type_class} with value #{value}\"" )
    end
  end
end
