# rpl.rb

Reverse-Polish-Lisp inspired language in ruby

To run REPL locally: `rake run`

To run the test suite: `rake test`

To build gem: `rake gem`

# known bugs
 -

# TODO-list
  * Language:
    * pseudo filesystem: subdir/namespace for variables
      . 'a dir' crdir 'a dir' cd vars
  * SDL-based graphic environment/API

# Not yet implemented
```sh
$ grep "# @dictionary.add_word" ./lib/rpl/words/*.rb
./lib/rpl/words/logarithm.rb:        # @dictionary.add_word( ['ln'],
./lib/rpl/words/logarithm.rb:        # @dictionary.add_word( ['lnp1'],
./lib/rpl/words/logarithm.rb:        # @dictionary.add_word( ['exp'],
./lib/rpl/words/logarithm.rb:        # @dictionary.add_word( ['expm'],
./lib/rpl/words/logarithm.rb:        # @dictionary.add_word( ['log10'],
./lib/rpl/words/logarithm.rb:        # @dictionary.add_word( ['alog10'],
./lib/rpl/words/logarithm.rb:        # @dictionary.add_word( ['log2'],
./lib/rpl/words/logarithm.rb:        # @dictionary.add_word( ['alog2'],
./lib/rpl/words/logarithm.rb:        # @dictionary.add_word( ['sinh'],
./lib/rpl/words/logarithm.rb:        # @dictionary.add_word( ['asinh'],
./lib/rpl/words/logarithm.rb:        # @dictionary.add_word( ['cosh'],
./lib/rpl/words/logarithm.rb:        # @dictionary.add_word( ['acosh'],
./lib/rpl/words/logarithm.rb:        # @dictionary.add_word( ['tanh'],
./lib/rpl/words/logarithm.rb:        # @dictionary.add_word( ['atanh'],
./lib/rpl/words/mode.rb:        # @dictionary.add_word( ['std'],
./lib/rpl/words/mode.rb:        # @dictionary.add_word( ['fix'],
./lib/rpl/words/mode.rb:        # @dictionary.add_word( ['sci'],
./lib/rpl/words/mode.rb:        # @dictionary.add_word( ['round'],
./lib/rpl/words/operations-complexes.rb:        # @dictionary.add_word( ['p→r', 'p->r'],
./lib/rpl/words/operations-complexes.rb:        # @dictionary.add_word( ['r→p', 'r->p'],
```

# No implementation planned
  * use IFT, IFTE instead of
    . if
    . then
    . else
    . end
  * use LOOP, TIMES instead of
    . start
    . for
    . next
    . step
    . do
    . until
    . while
    . repeat
  * use LSTO instead of
    . ->, →

# inspirations and references
  * https://en.wikipedia.org/wiki/RPL_(programming_language)
  * https://github.com/louisrubet/rpn/
