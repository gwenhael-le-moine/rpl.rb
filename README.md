# rpl.rb

https://github.com/louisrubet/rpn/ inspired language in ruby

To run REPL locally: `ruby -Ilib bin/rpl`

To run the test suite: `find ./spec/ -name \*.rb -exec ruby -Ilib {} \;`

# TODO-list
  * allow comments, using '#'
  * pseudo filesystem: subdir for variables
  * UI toolkit (based on https://github.com/AndyObtiva/glimmer-dsl-libui ?)

# Not implemented
  * use IFT, IFTE
    . if
    . then
    . else
    . end
  * use LOOP, TIMES
    . start
    . for
    . next
    . step
    . do
    . until
    . while
    . repeat
  * use LSTO
    . ->, →
  * edit
