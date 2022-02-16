# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'rpl'
  s.version     = '0.1.1'
  s.summary     = 'Functional Stack Language'
  s.description = "A language inspired by HP's RPL and https://github.com/louisrubet/rpn/"
  s.authors     = ['Gwenhael Le Moine']
  s.email       = 'gwenhael@le-moine.org'
  s.files       = ['lib/rpl.rb',
                   'lib/rpl/dictionary.rb',
                   'lib/rpl/interpreter.rb',
                   'lib/rpl/core/branch.rb',
                   'lib/rpl/core/filesystem.rb',
                   'lib/rpl/core/general.rb',
                   'lib/rpl/core/list.rb',
                   'lib/rpl/core/logarithm.rb',
                   'lib/rpl/core/mode.rb',
                   'lib/rpl/core/operations.rb',
                   'lib/rpl/core/program.rb',
                   'lib/rpl/core/stack.rb',
                   'lib/rpl/core/store.rb',
                   'lib/rpl/core/string.rb',
                   'lib/rpl/core/test.rb',
                   'lib/rpl/core/time-date.rb',
                   'lib/rpl/core/trig.rb']
  s.homepage    = 'https://github.com/gwenhael-le-moine/rpl.rb'
  s.license     = 'GPL-3.0'

  s.executables << 'rpl'

  s.required_ruby_version = '> 2.7'
end
