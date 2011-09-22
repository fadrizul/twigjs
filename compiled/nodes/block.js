/*
TwigJS
Copyright(c) 2011 Fadrizul Hasani <fadrizul@twigjs.org>
MIT Licensed
*/
var Block;
Block = (function() {
  function Block() {}
  Block.prototype.ends = function() {
    return true;
  };
  return Block;
})();
module.exports = Block;