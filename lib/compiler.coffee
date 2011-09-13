###
TwigJS
Author: Fadrizul H. <fadrizul[at]gmail.com>
###

# Module dependencies
x  = require "./regexes"
pr = require "../dev/eyes" # Debugging purposes

class Compiler
  constructor: (node) ->
    @node   = node or {}
    @html   = []
    @type   = node.type

  compile: ->
    tokens  = @node.tokens
    blocks  = @node.blocks

    if @type is x.TEMPLATE
      for token in tokens

        if token.name is "extends"
          path = @node.options.root.replace(/['"]/g, "") + "/" + token.args[0].replace(/['"]/g, "")

          errMsg = "Only one string literal accepted of Extends."
          throw new Error errMsg if token.args.length > 1

          token.template = @node.fileRenderer(path, @node.options)
          pr.ins "no extends"
        else if token.name is "block"
          blockName = token.args[0]

          throw new Error "Invalid syntax." if not helpers.isValidBlockName blockName or token.args.length > 1
          throw new Error "Multiple block tag detected" if @type isnt x.TEMPLATE

          @node.blocks[blockName] = @out(token.tokens)
          pr.ins "no blocks"


      if tokens[0].name is "extends"
        parent = tokens[0].template
        @node.blocks = helpers.merge(parent.blocks, @node.blocks)

      @out(tokens)

  out: (tok) ->
    for t in tok
      if typeof t is "string"
        @html.push t

      if t.type is x.VAR_TOKEN
        varOut = t.name
        @html.push @node.options[varOut]

      else if t.type is x.LOGiC_TOKEN

        throw new Error "Extends tag must be the first tag in the template" if @type isnt x.TEMPLATE
        throw new Error "Nested blocks isn't supported yet." if @type isnt x.TEMPLATE

    @html.join ""

# Expose
Compile = exports = module.exports = Compiler
