gem: rpl.gemspec
	gem build rpl.gemspec

run:
	ruby -Ilib bin/rpl

test:
	find ./spec/ -name \*.rb -exec ruby -Ilib {} \;
