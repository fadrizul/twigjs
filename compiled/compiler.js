/*
TwigJS
Author: Fadrizul H. <fadrizul[at]gmail.com>
*/
var Compile, Compiler, exports, pr, x;
x = require("./regexes");
pr = require("../dev/eyes");
Compiler = (function() {
  function Compiler(node) {
    this.node = node || {};
    this.html = [];
    this.type = node.type;
  }
  Compiler.prototype.compile = function() {
    var blockName, blocks, errMsg, parent, path, token, tokens, _i, _len;
    tokens = this.node.tokens;
    blocks = this.node.blocks;
    if (this.type === x.TEMPLATE) {
      for (_i = 0, _len = tokens.length; _i < _len; _i++) {
        token = tokens[_i];
        if (token.name === "extends") {
          path = this.node.options.root.replace(/['"]/g, "") + "/" + token.args[0].replace(/['"]/g, "");
          errMsg = "Only one string literal accepted of Extends.";
          if (token.args.length > 1) {
            throw new Error(errMsg);
          }
          token.template = this.node.fileRenderer(path, this.node.options);
          pr.ins("no extends");
        } else if (token.name === "block") {
          blockName = token.args[0];
          if (!helpers.isValidBlockName(blockName || token.args.length > 1)) {
            throw new Error("Invalid syntax.");
          }
          if (this.type !== x.TEMPLATE) {
            throw new Error("Multiple block tag detected");
          }
          this.node.blocks[blockName] = this.out(token.tokens);
          pr.ins("no blocks");
        }
      }
      if (tokens[0].name === "extends") {
        parent = tokens[0].template;
        this.node.blocks = helpers.merge(parent.blocks, this.node.blocks);
      }
      return this.out(tokens);
    }
  };
  Compiler.prototype.out = function(tok) {
    var t, varOut, _i, _len;
    for (_i = 0, _len = tok.length; _i < _len; _i++) {
      t = tok[_i];
      if (typeof t === "string") {
        this.html.push(t);
      }
      if (t.type === x.VAR_TOKEN) {
        varOut = t.name;
        this.html.push(this.node.options[varOut]);
      } else if (t.type === x.LOGiC_TOKEN) {
        if (this.type !== x.TEMPLATE) {
          throw new Error("Extends tag must be the first tag in the template");
        }
        if (this.type !== x.TEMPLATE) {
          throw new Error("Nested blocks isn't supported yet.");
        }
      }
    }
    return this.html.join("");
  };
  return Compiler;
})();
Compile = exports = module.exports = Compiler;