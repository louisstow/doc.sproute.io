# Views

A view is an HTML page with tags to the internal template language. The template language is very powerful and allows you to request data, include subviews, evaluate expressions, set and render variables.

Template tags are wrapped with two curly braces starting with `{{` and ending with `}}`.

When you want to use a variable inside a tag, use either a colon at the start `:myVariable`, or wrap the variable in a dollar sign and two parenthesis `$(myVariable)`. Some tags will automatically evaluate the variable like `if` and `set`.

### {{ get &lt;url&gt; as &lt;variable&gt; }}
- `url`: URL to retrieve data from the database.
- `variable`: Save the data in the variable provided.

Retrieve data from the database through the [HTTP interface](/docs/database#GET). The result is placed in the variable you provide after `as`.

~~~
{{ get /data/articles/ as articles}}
{{ each articles as article }}
	<h1>{{article.title}}</h1>
	{{article.body}}
{{ /each }}
~~~

### {{ each &lt;collection&gt; as &lt;variable&gt; }}
- `collection`: List of data to iterate through.
- `variable`: Name of the variable containing each item.

Iterate over a list of data. Usually you will use this with the `get` tag which will retrieve the data.

### {{ if &lt;variable&gt; &lt;operator&gt; &lt;value&gt; }}
- `variable`: Variable to test.
- `operator`: Operator for expression. See list below.
- `value`: Value to test.

Use this tag to only evaluate nested tags and HTML based on an expression.

Available operators:

- `eq`, `=`: Variable **equals** value.
- `gt`, `>`: Variable is **greater** than value.
- `lt`, `<`: Variable is **less** than value.
- `gte`, `>=`: Variable is **greater than or equal** to value. 
- `lte`, `<=`: Variable is **less than or equal** to value.
- `neq`, `!=`: Variable is **not equal** to value.

~~~
{{ if articles.length gt 0 }}
	<p>List of articles</p>
{{ /if }}
~~~

### {{ else }}
Use this tag in conjuction with `if`. If the expression is not true, tags nested in the else will be evaluated instead.

~~~
{{ if articles.length gt 0 }}
	<p>List of articles</p>
{{ else }}
	<p>No articles found!</p>
{{ /if }}
~~~

### {{ set &lt;variable&gt; &lt;value&gt; }}
- `variable`: Variable to set a value.
- `value`: Value to set the variable to.

Set a variable to a value.

~~~
{{ set pageTitle This is the title of my website }}
<title>{{pageTitle}}</title>
~~~

### {{ expr &lt;expr&gt; }}
- `expr`: Mathematical expression.

This is a slightly advanced function to perform calculations. The output of the expression is included in the HTML so use this like you were displaying a variable.

See the [MathJS](http://mathjs.org) docs for more information about available operators and Math functions.

~~~
{{ expr :article.thumbsUp - :article.thumbsDown }}
~~~

### {{ include &lt;file&gt; }}
- `file`: Include a text-file into the page.

Include and evaluate another Sproute file. Can also be plain HTML. Will only search in the current directory (the views directory).

`{{ #include }}` will do the same but will not evaluate the Sproute tags.

~~~
{{ include header.sprt }}
<p>Body content</p>
{{ include footer.sprt }}
~~~

### {{ &lt;variable&gt; }}

Will replace the tag with the variable contents in the HTML rendered. By default the value will replace all HTML with HTML entities (`<` is replaced with `&lt;`). This is for security reasons to prevent XSS where users can inject JavaScript into your webpage.

`{{ #<variable> }}` will do the same but will not escape the HTML. This should only be used if the data is trusted, such as if an administrator created it.

~~~
<p>{{myVar}}</p>
~~~

### {{ / }}
Required to close open tags such as `if` and `each`. You may put any text after the backslash to help remember which tag it's closing.

~~~
{{ if someExpression }}

{{ /I can be anything }}
~~~

### Escaping the tag
If you actually want two curly braces in your page without it being a tag, you can use an HTML entity (`&#103;`) or put a forwardslash before the tag `\{{`.

## Default Variables
When rendering a view, you have access to a variety of in-built variables.

### params
This object contains the placeholders specified from the [controller](/docs/controller).

### query
URLs can have query variables (e.g. `?queryOption=hi`). You can access this through the `query` object.

### session
The in-built user accounts are attached to the session object. You will mainly be using the user account at `session.user`. This contains the entire logged in user object. If the user is not logged-in this value will be empty.

### self
Assorted variables are contained in the `self` object.

* `url`: The requested URL being rendered.
* `dir`: Directory of the view being rendered.

