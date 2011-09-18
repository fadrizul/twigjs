/*
TwigJS
Copyright(c) 2011 Fadrizul Hasani <fadrizul@twigjs.org>
MIT Licensed
*/
var Compile, Compiler, exports, helpers, x;
x = require("./regexes");
helpers = require("./helpers");
Compiler = (function() {
  function Compiler(node) {
    this.node = node || {};
    this.html = [];
    this.type = node.type;
  }
  Compiler.prototype.compile = function() {
    var blockName, errMsg, i, merge, p, parent, parentBlock, path, token, tokens, _i, _len, _len2;
    tokens = this.node.tokens;
    parent = {};
    merge = [];
    if (this.type === x.TEMPLATE) {
      for (i = 0, _len = tokens.length; i < _len; i++) {
        token = tokens[i];
        if (typeof token !== "undefined") {
          if (token.name === "extends") {
            path = this.node.options.root.replace(/['"]/g, "") + "/" + token.args[0].replace(/['"]/g, "");
            errMsg = "Only one string literal accepted of Extends.";
            if (token.args.length > 1) {
              throw new Error(errMsg);
            }
            parent = this.node.fileRenderer(path, this.node.options);
          } else if (token.name === "block") {
            blockName = token.args;
            if (!helpers.isValidBlockName(blockName)) {
              throw new Error("Invalid syntax.");
            }
            if (this.type !== x.TEMPLATE) {
              throw new Error("Multiple block tag detected");
            }
            if (parent) {
              for (_i = 0, _len2 = parent.length; _i < _len2; _i++) {
                p = parent[_i];
                if (typeof p !== "string" && p.name === "block") {
                  parentBlock = p.args;
                  if (parentBlock.toString() === blockName.toString()) {
                    p[blockName] = token[parentBlock];
                    tokens.splice(i, 1);
                  }
                }
              }
            }
          }
        }
      }
      merge = merge.concat(tokens, parent);
    }
    return this.out(merge);
  };
  Compiler.prototype.out = function(merge) {
    var blockName, i, t, varOut, _len;
    for (i = 0, _len = merge.length; i < _len; i++) {
      t = merge[i];
      if (typeof t === "string" && t.name !== "block") {
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
      if (t.name === "block") {
        blockName = t.args;
        this.html.push(t[blockName.toString()]);
      }
    }
    return this.html.join("");
  };
  return Compiler;
})();
Compile = exports = module.exports = Compiler;