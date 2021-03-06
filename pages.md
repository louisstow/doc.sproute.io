# Pages

A page is an HTML file with template tags. The template language allows you to request data, include pages, evaluate expressions, set and render variables. To render a page you need a matching [route](#routes) to point to the page.

Template tags are wrapped with two curly braces starting with `{{` and ending with `}}`.

When you want to evaluate a variable inside a tag, use either a colon at the start `:myVariable`, or wrap the variable in a dollar sign and two parenthesis `$(myVariable)`. Some tags will automatically evaluate the variable like `if` and `set` or when documented as `<variable>`.

## Tags
### {{ get &lt;url&gt; [&lt;role&gt;] as &lt;variable&gt; }}
- `url`: URL to retrieve data from the database.
- `role`: Role of the user to make the GET request as (optional).
- `variable`: Save the data in the variable provided.

Retrieve data from the database through the [HTTP interface](#GET). The result is placed in the variable you provide after `as`.

You may optionally provide a [user type](#user-types) to make the request as a different role if the logged in user would otherwise not be able to complete.

*Note: This will not work for every URL, only paths to the [HTTP interface](#http-interface).*

~~~
{{ get /data/articles/ as articles }}
{{ each articles as article }}
	<h1>{{article.title}}</h1>
	{{article.body}}
{{ /each }}
~~~

### {{ post &lt;url&gt; &lt;data&gt; [&lt;role&gt;] as &lt;variable&gt;[,&lt;error&gt;] }}
- `url`: URL to store data in the database.
- `data`: Name of the object variable with the data to store.
- `role`: Role of the user to make the GET request as (optional).
- `variable`: Save the response in the variable provided.
- `error`: Save the error in the variable provided.

Store data in the database through the [HTTP interface](#POST). The result is placed in the variable you provide after `as`. Should an error occur, you can capture it by providing an error variable after the response variable.

With this tag you may modify data that the logged in user would otherwise not have permission to complete by manually entering a [user type](#user-types). This is useful for creating pages that require special logic or processing before storing the data.

*Note: This will not work for every URL, only paths to the [HTTP interface](#http-interface).*

~~~
{{ set data.title Hello }}
{{ set data.body Goodbye }}
{{ post /data/articles/ data admin as articles,err }}
~~~

### {{ delete &lt;url&gt; [&lt;role&gt;] as &lt;error&gt; }}
- `url`: URL to store data in the database.
- `data`: Name of the object variable with the data to store.
- `role`: Role of the user to make the GET request as (optional).
- `variable`: Save the response in the variable provided.

Delete data in the database through the [HTTP interface](#DELETE). Should an error occur it will be placed in the variable you provide after `as`.

With this tag you may modify data that the logged in user would otherwise not have permission to complete by manually entering a [user type](#user-types). This is useful for creating pages that require special logic or processing before storing the data.

*Note: This will not work for every URL, only paths to the [HTTP interface](#http-interface).*

~~~
{{ delete /data/articles/ admin as err }}
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

Set a variable to a value. If the variable contains a dot `.` the name before the dot will be turned into an object with whatever property comes after the dot. If the property name needs to contain a dot, you can wrap the name in double-quotes.

~~~
{{ set pageTitle This is the title of my website }}
<title>{{pageTitle}}</title>

{{ set obj.property 1 }}
{{ set obj.a.very.deep.property 2 }}
{{ set obj."property.with.dot" 3 }}
{{ debug obj }}
~~~

### {{ array &lt;variable&gt; }}
- `variable`: Variable to convert to an array.

Convert an object into an array. The object must contain numeric keys which will turn into the array indexes. If the object has no `length` property, one will be generated by the number of keys.

~~~
{{ set obj.0 First }}
{{ set obj.1 Second }}
{{ array obj }}
{{ debug obj }}
~~~

### {{ expr &lt;variable&gt; &lt;expr&gt; }}
- `variable`: Variable to store the result of the expression.
- `expr`: Mathematical expression.

This is a slightly advanced function to perform calculations. The result of the expression is stored in the variable provided.

See the [MathJS](http://mathjs.org) docs for more information about available operators and Math functions.

~~~
{{ expr score :article.thumbsUp - :article.thumbsDown }}
{{ score }}
~~~

### {{ date &lt;date&gt; &lt;format&gt; }}
- `date`: The date to format in UNIX timestamp form.
- `format`: A special string to format a date

Uses the [Moment](http://momentjs.com/docs/#/displaying/format/) library to take a UNIX timestamp and format it. Every row in a model has a `_created` field that can be formatted.

~~~
{{ each rows as row }}
	{{ date :row._created h:mma }}
{{ / }}
~~~

### {{ ago &lt;date&gt; }}
- `date`: The date as a UNIX timestamp.

Returns a text representation of the time elapsed from now. Read more in the [Moment docs](http://momentjs.com/docs/#/displaying/fromnow/).

~~~
{{ ago :row._created }}
~~~

### {{ word &lt;variable&gt; &lt;start&gt; &lt;offset&gt; }}
- `variable`: Variable containing text content to splice.

Will split the text variable by words and print based on the start index until the offset.

~~~
First 10 words from article:
{{ word :row.body 0 10 }}
~~~


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

Will replace the tag with the variable contents in the HTML rendered. By default the value will replace all HTML with HTML entities (`<` is replaced with `&amp;lt;`). This is for security reasons to prevent XSS where users can inject JavaScript into your webpage.

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

Print all the properties and values on a variable. Runs `JSON.stringify` on the provided variable and wraps it in `<pre>` tags.

~~~
{{ debug self }}
~~~

### {{ error &lt;message&gt; }}
- `message`: Error message to display.

Stop processing the page and respond to the user with a `500` code and a JSON string of the error. You can render a page instead of a JSON string by changing the Error View to an error page in Config. 

~~~
{{ error Page could not be displayed }}
~~~

### {{ json &lt;variable&gt; }}
- `variable`: Variable to respond as JSON.

Stop processing the page and respond to the user with a JSON string of the variable passed. Will serve with Content-Type `application/json`.

~~~
{{ set myobj.x 1 }}
{{ set myobj.y 2 }}
{{ set myobj.z 3 }}
{{ json myobj }}
~~~

### Escaping the tag
If you actually want two curly braces in your page without it being a tag, you can use an HTML entity (`&amp;#123;`) or put a forwardslash before the tag `\{{`.

## Global Variables
When rendering a page, you have access to a variety of variables.

### params
This object contains the placeholders specified from the [routes](#routes).

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

### headers
All the request headers sent to the page in lower-case.

~~~
{{ if headers.referer }}
	{{ redirect :headers.referer }}
{{ / }}
~~~

### session
The built-in user accounts are attached to the session object. You will mainly be using the user account at `session.user`. This contains the entire logged in user object. If the user is not logged-in this value will be empty.

### self
Assorted variables are contained in the `self` object.

* `url`: The requested URL being rendered.
* `dir`: Directory of the page being rendered.
* `name`: Name of the space.
* `method`: HTTP method making the request.
