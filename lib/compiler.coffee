###
TwigJS
Copyright(c) 2011 Fadrizul Hasani <fadrizul@twigjs.org>
MIT Licensed
###

# Module dependencies
x       = require "./regexes"
helpers = require "./helpers"

# Compiler class
class Compiler
  constructor: (node) ->
    @node   = node or {} # Instantiate as local object
    @html   = [] # Create empty array to be pushed into later 
    @type   = node.type # Get the token types

  compile: ->
    tokens = @node.tokens
    parent = {} 
    merge  = []

    # If token type is TEMPLATE start looping
    if @type is x.TEMPLATE

      for token, i in tokens

        # Make sure parser tree isn't passing undefined Tokens
        if typeof token isnt "undefined" 

          # Get extends tags
          if token.name is "extends"
            # Sets up the path for the parent template
            path = @node.options.root.replace(/['"]/g, "") + "/" + token.args[0].replace(/['"]/g, "")

            # Throw error is extends tag is invalid
            errMsg = "Only one string literal accepted of Extends."
            throw new Error errMsg if token.args.length > 1

            # Read parent files and return its content as token
            parent = @node.fileRenderer(path, @node.options)
          
          # Get block tags  
          else if token.name is "block"
            # Get the block name
            blockName = token.args

            # Throw errors if invalid block name 
            throw new Error "Invalid syntax." if not helpers.isValidBlockName blockName
            # Doesn't support nested blocks
            throw new Error "Multiple block tag detected" if @type isnt x.TEMPLATE

            # If parent isn't empty loop throught it,
            # and matches the array inside with the token
            if parent
              for p in parent
                # Get only blocks inside parent 
                if typeof p isnt "string" and p.name is "block"
                  # Get parent's block name
                  parentBlock = p.args

                  # Make sure the two block matches and sets it into 
                  # parent if it does
                  if parentBlock.toString() is blockName.toString()
                    p[blockName] = token[parentBlock]
                    # Remove the matched token
                    tokens.splice(i, 1)

      # Merge the arrays parent and tokens
      merge = merge.concat(tokens, parent)
    
    # Returns result of @out method 
    @out merge

  out: (merge) ->
    # Loop through the merged arrays and 
    # pushes the elements into a new stack 
    for t, i in merge
      # If elemenet is normal string pushes it
      if typeof t is "string" and t.name isnt "block"
        @html.push t
      
      # VARIABLE {{ }} type of the token
      if t.type is x.VAR_TOKEN
        # Get the value from "options" and pushes it
        varOut = t.name
        @html.push @node.options[varOut]

      # LOGIC {% %} type of the token
      else if t.type is x.LOGiC_TOKEN
        
        # If extends tags isn't the first one, throw errors
        throw new Error "Extends tag must be the first tag in the template" if @type isnt x.TEMPLATE
        throw new Error "Nested blocks isn't supported yet." if @type isnt x.TEMPLATE
      
      # Pushes the block into stack
      if t.name is "block"
        blockName = t.args
        @html.push t[blockName.toString()]

    # Join the elements and returns it
    @html.join ""

# Expose
Compile = exports = module.exports = Compiler
