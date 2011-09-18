/*
TwigJS
Copyright(c) 2011 Fadrizul Hasani <fadrizul@twigjs.org>
MIT Licensed
*/
var isLiteral, isStringLiteral, isValidBlockName, isValidName, isValidShortName, x;
x = require("./regexes");
isLiteral = function(string) {
  var literal, teststr;
  literal = false;
  if (x.NUMBER_LITERAL.test(string)) {
    literal = true;
  } else if ((string[0] === string[string.length - 1]) && (string[0] === "'" || string[0] === "\"")) {
    teststr = string.substr(1, string.length - 2).split("").reverse().join("");
    if (string[0] === "'" && x.UNESCAPED_QUOTE.test(teststr) || string[1] === "\"" && x.UNESCAPED_DQUOTE.test(teststr)) {
      throw new Error("Invalid string literal. Unescaped quote (" + string[0] + ") found.");
    }
    literal = true;
  }
  return literal;
};
isStringLiteral = function(string) {
  var teststr;
  if ((string[0] === string[string.length - 1]) && (string[0] === "'" || string[0] === "\"")) {
    teststr = string.substr(1, string.length - 2).split("").reverse().join("");
    if (string[0] === "'" && x.UNESCAPED_QUOTE.test(teststr) || string[1] === "\"" && x.UNESCAPED_DQUOTE.test(teststr)) {
      throw new Error("Invalid string literal. Unescaped quote (" + string[0] + ") found.");
    }
    return true;
  }
  return false;
};
isValidName = function(string) {
  return x.VALID_NAME.test(string) && !x.KEYWORDS.test(string) && string.substr(0, 2) !== "__";
};
isValidShortName = function(string) {
  return x.VALID_SHORT_NAME.test(string) && !x.KEYWORDS.test(string) && string.substr(0, 2) !== "__";
};
isValidBlockName = function(string) {
  return x.VALID_BLOCK_NAME.test(string);
};
exports.check = function(variable, context) {
  var chain, output, props;
  variable = variable.replace(/^this/, "__this.__currentContext");
  if (isLiteral(variable)) {
    return "(true)";
  }
  props = variable.split(".");
  chain = "";
  output = [];
  if (typeof context === "string" && context.length) {
    props.unshift(context);
  }
  props.forEach(function(prop) {
    chain += (chain ? (isNaN(prop) ? "." + prop : "[" + prop + "]") : prop);
    return output.push("typeof " + chain + " !== 'undefined'");
  });
  return "(" + output.join(" && ") + ")";
};
exports.escape = function(variable, context) {
  var chain, props;
  variable = variable.replace(/^this/, "__this.__currentContext");
  if (isLiteral(variable)) {
    variable = "(" + variable + ")";
  } else {
    if (typeof context === "string" && context.length) {
      variable = context + "." + variable;
    }
  }
  chain = "";
  props = variable.split(".");
  rops.forEach(function(prop) {
    return chain += (chain ? (isNaN(prop) ? "." + prop : "[" + prop + "]") : prop);
  });
  return chain.replace(/\n/g, "\\n").replace(/\r/g, "\\r");
};
exports.merge = function(a, b) {
  var key;
  if (a && b) {
    for (key in b) {
      if (b.hasOwnProperty(key)) {
        a[key] = b[key];
      }
    }
  }
  return a;
};
exports.isLiteral = isLiteral;
exports.isValidName = isValidName;
exports.isValidShortName = isValidShortName;
exports.isValidBlockName = isValidBlockName;
exports.isStringLiteral = isStringLiteral;