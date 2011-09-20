# TwigJS

A port of PHP template engine (www.twig-project.org) to Javascript

## Installation

Via NPM:
    
    npm install twigjs

## Usage example

###With ExpressJS
First we need to declare the extension of your view files. This can be anything you want; you just need to declare it in app.set('view engine'). What's important here is app.register(), you would need to require('twigjs') first, and then sets app.register as you see below.
	
	// Configuring your view files extension
	app.configure(function () {
		app.set('view engine', 'html');
	});

	// Include in TwigJS
	var twigjs = require('twigjs');
	app.register('html', twigjs);

	// Rendering "/index" view file 
	app.get('/index', function (req, res) {
		res.render('index', {
    		  // Declaring values for {{ }} tags
			  name   : "Fadrizul H." 
			, title  : "Fadrizul's Website"
		});
	});
To set values for variable tags, you need to include it as options in res.render() function. In this example we're setting values for {{ name }} and {{ title }}.

###Template inheritance
The most powerful part of TwigJS is template inheritance. Template inheritance allows you to build a base “skeleton” template that contains all the common elements of your site and defines blocks that child templates can override.

Sounds complicated but is very basic. It’s easiest to understand it by starting with an example.

####Base Template
This template, which we’ll call base.html, defines a simple HTML skeleton document that you might use for a simple two-column page. It’s the job of “child” templates to fill the empty blocks with content:

	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
	<html lang="en">
	<head>
	  {% block head %}
	    <link rel="stylesheet" href="style.css" />
	    <title>{{ title }} - My Webpage</title>
	  {% endblock %}
	</head>
	<body>
	  {% block title %}{% endblock %}

	  <div id="content">{% block content %}{% endblock %}</div>
	  <div id="footer">
	    {% block footer %}
	      &copy; Copyright 2011 by <a href="http://domain.invalid/">you</a>.
	    {% endblock %}
	  </div>
	</body>
	</html>
In this example, the {% block %} tags define four blocks that child templates can fill in. All the block tag does is to tell the template engine that a child template may override those portions of the template.

####Child Template
A child template might look like this:

	{% extends "base.html" %}
	{% block title %} This is the title {% endblock %}
	{% block head %}
	  <style type="text/css">
	    .important { color: #336699; }
	  </style>
	{% endblock %}
	{% block content %}
	  <h1>{{ name }}</h1>
	  <p class="important">
	    Welcome on my awesome homepage.
	  </p>
	{% endblock %}

The {% extends %} tag is the key here. It tells the template engine that this template “extends” another template. When the template system evaluates this template, first it locates the parent. The extends tag should be the first tag in the template.

## Running tests
To run test cases type the commands as you see below:
	
	$ cd node_modules/twigjs
	$ dev/bin/nodeunit tests/parser.test.coffee
If you have nodeunit installed then simply type:

	$ nodeunit test/parser.test.coffee

## To-do list
1. Documentation
2. Finish up twigjs.org

## License

(The MIT License)

Copyright (c) 2011 Fadrizul Hasani

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[1]: http://www.twig-project.org
[2]: http://twigjs.org