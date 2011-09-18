###
TwigJS
Author: Fadrizul H. <fadrizul[at]gmail.com>
###

# Module dependencies
x       = require "./regexes"
helpers = require "./helpers"
pr = require "../dev/eyes" # Debugging purposes

class Compiler
  constructor: (node) ->
    @node   = node or {}
    @html   = []
    @type   = node.type

  compile: ->
    tokens = @node.tokens
    blocks = @node.blocks
    parent = {}
    merge  = []

    if @type is x.TEMPLATE
      for token, i in tokens
        if typeof token isnt "undefined"
          if token.name is "extends"
            path = @node.options.root.replace(/['"]/g, "") + "/" + token.args[0].replace(/['"]/g, "")

            errMsg = "Only one string literal accepted of Extends."
            throw new Error errMsg if token.args.length > 1

            parent = @node.fileRenderer(path, @node.options)
          else if token.name is "block"
            blockName = token.args

            throw new Error "Invalid syntax." if not helpers.isValidBlockName blockName
            throw new Error "Multiple block tag detected" if @type isnt x.TEMPLATE

            if parent
              for p in parent
                if typeof p isnt "string" 
                  parentBlock = p.args
                  if parentBlock.toString() is blockName.toString()
                    p[blockName] = token[parentBlock]
                    tokens.splice(i, 1)

      merge = merge.concat(tokens, parent)
      
      @out merge

  out: (tok) ->
    for t, i in tok
      if typeof t is "string" and t.name isnt "block"
        @html.push t

      if t.type is x.VAR_TOKEN
        varOut = t.name
        @html.push @node.options[varOut]

      else if t.type is x.LOGiC_TOKEN

        throw new Error "Extends tag must be the first tag in the template" if @type isnt x.TEMPLATE
        throw new Error "Nested blocks isn't supported yet." if @type isnt x.TEMPLATE

      if t.name is "block"
        blockName = t.args
        @html.push t[blockName.toString()]

    @html.join ""

# Expose
Compile = exports = module.exports = Compiler
