/*
TwigJS
Copyright(c) 2011 Fadrizul Hasani <fadrizul@twigjs.org>
MIT Licensed
*/
var Compiler, Parser, compile, fileRenderer, fs, nodes, parse;
fs = require("fs");
Parser = require("./parser");
Compiler = require("./compiler");
nodes = require("./nodes");
exports.version = "v0.0.5";
exports.Parser = Parser;
exports.Compiler = Compiler;
fileRenderer = function(path, options, fn) {
  var parser, str, tokens;
  if (typeof options === "function") {
    fn = options;
    options = {};
  }
  options.filename = path;
  str = fs.readFileSync(path, "utf8");
  tokens = {};
  if (str) {
    parser = new Parser(str, nodes);
    tokens = parser.parseTokens();
  }
  return tokens;
};
parse = function(str, options) {
  var compiled, compiler, parser, twigTemplate;
  twigTemplate = {
    fileRenderer: fileRenderer,
    blocks: {},
    type: Parser.TEMPLATE,
    options: options
  };
  parser = new Parser(str, nodes);
  twigTemplate.tokens = parser.parseTokens();
  compiler = new Compiler(twigTemplate);
  compiled = compiler.compile();
  return compiled;
};
exports.compile = compile = function(str, options) {
  var compiled, filename, fn, input, js;
  compiled = parse(str, options);
  filename = options.filename ? JSON.stringify(options.filename) : "undefined";
  input = JSON.stringify(compiled);
  js = "buf.push(" + input + ")";
  fn = "var __ = {        filename : " + filename + "};        var buf = []; with (locals || {}) {" + js + "}        return buf.join('');";
  return new Function("locals", fn);
};