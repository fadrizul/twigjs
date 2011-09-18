###
TwigJS
Copyright(c) 2011 Fadrizul Hasani <fadrizul@twigjs.org>
MIT Licensed
###

# Load dependencies
Compiler = require "./compiler"
helpers  = require "./helpers"

# Declare helpers
check   = helpers.check
escape  = helpers.escape

# Expose
exports.extends = {}
exports.block   = ends: true

# Slots
exports.slot = (twig) ->
  slot = @args[0]
  twig = twig or ""

  ret =
    "(function () {
      if (" + check(slot, "__context.slots") + ") {
      var __widget, __slot = " + escape(slot, "__context.slots") + ".content || [];
      for (var __i=0, __j = (+__slot.length) || 0; __i < __j; ++__i) {
          __widget = __slot[__i];
        if (__widget === undefined || __widget === null || __widget === false)
          continue;
        if (typeof __widget === \"string\")
          __output.push(__widget)
        else if (__widget.tagname && __widgets && typeof __widgets[__widget.tagname] === \"function\")
          __output.push(__widgets[__widget.tagname].call(__widget, __context,  __parents));
       }
     }
    " + twig
  ret

# Include
exports.include = (twig) ->
  template = @args[0]
  twig     = twig or ""

  throw new Error "Invalid arguments passed to 'include' tag." if not helpers.isLiteral(template) and not helpers.isValidName(template)

  [ "(function () {"
  , " if (" + check(template) + ") {"
  , "   var __template = " + escape(template) + ";"
  , " }"
  , " else if (" + check(template, "__context") + ") {"
  , "   var __template = " + escape(template, "__context"
  ) + ";"
  , " }"
  , " if (typeof __template === \"string\") {"
  , "   __output.push(__this.fromFile(__template).render(__context, __parents));"
  , " }"
  , " else if (typeof __template === \"object\" && __template.render) {"
  , "   __output.push(__template.render(__context, __parents));"
  , " }"
  , "})();" ].join "\n" + twig

# IF statement
exports["if"] = (indent) ->
  compile  = new Compiler(indent)

  operand1 = @args[0]
  operator = @args[1]
  operand2 = @args[2]

  negation = false
  indent   = indent or ""

  if operand1[0] == "!"
    negation = true
    operand1 = operand1.substr(1)

  throw new Error("Invalid syntax for 'if' tag")  if negation and operator
  throw new Error("Invalid arguments (" + operand1 + ") passed to 'if' tag")  if not helpers.isLiteral(operand1) and not helpers.isValidName(operand1)
  throw new Error("Invalid operator (" + operator + ") passed to 'if' tag")  if operator and [ "==", "<", ">", "!=", "<=", ">=", "===", "!==", "in" ].indexOf(operator) == -1
  throw new Error("Missing argument in 'if' tag")  if operator and typeof operand2 == "undefined"
  throw new Error("Invalid arguments (" + operand2 + ") passed to 'if' tag")  if operator and not helpers.isLiteral(operand2) and not helpers.isValidName(operand2)

  out = [ "(function () {" ]

  out.push " var __op1;"
  out.push " if (" + check(operand1) + ") {"
  out.push "   __op1 = " + escape(operand1) + ";"
  out.push " }"
  out.push " else if (" + check(operand1, "__context") + ") {"
  out.push "   __op1 = " + escape(operand1, "__context") + ";"
  out.push " }"

  if typeof operand2 == "undefined"

    out.push " if (" + (if negation then "!" else "!!") + "__op1) {"
    out.push commpiler.compile()
    out.push " }"

  else

    out.push " var __op2;"
    out.push " if (" + check(operand2) + ") {"
    out.push "   __op2 = " + escape(operand2) + ";"
    out.push " }"
    out.push " else if (" + check(operand2, "__context") + ") {"
    out.push "   __op2 = " + escape(operand2, "__context") + ";"
    out.push " }"

    if operator == "in"

      out.push " if ((Array.isArray(__op2) && __op2.indexOf(__op1) > -1) ||"
      out.push "    (typeof __op2 === \"string\" && __op2.indexOf(__op1) > -1) ||"
      out.push "    (!Array.isArray(__op2) && typeof __op2 === \"object\" && __op1 in __op2)) {"

    else
      out.push " if (__op1 " + escape(operator) + " __op2) {"

    out.push compiler.compile(this, indent + "   ")
    out.push " }"

  out.push "})();"
  out.join "\n" + indent

exports["if"].ends  = true

# FOR loop
exports["for"] = (indent) ->
  operand1 = @args[0]
  operator = @args[1]
  operand2 = @args[2]

  indent = indent or ""

  throw new Error("Invalid syntax in 'for' tag")  if typeof operator != "undefined" and operator != "in"
  throw new Error("Invalid arguments (" + operand1 + ") passed to 'for' tag")  unless helpers.isValidShortName(operand1)
  throw new Error("Invalid arguments (" + operand2 + ") passed to 'for' tag")  unless helpers.isValidName(operand2)

  [ "(function () {"
  , " if (" + check(operand2) + ") {"
  , "   var __forloopIter = " + escape(operand2) + ";"
  , " }"
  , " else if (" + check(operand2, "__context") + ") {"
  , "   var __forloopIter = " + escape(operand2, "__context") + ";"
  , " } else {"
  , "   return;"
  , " }"
  , " var " + escape(operand1) + ";"
  , " var forloop = {};"
  , " if (Array.isArray(__forloopIter)) {"
  , "   var __forloopIndex, __forloopLength;"
  , "   for (var __forloopIndex=0, __forloopLength=__forloopIter.length; __forloopIndex<__forloopLength; ++__forloopIndex) {"
  , "     forloop.index = __forloopIndex;"
  , "     " + escape(operand1) + " = __forloopIter[__forloopIndex];"
  , compile.call(this, indent + "     ")
  , "   }"
  , " }"
  , " else if (typeof __forloopIter === \"object\") {"
  , "   var __forloopIndex;"
  , "   for (__forloopIndex in __forloopIter) {"
  , "     forloop.index = __forloopIndex;"
  , "     " + escape(operand1) + " = __forloopIter[__forloopIndex];"
  , compile.call(this, indent + "     ")
  , "   }"
  , " }"
  , "})();" ].join "\n" + indent

exports["for"].ends = true
