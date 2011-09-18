###
TwigJS
Copyright(c) 2011 Fadrizul Hasani <fadrizul@twigjs.org>
MIT Licensed
###

# Constants
exports.TEMPLATE    = 0
exports.LOGIC_TOKEN = 1
exports.VAR_TOKEN   = 2

# Delimiters
exports.twigVar     = /^\{\{.*?\}\}$/
exports.twigLogic   = /^\{%.*?%\}$/
exports.twigComment = /^\{#.*?#\}$/

# Opening & closing delimiters
exports.VarDelimiter  = /^\{\{ *| *\}\}$/g
exports.LogDelimiter  = /^\{% *| *%\}$/g
exports.CmntDelimiter = /^\{#.*?#\}$/g

# Regexp
exports.Replace = ///
		(^\n+) # Get \n from the start
	| (\n+$) # And to the end
///

exports.Split = ///	(
		\{%.*?%\}		# Logic delimiters
	|	\{\{.*?\}\} # Variable delimiters
	|	\{#.*?#\} 	# Comment delimiters
) ///

exports.Spaces = /// ^(
		\s # Whitespaces
	|	\n # Line break
)+$ ///
exports.LBracket = /\(/ # Left bracket
exports.Symbols  = /^\w+\(|\'|\"|\)$/g # Words that have single quote, double quote, left & right brackets

exports.NUMBER_LITERAL   = /^\d+([.]\d+)?$/ # Get number literals
exports.UNESCAPED_QUOTE  = /'(?!\\)/ # Get unescaped single quotes
exports.UNESCAPED_DQUOTE = /"(?!\\)/ # Get unescaped double quotes
exports.VALID_NAME       = /// ^(
	[$A-Za-z_]+
	[$A-Za-z_0-9] *)(\.?(
	[$A-Za-z_]+
	[$A-Za-z_0-9] *)
)*$ /// # Valid name for logics & variables
exports.VALID_SHORT_NAME = /// ^
	[$A-Za-z_]+
	[$A-Za-z_0-9]
*$ /// # Valid name for logics & variables
exports.KEYWORDS         = /// ^(
		Array
	|RegExpt
	|Object
	|String
	|Number
	|Math
	|Error
	|break
	|continue
	|do
	|for
	|new
	|case
	|default
	|else
	|function
	|in
	|return
	|typeof
	|while
	|delete
	|if
	|switch
	|var
	|with
	)(?=(\.|$))
///
exports.VALID_BLOCK_NAME = /// ^
	[A-Za-z]+
	[A-Za-z_0-9]*$
///
