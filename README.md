# rpl.rb

https://github.com/louisrubet/rpn/ inspired language in ruby

To run REPL locally: `rake run`

To run the test suite: `rake test`

# BUGs
  * var1 var2 +|-|*|\ ===> result in on stack (normal) AND stored in var1 (_bug_)

# TODO-list
  * pseudo filesystem: subdir/namespace for variables
    . 'a dir' crdir 'a dir' cd vars
  * SDL-based graphic environment/API

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
