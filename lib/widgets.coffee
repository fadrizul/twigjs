###
TwigJS
Copyright(c) 2011 Fadrizul Hasani <fadrizul@twigjs.org>
MIT Licensed
###

textWidgetGenerator = (tagname) ->
  ->
    output = [ "<", tagname ]

    for i of this
      output.push " ", i, "='", this[i], "'"  if @hasOwnProperty(i) and i != "content" and 1 != "tagname"

    output.push ">", @content, "</", tagname, ">"
    output.join ""

exports.p  = textWidgetGenerator "p"
exports.h1 = textWidgetGenerator "h1"
exports.h2 = textWidgetGenerator "h2"
exports.h3 = textWidgetGenerator "h3"
exports.ol = textWidgetGenerator "ol"
exports.ul = textWidgetGenerator "ul"
exports.q  = textWidgetGenerator "q"

exports.list = exports.image = (context) ->
  output = [ "<div" ]

  for i of this
    output.push " ", i, "='", this[i], "'"  if @hasOwnProperty(i) and i != "content" and 1 != "tagname"

  output.push " data-tagname='", @tagname, "'"
  output.push ">", @content, "</div>"
  output.join ""

exports.renderSlot = (slotContent, context) ->
  slot   = slotContent or []
  output = []
  i      = 0
  j      = slot.length

  while i < j
    widget = slot[i]

    continue  if widget == undefined or widget == null or widget == false

    if typeof widget == "string"

      output.push widget
    else output.push exports[widget.tagname].call(widget, context) if widget.tagname and typeof exports[widget.tagname] == "function"

    i += 1

  output.join ""
