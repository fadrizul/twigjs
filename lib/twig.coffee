###
TwigJS
Author: Fadrizul H. <fadrizul[at]gmail.com>
###

# Module dependencies
fs = require "fs"
pr = require "../dev/eyes" # Debugging purpose

# Load local lib
Parser   = require "./parser"
Compiler = require "./compiler"
tags     = require "./tags"
widgets  = require "./widgets"

# Expose
exports.version  = "v0.0.1"
exports.Parser   = Parser
exports.Compiler = Compiler

# Reads specified file
fileRenderer = (path, options, fn) ->
  if typeof options is "function"
    fn      = options
    options = {}

  options.filename = path
  str              = fs.readFileSync(path, "utf8")

  if str
    compile(str, options)

# Integrates into http.ServerResponse via express
exports.compile = compile = (str, options) ->
  # Collection of named properties for rendering
  twigTemplate  =
    fileRenderer : fileRenderer
    blocks       : {}
    type         : Parser.TEMPLATE
    options      : options

  # Declare new instance for Parser and returns twigtokens
  parser              = new Parser str, tags
  twigTemplate.tokens = parser.parseTokens()

  # Compiles twigTokens obj into javascript
  compiler = new Compiler(twigTemplate)
  compiled = compiler.compile()

  filename = if options.filename then JSON.stringify(options.filename) else "undefined"
  input    = JSON.stringify(compiled)

  # Rearrange the compiled input
  js  = "buf.push(#{input})"
  fn  = "var __ = {
        filename: #{filename}};
        var buf = []; with (locals || {}) {#{js}}
        return buf.join('');"

  # Sends to http.ServerResponse for rendering
  return new Function("locals", fn)
