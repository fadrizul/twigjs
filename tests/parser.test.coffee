###
TwigJS - Parser Test cases
###

# Module dependencies
testCase = require("../dev/nodeunit").testCase
Parser   = require "../lib/parser"

# Comments test cases
exports.Comments = testCase
		"Ignore empty strings" : (test) ->
				parser = new Parser("", {})
				output = parser.parseTokens()
				
				test.deepEqual([], output)
				test.done()
		
		"Ignore line breaks \\n" : (test) ->
				parser = new Parser("\n", {})
				output = parser.parseTokens()
				
				test.deepEqual([], output)
				test.done()
		
		"Ignore comment tags {# #}" : (test) ->
		 		parser = new Parser("{# foor #}", {})
		 		output = parser.parseTokens()

		 		test.deepEqual([], output)
		 		test.done()

exports.Variable = testCase
		"Basic variable {{ }}" : (test) ->
				parser = new Parser("{{ bar }}", {})
				output = parser.parseTokens()
				equals = 
					type 		: Parser.TOKEN_TYPES.VAR
					name 		: "bar"
					filters : []

				test.deepEqual([equals], output)
				test.done()
			
		"Dot-notation variable" : (test) ->
				parser = new Parser("{{ foo.bar }}", {})
				output = parser.parseTokens()
				equals = 
					type 		: Parser.TOKEN_TYPES.VAR
					name 		: "foo.bar"
					filters : []
				
				test.deepEqual([equals], output)
				test.done()

		"Variable with single filter" : (test) ->
				parser  = new Parser("{{ foo|bar }}", {})
				output  = parser.parseTokens()
				filters = 
					name : "bar"
					args : []
				equals  = 
					type 		: Parser.TOKEN_TYPES.VAR
					name 		: "foo"
					filters : [filters]

				test.deepEqual([equals], output)
				test.done()
			
		"Variable with single filter and parameters" : (test) ->
				parser  = new Parser("{{ foo|bar('param',2) }}", {})
				output  = parser.parseTokens()
				filters = 
					name : "bar"
					args : ["param",2]
				equals  = 
					type 		: Parser.TOKEN_TYPES.VAR
					name 		: "foo"
					filters : [filters]

				test.deepEqual([equals], output)
				test.done()

		"Multiple filters" : (test) ->
				parser  = new Parser("{{ foo|bar(1)|baz|rad('params',2) }}", {})
				output  = parser.parseTokens()
				filters = [
				  name : "bar"
				  args : [ 1 ],
				    name : "baz"
				    args : [],
				      name : "rad"
				      args : ["params", 2]
				]
				equals  = 
					type 		: Parser.TOKEN_TYPES.VAR
					name 		: "foo"
					filters : filters

				test.deepEqual([equals], output)
				test.done()

		"Filters do not carry over" : (test) ->
				parser = new Parser("{{ foo|bar}}{{ baz }}", {})
				output = parser.parseTokens()
				filters = 
					name : "bar"
					args : []
				
				firstVar = 
					type 		: Parser.TOKEN_TYPES.VAR
					name 		: "foo"
					filters : [filters]

				secondVar = 
					type 		: Parser.TOKEN_TYPES.VAR
					name 		: "baz"
					filters : []

				test.deepEqual([firstVar, secondVar],output)
				test.done()
