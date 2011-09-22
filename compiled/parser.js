/*
TwigJS
Copyright(c) 2011 Fadrizul Hasani <fadrizul@twigjs.org>
MIT Licensed
*/
var Parser, exports, x;
x = require("./regexes");
Parser = (function() {
  function Parser(str, nodes) {
    this.rawTokens = str ? str.trim().replace(x.Replace, "").split(x.Split) : {};
    this.tags = nodes || {};
  }
  Parser.prototype.token = function(type, name, args) {
    var token;
    if (type === x.VAR_TOKEN) {
      token = {
        type: type,
        name: name,
        filters: args
      };
    } else {
      token = {
        type: type,
        name: name,
        args: args
      };
    }
    return token;
  };
  Parser.prototype.parseTokens = function() {
    var args, i, index, nextIndex, parts, stack, tag, tagname, token, _len, _ref;
    stack = [[]];
    index = 0;
    _ref = this.rawTokens;
    for (i = 0, _len = _ref.length; i < _len; i++) {
      token = _ref[i];
      if (x.CmntDelimiter.test(token)) {
        continue;
      }
      if (x.Spaces.test(token)) {
        token = token.replace(RegExp(" +"), " ").replace(/\n+/, "\n");
      } else if (x.twigVar.test(token)) {
        stack[0].push(this.parseVar(token));
      } else if (x.twigLogic.test(token)) {
        parts = token.replace(x.LogDelimiter, "").split(" ");
        tagname = parts.shift();
        if (tagname === "endblock" || tagname === "endfor") {
          index--;
          stack.pop;
          continue;
        }
        if (!(tagname in this.tags)) {
          throw new Error("Unknown logic tag: " + tagname + " ");
        }
        args = parts.length ? parts : [];
        token = this.token(x.LOGIC_TOKEN, tagname, args);
        if (tagname === "extends") {
          stack[0].push(token);
        }
        tag = new this.tags[tagname];
        if (tag.ends() === true) {
          nextIndex = i + 1;
          token[parts] = this.rawTokens[nextIndex];
          this.rawTokens.splice(nextIndex, 1);
          stack[index].push(token);
          index++;
          continue;
        }
      } else if (token !== "") {
        if (typeof token !== "undefined") {
          stack[0].push(token);
        }
      }
    }
    return stack[index];
  };
  Parser.prototype.parseVar = function(token) {
    var filters, parts, varname;
    parts = token.replace(x.VarDelimiter, "").split("|");
    varname = parts.shift();
    filters = this.parseFilters(parts);
    return this.token(x.VAR_TOKEN, varname, filters);
  };
  Parser.prototype.parseFilters = function(parts) {
    var filterName, filters, part, _i, _len;
    filters = [];
    for (_i = 0, _len = parts.length; _i < _len; _i++) {
      part = parts[_i];
      if (parts.hasOwnProperty(part)) {
        parts = parts[part];
        filterName = part.match(/^\w+/);
      }
      if (x.LBracket.test(part)) {
        filters.push({
          name: part.replace(/\(.+\)/, ""),
          args: part.replace(x.Symbols, "").split(",")
        });
      } else {
        filters.push({
          name: part,
          args: []
        });
      }
    }
    return filters;
  };
  return Parser;
})();
Parser = exports = module.exports = Parser;
exports.TEMPLATE = x.TEMPLATE;
exports.TOKEN_TYPES = {
  TEMPLATE: x.TEMPLATE,
  LOGIC: x.LOGIC_TOKEN,
  VAR: x.VAR_TOKEN
};