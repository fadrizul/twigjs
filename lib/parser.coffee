###
TwigJS
Copyright(c) 2011 Fadrizul Hasani <fadrizul@twigjs.org>
MIT Licensed
###

# Load regexes
x  = require "./regexes"

# This class create the Parser tree
class Parser
  constructor: (str, tags) ->
    @rawTokens = if str then str.trim().replace(x.Replace, "").split(x.Split) else {} # Rearranges str in to array
    @tags      = tags or {} # Sets valid tags

  parseTokens: ->
    stack = [ [] ] # Create empty array needed to be passed
    index = 0 # To differentiate between valid tags and string

    # Loop through @rawTokens
    for token, i in @rawTokens
      # If there are comment delimters {# #} ignore it
      continue if x.CmntDelimiter.test(token)

      # Relaces empty namespaces with \n
      if x.Spaces.test(token)
        token = token.replace(RegExp(" +"), " ").replace(/\n+/, "\n")

      # Get variable delimiters {{ }}
      else if x.twigVar.test(token)
        filters = []
        parts   = token.replace(x.VarDelimiter, "").split("|") # Check for var|var and split into parts
        varname = parts.shift() # Get the variable name

        # Loop through the parts
        for part in parts
          if parts.hasOwnProperty(part)
            parts       = parts[part]
            filterName  = part.match(/^\w+/)

          if x.LBracket.test(part)
            filters.push
              name: part.replace(/\(.+\)/, "")
              args: part.replace(x.Symbols, "").split(",")
          else
            filters.push
              name: part
              args: []
        
        # Create the parser tree
        token =
          type    : x.VAR_TOKEN
          name    : varname
          filters : filters
        
        # Pushes the new tree into stack
        stack[0].push token

      # Get Logic delimiters {% %}
      else if x.twigLogic.test(token)
        parts   = token.replace(x.LogDelimiter, "").split(" ") # Split the tags to get the tag name
        tagname = parts.shift()

        # Pop out if the tagname is "endblock"
        # and sets index to -1 
        if tagname is "endblock"
          index--
          stack.pop
          continue

        # Throw error on nonexistence tagname
        throw new Error("Unknown logic tag: #{tagname} ") unless (tagname of @tags)

        # Create the parser tree
        token =
          type    : x.LOGIC_TOKEN
          name    : tagname
          args    : if parts.length then parts else []
          compile : @tags[tagname]
        
        # Pushes extends tag into stack
        if tagname is "extends"
          stack[index].push(token)

        # If it's the end of the tag, pushes the string
        # in between the tags in to stack and reset index to 0
        if @tags[tagname].ends
          nextIndex = i + 1
          token[parts] = @rawTokens[nextIndex]
          @rawTokens.splice(nextIndex, 1)

          stack[index].push(token)
          index++
          continue
      # If it's only string, pushes it into stack for compiling
      else if token isnt ""
        if typeof token isnt "undefined" 
          stack[0].push(token)  

    # return the new Parser tree
    return stack[index]

# Expose Parser class, TEMPLATE const and token types
Parser = exports = module.exports = Parser
exports.TEMPLATE = x.TEMPLATE
exports.TOKEN_TYPES =
  TEMPLATE : x.TEMPLATE
  LOGIC    : x.LOGIC_TOKEN
  VAR      : x.VAR_TOKEN
