/*
TwigJS
Author: Fadrizul H. <fadrizul[at]gmail.com>
*/
var Compiler, Parser, compile, fileRenderer, fs, pr, tags, widgets;
fs = require("fs");
pr = require("../dev/eyes");
Parser = require("./parser");
Compiler = require("./compiler");
tags = require("./tags");
widgets = require("./widgets");
exports.version = "v0.0.1";
exports.Parser = Parser;
exports.Compiler = Compiler;
fileRenderer = function(path, options, fn) {
  var str;
  if (typeof options === "function") {
    fn = options;
    options = {};
  }
  options.filename = path;
  str = fs.readFileSync(path, "utf8");
  if (str) {
    return compile(str, options);
  }
};
exports.compile = compile = function(str, options) {
  var compiled, compiler, filename, fn, input, js, parser, twigTemplate;
  twigTemplate = {
    fileRenderer: fileRenderer,
    blocks: {},
    type: Parser.TEMPLATE,
    options: options
  };
  parser = new Parser(str, tags);
  twigTemplate.tokens = parser.parseTokens();
  compiler = new Compiler(twigTemplate);
  compiled = compiler.compile();
  filename = options.filename ? JSON.stringify(options.filename) : "undefined";
  input = JSON.stringify(compiled);
  js = "buf.push(" + input + ")";
  fn = "var __ = {        filename: " + filename + "};        var buf = []; with (locals || {}) {" + js + "}        return buf.join('');";
  return new Function("locals", fn);
};