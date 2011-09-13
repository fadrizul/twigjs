###
TwigJS
Author: Fadrizul H. <fadrizul[at]gmail.com>
###

# Load regexes
x  = require "./regexes"
pr = require "eyes" # Debugging purposes

class Parser
  constructor: (str, tags) ->
    @rawTokens = if str then str.trim().replace(x.Replace, "").split(x.Split) else {}
    @tags      = tags or {}

  parseTokens: ->
    stack = [[]]
    index = 0

    for token in @rawTokens
      continue if token.length is 0 or x.CmntDelimiter.test(token)

      if x.Spaces.test(token)
        token = token.replace(RegExp(" +"), " ").replace(/\n+/, "\n")

      else if x.twigVar.test(token)
        filters = []
        parts   = token.replace(x.VarDelimiter, "").split("|")
        varname = parts.shift()

        for part in parts
          if parts.hasOwnProperty(part)
            parts       = parts[part]
            filterName  = part.match(/^\w+/)

          if x.LBracket.test(part)
            filters.push
              name: filter_name[0]
              args: part.replace(x.Symbols, "").split(",")
          else
            filters.push
              name: filter_name[0]
              args: []

        token =
          type    : x.VAR_TOKEN
          name    : varname
          filters : filters

      else if x.twigLogic.test(token)
        parts   = token.replace(x.LogDelimiter, "").split(" ")
        tagname = parts.shift()

        if tagname is "endblock"
          index--
          stack.pop
          continue

        throw new Error("Unknown logic tag: #{tagname} ") unless (tagname of @tags)

        token =
          type    : x.LOGIC_TOKEN
          name    : tagname
          args    : if parts.length then parts else []
          compile : @tags[tagname]

        if @tags[tagname].ends
          stack[index].push token
          stack.push token.tokens = []
          index++
          continue
      stack[index].push token

    return stack[index]

# Expose
Parser = exports = module.exports = Parser
exports.TEMPLATE = x.TEMPLATE
exports.TOKEN_TYPES =
  TEMPLATE : x.TEMPLATE
  LOGIC    : x.LOGIC_TOKEN
  VAR      : x.VAR_TOKEN
