
test: run

run:
	node_modules/.bin/mocha --compilers coffee:coffee-script/register index.coffee
