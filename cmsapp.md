# Building a CMS in Sproute

*This tutorial requires a basic understanding of Sproute and its core concepts. If you're new to Sproute maybe check out the [Reddit](/docs/reddit) tutorial or the [Getting Started](/getting-started) video first.*

In this guide we will build a simple content management system. The dynamic data in a CMS is pages. We will need to list the pages in the navigation and render the page based on a slug (custom path).

Create a model called `pages` with the following fields:

- `slug`: Text, Required, Min: 1, Max: 50
- `title`: Text, Required
- `body`: Text, Required
- `order`: Number, Default Value: 1

Open the `index` view and include the following:

~~~
{{ unless params.slug }}
	{{ set params.slug home }}
{{ / }}

{{ get /data/pages/slug/:params.slug?single=true as page }}

{{ set title :page.title }}
{{ include header }}

{{ if page }}
	{{ if session.user }}
    	<div><a href="/edit/{{page._id}}">Edit</a></div>
    {{ / }}
    
	{{#page.body}}
{{ else }}
	<p>404. Page not found!</p>
{{ / }}

{{ include footer }}
~~~

The index page will receive all unmatched routes and check if the URL is in the model. If so it will render the body unescaped otherwise it will give a `404` message. When there was nothing passed into the route then it's the index page so retrieve the slug of `home`.

We also include an Edit link for those logged in (assuming a single user system).

The route to catch all unmatched requests will look like `/:slug`. But this has to come last in the list so other pages can be matched first.

Create a new page called `write`:

~~~
<form action="/data/pages?goto=/" method="post">
<label>
    <div>Title:</div>
    <input type="text" name="title" />
</label>
<label>
    <div>Slug:</div>
    <input type="text" name="slug" />
</label>
<label>
    <div>Order:</div>
    <input type="text" name="order" />
</label>
<div>
    <textarea name="body"></textarea>
</div>
<button type="submit">Create Page</button>
</form>
~~~

This is basic HTML form to create a row in the pages model. The edit page is very similar. Create a new page called `edit`:

~~~
{{ get /data/pages/_id/:params.id?single=true as page }}

<form action="/data/pages/_id/{{params.id}}?goto=/" method="post">
<label>
    <div>Title:</div>
    <input type="text" name="title" value="{{page.title}}" />
</label>
<label>
    <div>Slug:</div>
    <input type="text" name="slug" value="{{page.slug}}" />
</label>
<label>
    <div>Order:</div>
    <input type="text" name="order" value="{{page.order}}" />
</label>
<div>
    <textarea name="body">{{#page.body}}</textarea>
</div>
<button type="submit">Update Page</button>
</form>
~~~

We retrieve the article to edit and fill the details into the form values. The form action is also changed to modify all rows that match the `_id`.

The header page should list all the available pages and links to their slug. Open `header` and include the following:

~~~
<title>{{title}}</title>
<h1>{{self.name}}</h1>

{{ get /data/pages?sort=order as navpages }}
<nav>
{{ each navpages as p }}
    <a href="/{{p.slug}}">{{p.title}}</a>
{{ / }}
</nav>
~~~

Notice we render the `title` variable at the beginning. This is because we have set the value before including it in the index page. Included pages have access to the variables of the 'includer'. *Note this can cause problems when included pages leak variables such as `navpages` and `p` created above*.

We also sort the pages by the order field so the author can decide which page should be displayed first.

Now that all the pages are ready, let's create those routes!

- `/` => `index`
- `/write` => `write`
- `/edit/:id` => `edit`
- `/:slug` => `index`

The route for the catch-all route is created last. Seeing as this is a single-user CMS, we should restrict registration and model creation to `admin`. Change the following permissions to require admin user-type: `POST /api/register` and `POST /data/:table`.