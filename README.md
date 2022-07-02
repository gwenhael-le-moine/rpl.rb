# rpl.rb

https://github.com/louisrubet/rpn/ inspired language in ruby

To run REPL locally: `rake run`

To run the test suite: `rake test`

# TODO-list
  * save & load state image (as RPL code? as JSON?)
    . store all variables and subdirs currently defined
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
