/*
TwigJS
Copyright(c) 2011 Fadrizul Hasani <fadrizul@twigjs.org>
MIT Licensed
*/exports.TEMPLATE = 0;
exports.LOGIC_TOKEN = 1;
exports.VAR_TOKEN = 2;
exports.twigVar = /^\{\{.*?\}\}$/;
exports.twigLogic = /^\{%.*?%\}$/;
exports.twigComment = /^\{#.*?#\}$/;
exports.VarDelimiter = /^\{\{ *| *\}\}$/g;
exports.LogDelimiter = /^\{% *| *%\}$/g;
exports.CmntDelimiter = /^\{#.*?#\}$/g;
exports.Replace = /(^\n+)|(\n+$)/;
exports.Split = /(\{%.*?%\}|\{\{.*?\}\}|\{#.*?#\})/;
exports.Spaces = /^(\s|\n)+$/;
exports.LBracket = /\(/;
exports.Symbols = /^\w+\(|\'|\"|\)$/g;
exports.NUMBER_LITERAL = /^\d+([.]\d+)?$/;
exports.UNESCAPED_QUOTE = /'(?!\\)/;
exports.UNESCAPED_DQUOTE = /"(?!\\)/;
exports.VALID_NAME = /^([$A-Za-z_]+[$A-Za-z_0-9]*)(\.?([$A-Za-z_]+[$A-Za-z_0-9]*))*$/;
exports.VALID_SHORT_NAME = /^[$A-Za-z_]+[$A-Za-z_0-9]*$/;
exports.KEYWORDS = /^(Array|RegExpt|Object|String|Number|Math|Error|break|continue|do|for|new|case|default|else|function|in|return|typeof|while|delete|if|switch|var|with)(?=(\.|$))/;
exports.VALID_BLOCK_NAME = /^[A-Za-z]+[A-Za-z_0-9]*$/;