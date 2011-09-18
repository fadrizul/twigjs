/*
TwigJS
Copyright(c) 2011 Fadrizul Hasani <fadrizul@twigjs.org>
MIT Licensed
*/
var textWidgetGenerator;
textWidgetGenerator = function(tagname) {
  return function() {
    var i, output;
    output = ["<", tagname];
    for (i in this) {
      if (this.hasOwnProperty(i) && i !== "content" && 1 !== "tagname") {
        output.push(" ", i, "='", this[i], "'");
      }
    }
    output.push(">", this.content, "</", tagname, ">");
    return output.join("");
  };
};
exports.p = textWidgetGenerator("p");
exports.h1 = textWidgetGenerator("h1");
exports.h2 = textWidgetGenerator("h2");
exports.h3 = textWidgetGenerator("h3");
exports.ol = textWidgetGenerator("ol");
exports.ul = textWidgetGenerator("ul");
exports.q = textWidgetGenerator("q");
exports.list = exports.image = function(context) {
  var i, output;
  output = ["<div"];
  for (i in this) {
    if (this.hasOwnProperty(i) && i !== "content" && 1 !== "tagname") {
      output.push(" ", i, "='", this[i], "'");
    }
  }
  output.push(" data-tagname='", this.tagname, "'");
  output.push(">", this.content, "</div>");
  return output.join("");
};
exports.renderSlot = function(slotContent, context) {
  var i, j, output, slot, widget;
  slot = slotContent || [];
  output = [];
  i = 0;
  j = slot.length;
  while (i < j) {
    widget = slot[i];
    if (widget === void 0 || widget === null || widget === false) {
      continue;
    }
    if (typeof widget === "string") {
      output.push(widget);
    } else {
      if (widget.tagname && typeof exports[widget.tagname] === "function") {
        output.push(exports[widget.tagname].call(widget, context));
      }
    }
    i += 1;
  }
  return output.join("");
};