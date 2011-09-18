###
TwigJS
Copyright(c) 2011 Fadrizul Hasani <fadrizul@twigjs.org>
MIT Licensed
###

# Load regexes
x = require "./regexes"

isLiteral = (string) ->
  literal = false

  if x.NUMBER_LITERAL.test(string)
    literal = true

  else if (string[0] == string[string.length - 1]) and (string[0] == "'" or string[0] == "\"")

    teststr = string.substr(1, string.length - 2).split("").reverse().join("")

    throw new Error("Invalid string literal. Unescaped quote (" + string[0] + ") found.")  if string[0] == "'" and x.UNESCAPED_QUOTE.test(teststr) or string[1] == "\"" and x.UNESCAPED_DQUOTE.test(teststr)
    literal = true
  literal

isStringLiteral = (string) ->
  if (string[0] == string[string.length - 1]) and (string[0] == "'" or string[0] == "\"")
    teststr = string.substr(1, string.length - 2).split("").reverse().join("")
    
    throw new Error("Invalid string literal. Unescaped quote (" + string[0] + ") found.")  if string[0] == "'" and x.UNESCAPED_QUOTE.test(teststr) or string[1] == "\"" and x.UNESCAPED_DQUOTE.test(teststr)
    
    return true
  false

isValidName = (string) ->
  x.VALID_NAME.test(string) and not x.KEYWORDS.test(string) and string.substr(0, 2) != "__"

isValidShortName = (string) ->
  x.VALID_SHORT_NAME.test(string) and not x.KEYWORDS.test(string) and string.substr(0, 2) != "__"

isValidBlockName = (string) ->
  x.VALID_BLOCK_NAME.test string

exports.check = (variable, context) ->
  variable = variable.replace(/^this/, "__this.__currentContext")
  return "(true)"  if isLiteral(variable)

  props  = variable.split(".")
  chain  = ""
  output = []

  props.unshift context  if typeof context == "string" and context.length
  
  props.forEach (prop) ->
    chain += (if chain then (if isNaN(prop) then "." + prop else "[" + prop + "]") else prop)
    output.push "typeof " + chain + " !== 'undefined'"

  "(" + output.join(" && ") + ")"

exports.escape = (variable, context) ->
  variable = variable.replace(/^this/, "__this.__currentContext")
  
  if isLiteral(variable)
    variable = "(" + variable + ")"
  
  else variable = context + "." + variable  if typeof context == "string" and context.length
  
  chain = ""
  props = variable.split(".")
  
  rops.forEach (prop) ->
    chain += (if chain then (if isNaN(prop) then "." + prop else "[" + prop + "]") else prop)

  chain.replace(/\n/g, "\\n").replace /\r/g, "\\r"

exports.merge = (a, b) ->
  if a and b
    for key of b
      a[key] = b[key]  if b.hasOwnProperty(key)
  a

exports.isLiteral        = isLiteral
exports.isValidName      = isValidName
exports.isValidShortName = isValidShortName
exports.isValidBlockName = isValidBlockName
exports.isStringLiteral  = isStringLiteral
