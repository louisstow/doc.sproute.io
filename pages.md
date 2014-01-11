# Pages

A page is an HTML file with template tags. The template language allows you to request data, include pages, evaluate expressions, set and render variables. To render a page you need a matching [route](/docs/routes) to point to the page.

Template tags are wrapped with two curly braces starting with `{{` and ending with `}}`.

When you want to evaluate a variable inside a tag, use either a colon at the start `:myVariable`, or wrap the variable in a dollar sign and two parenthesis `$(myVariable)`. Some tags will automatically evaluate the variable like `if` and `set`.

### {{ get &lt;url&gt; as &lt;variable&gt; }}
- `url`: URL to retrieve data from the database.
- `variable`: Save the data in the variable provided.

Retrieve data from the database through the [HTTP interface](/docs/rest#GET). The result is placed in the variable you provide after `as`.

~~~
{{ get /data/articles/ as articles }}
{{ each articles as article }}
	<h1>{{article.title}}</h1>
	{{article.body}}
{{ /each }}
~~~

### {{ post &lt;url&gt; &lt;data&gt; &lt;role&gt; as &lt;variable&gt; }}
- `url`: URL to store data in the database.
- `data`: Name of the object variable with the data to store.
- `role`: Role of the user making the POST request.
- `variable`: Save the response in the variable provided.

Store data in the database through the [HTTP interface](/docs/rest#POST). The result is placed in the variable you provide after `as`.

With this tag you may modify data that the logged in user would otherwise not have permission to complete. This is useful for creating pages that require special logic or processing before storing the data.

~~~
{{ set data.title Hello }}
{{ set data.body Goodbye }}
{{ post /data/articles/ data admin as articles }}
~~~

### {{ each &lt;collection&gt; as &lt;variable&gt; }}
- `collection`: List of data to iterate through.
- `variable`: Name of the variable containing each item.

Iterate over a list of data. Usually you will use this with the `get` tag which will retrieve the data as a list. Everything inside the `each` block will be repeated for each of the elements in the collection.

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

### {{ unless &lt;variable&gt; &lt;operator&gt; &lt;value&gt; }}

Same as `if` but negated.

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

Set a variable to a value. If the variable contains a dot `.` the name before the dot will be turned into an object with whatever property comes after the dot.

~~~
{{ set pageTitle This is the title of my website }}
<title>{{pageTitle}}</title>

{{ set obj.property value }}
{{ set obj.a.very.deep.property hi }}
{{ debug obj }}
~~~

### {{ expr &lt;expr&gt; }}
- `expr`: Mathematical expression.

This is a slightly advanced function to perform calculations. The output of the expression is included in the HTML so use this like you were displaying a variable.

See the [MathJS](http://mathjs.org) docs for more information about available operators and Math functions.

~~~
{{ expr :article.thumbsUp - :article.thumbsDown }}
~~~

### {{ date &lt;variable&gt; &lt;format&gt; }}
- `variable`: The date to format.
- `format`: A special string to format a date

Uses the [DateFormat](https://github.com/felixge/node-dateformat) library to take a UNIX timestamp and format it.

### {{ include &lt;file&gt; }}
- `file`: Include a text-file into the page.

Include and evaluate another page. Can also be plain HTML. Will only search in the current directory.

`{{ #include }}` will do the same but will not evaluate the template tags.

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

### {{ redirect &lt;url&gt; }}
- `url`: Path to redirect to.

Will stop all processing of the page and redirect the user to the path specified.

~~~
{{ unless session.user }}
	{{ redirect /login }}
{{ / }}
~~~

### {{ debug &lt;variable&gt; }}
- `variable`: Variable to print.

Print all the properties and value on a variable. Runs `JSON.stringify` on the provided variable.

~~~
{{ debug self }}
~~~

### {{ error &lt;message&gt; }}
- `message`: Error message to display.

Stop processing the page and respond to the user with a `500` code and a JSON string of the error. You can render a page instead of a JSON string by changing the Error View to an error page in Config. 

~~~
{{ error Page could not be displayed }}
~~~

### Escaping the tag
If you actually want two curly braces in your page without it being a tag, you can use an HTML entity (`&#123;`) or put a forwardslash before the tag `\{{`.

## Global Variables
When rendering a page, you have access to a variety of in-built variables.

### params
This object contains the placeholders specified from the [routes](/docs/routes).

### query
URLs can have query variables (e.g. `?queryOption=hi`). You can access this through the `query` object.

~~~
{{ query.name }}
~~~

*Alias: `$_GET`*

### form
Pages can have data posted to it. This post data is found under the `form` object.

~~~
{{ if form }}
	{{ debug form }}
{{ / }}
~~~

*Alias: `$_POST`*

### session
The in-built user accounts are attached to the session object. You will mainly be using the user account at `session.user`. This contains the entire logged in user object. If the user is not logged-in this value will be empty.

### self
Assorted variables are contained in the `self` object.

* `url`: The requested URL being rendered.
* `dir`: Directory of the page being rendered.
* `name`: Name of the space.
* `method`: HTTP method making the request.
