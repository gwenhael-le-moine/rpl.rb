# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name             = 'rpl'
  s.version          = '0.17.1'
  s.summary          = 'Functional Stack Language'
  s.description      = 'Reverse-Polish-Lisp inspired language in ruby'
  s.authors          = ['Gwenhael Le Moine']
  s.email            = 'gwenhael@le-moine.org'
  s.homepage         = 'https://github.com/gwenhael-le-moine/rpl.rb'
  s.license          = 'GPL-3.0'
  s.extra_rdoc_files = ['README.md']

  s.files            = [
    'lib/rpl/dictionary.rb',
    'lib/rpl/interpreter.rb',
    'lib/rpl/parser.rb',
    'lib/rpl/types/boolean.rb',
    'lib/rpl/types/complex.rb',
    'lib/rpl/types/grob.rb',
    'lib/rpl/types/list.rb',
    'lib/rpl/types/name.rb',
    'lib/rpl/types/numeric.rb',
    'lib/rpl/types/program.rb',
    'lib/rpl/types/string.rb',
    'lib/rpl/types.rb',
    'lib/rpl/words/branch.rb',
    'lib/rpl/words/filesystem.rb',
    'lib/rpl/words/general.rb',
    'lib/rpl/words/graphics.rb',
    'lib/rpl/words/list.rb',
    'lib/rpl/words/logarithm.rb',
    'lib/rpl/words/mode.rb',
    'lib/rpl/words/operations-complexes.rb',
    'lib/rpl/words/operations-reals-complexes.rb',
    'lib/rpl/words/operations-reals.rb',
    'lib/rpl/words/program.rb',
    'lib/rpl/words/repl.rb',
    'lib/rpl/words/stack.rb',
    'lib/rpl/words/store.rb',
    'lib/rpl/words/string-list.rb',
    'lib/rpl/words/string.rb',
    'lib/rpl/words/test.rb',
    'lib/rpl/words/time-date.rb',
    'lib/rpl/words/trig.rb',
    'lib/rpl/words.rb',
    'lib/rpl.rb'
  ]

  s.add_dependency 'drawille', '~> 0.3.3'

  s.executables << 'rpl'

  s.required_ruby_version = '> 2.7'
  s.metadata['rubygems_mfa_required'] = 'true'
end
