# Building a Blog in Sproute

*This tutorial requires a basic understanding of Sproute and its core concepts. If you're new to Sproute maybe check out the [Reddit](/docs/reddit) tutorial or the [Getting Started](/getting-started) video first.*

A Blog is the Hello World of any web framework.

As always we should identify the dynamic data. In a blog it will be articles. Articles have a title, body content and maybe a category. Create a [model](/docs/models) named `articles` with the following fields:

- `title`: Text, Required
- `body`: Text, Required
- `category`: Text, Required

The index page should list all the blog posts available. We can do this with a [`get` tag](/docs/pages#get-url-role-as-variable):

~~~
{{ get /data/articles?limit=10&sort=_created,desc as articles }}

{{ if articles.length }}
	<div class="articles">
	{{ each articles as article }}
		<div class="article">
		<h2><a href="/article/{{article._id}}">{{article.title}}</a></h2>
		{{#article.body}}
		<div class="other">
		Posted {{ ago :article._created }} in <a href="/category/{{article.category}}">{{article.category}}</a>
		</div>
		</div>
	{{ / }}
	</div>
{{ else }}
	<p>No articles here</p>
{{ / }}
~~~

We have a title and link pointing to the single page article by it's [`_id`](/docs/rest#built-in-fields). The body is rendered with a hash `#` so any HTML will not be [escaped](/docs/pages#variable). This allows authors to enter their own HTML or use a WYSIWYG. Then underneath is some meta data like how long ago it was posted and a link to the category listing.

The previous code assumes two [routes](/docs/routes): `/article/<id>` and `/category/<name>`. Before we add the routes we must create the pages they will point to. First create a new page called `show`:

~~~
{{ get /data/articles/_id/:params.id?single=true as article }}

{{ if article }}
  <div class="article">
    <h2>{{article.title}}</h2>
    {{#article.body}}
    <div class="other">
      Posted {{ ago :article._created }} in <a href="/category/{{article.category}}">{{article.category}}</a>. 
      {{ if article._lastUpdated }}
          Last edited {{ ago :article._lastUpdated }}
      {{ / }}
      
      {{ if session.user }}
        - <a href="/edit/{{params.id}}">Edit</a>
      {{ / }}
    </div>
  </div>
{{ else }}
	<p>Article does not exist</p>
{{ / }}
~~~

I copied most of this code from the index page but changed the get request to only retrieve the one article we are viewing. Use the query parameter `?single=true` to return a single object rather than a collection of results.

We do a simple to check to see if the article exists. If so render the article just like the index page. One thing you will notice is a little check:

~~~
{{ if session.user }}
    - <a href="/edit/{{params.id}}">Edit</a>
{{ / }}
~~~

This will show an Edit link if the user is logged in. In this blog we assume one user account will be the sole author (the admin user). It also assumes a new route: `/edit/<id>`.

Before the content creation pages let's finish the last viewing pages. Create a new page called `category`:

~~~
{{ get /data/articles/category/:params.category?sort=_created,desc as articles }}

<h2>{{params.category}}</h2>

{{ if articles.length }}
	<div class="articles">
	{{ each articles as article }}
		<div class="article">
		<h2><a href="/article/{{article._id}}">{{article.title}}</a></h2>
		{{#article.body}}
		<div class="other">
		Posted {{ ago :article._created }}
		</div>
		</div>
	{{ / }}
</div>
{{ else }}
	<p>No articles here.</p>
{{ / }}
~~~

Again this is largely taken from the index page. The only difference is we filter the results based on the category field and the one passed into the URL parameter. We also include the category as a heading and remove it from the meta data section.

Right, onto the content creation pages. Create a new page called `write`:

~~~
<form action="/data/articles?goto=/" method="post">
<label>
	<div>Title:</div>
    <input type="text" name="title" />
</label>

<label>
	<div>Category:</div>
    <input type="text" name="category" />
</label>

<div>
	<textarea name="body"></textarea>
</div>
<button type="submit">Write Article</button>
</form>
~~~

This couldn't be simpler. A basic HTML form to create an article. The edit page is slightly more complex. Create a new page called `edit`:

~~~
{{ get /data/articles/_id/:params.id?single=true as article }}

<form action="/data/articles/_id/{{params.id}}?goto=/" method="post">
<label>
	<div>Title:</div>
    <input type="text" name="title" value="{{article.title}}" />
</label>

<label>
	<div>Category:</div>
    <input type="text" name="category" value="{{article.category}}" />
</label>

<div>
	<textarea name="body">{{article.body}}</textarea>
</div>
<button type="submit">Edit Article</button>
</form>
~~~

The code has been taken from the `write` page but now we retrieve the article information and fill it in the value of the form fields.

The other change is in the `action` property of the form element. Instead of posting to `/data/articles` we need to specify a filter to apply the modifications on. In this case the article with the `id` from the URL parameter.

Now let's create those routes!

- `/article/:id` => show
- `/category/:category` => category
- `/edit/:id` => edit
- `/write` => write

And finally, to secure everything, add some [permissions](/docs/permissions) so that `/write` and `/edit` requires admin user-type. You can also change `POST /api/register` and `POST /data/:table` to admin just in-case.
