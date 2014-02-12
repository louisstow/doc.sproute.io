# How to create an Image Sharing app from scratch with Sproute

This tutorial will show you how to build your very own image sharing app like [dribbble](http://dribbble.com) using [Sproute](http://getsproute.com): a hosted environment for building dynamic web apps. The app will have lists of images with a caption, description, likes, and a list of comments.

## Overview of Sproute

Sproute is a hosted framework for rapid development of web applications. It allows you to easily define dynamic data and comes with lots of useful features out of the box such as user accounts and security.

## Core Concepts

There are 4 main concepts that you will need to understand for building a Sproute app:

### [Pages](http://getsproute.com/docs/pages)

Pages are just like HTML files with embedded template tags. This is a similar model to PHP where a request runs code in a page.

### [Models](http://getsproute.com/docs/models)

Models form the dynamic parts of the web app. Think of it like a database table. You define fields on a model and some integrity properties like maximum length, uniqueness, data type etc.

### [Routes](http://getsproute.com/docs/routes)

Routes are a neat way to make pretty SEO-friendly URLs. You create a pattern and if a request matches that pattern, it will render a page. 

We can include wildcards and placeholders in the route so when the page is rendered we have information about what was requested in the placeholder.

### [Permissions](http://getsproute.com/docs/permissions)

Permissions are defined at the very end and is a way to limit parts of your application to a certain user-type. For instance you would only want an Admin to be able to delete every row and not just anyone.

Permissions are implemented in the same way as routes with URL patterns but instead of pointing to a page, it points to a required user-type before the request can be full filed. Think of it as the gate keeper before letting the request go through.

## Create a new Project

If you haven't already, [signup for an account](http://getsproute.com/signup). You will need to give the project (or space) a unique name so it can be accessible at `<yourname>.sproute.io`.

Once the project has been created, visit the Control Panel at `http://<yourapp>.sproute.io/admin` and login with same credentials you signed up with.

## Create the Models

Our app will have some images and each image will have responses from the community. In the dashboard click on Model and create a new Model named `images`. Add the following fields and properties:

- `caption` - Text, Min: 1, Max: 50, Required
- `url` - Text, Required
- `description` - Text, Max: 200
- `likes` - Number, Default: 1, Write Access: Admin

Create another model called `responses` with the following fields and properties:

- `imageID` - Text, Required
- `content` - Text, Min: 5, Max: 200, Required

Let's quickly go over what we've created. The image model has a caption, url where the image will be hosted (this will be an external link from a image hosting service such as [imgur](http://imgur.com)) and description with some limits on character length. Write access on likes is set to admin so users can't increase their own likes.

![Model editor in the dashboard](http://i.imgur.com/uRJMx5U.png)

## Create the Index Page

We need a page to render the data from the models. Click Page and open the `index` page. On the index page we should list the most popular limited to about 50. This can be done with a template tag:

~~~
{{ get /data/images?sort=likes,desc&limit=50 as images }}
~~~

All data is retrieved, created and modified through an [HTTP interface](http://getsproute.com/docs/rest) (or REST API). Try the above in your browser and it will return the data as JSON.

Another template tag can loop over the collection in the variable called `images`:

~~~
{{ each images as image }}
	<a href="/image/{{image._id}}" class="image">
		<img src="{{image.url}}" />
		<div>{{image.caption}}</div>
		<div>
			{{image.likes}} likes. 
			Posted {{ ago :image._created }} by {{image._creatorName}}
		</div>
	</a>
{{ / }}
~~~

You'll notice some fields are being used that we didn't define! These are the built-in fields mentioned earlier. Every row will automatically store the date it was created and the username of the creator.

We also use a handy tag called ago which will return the date in an approximate time from now (e.g. 5 hours ago). Notice the little colon (`:`) before the variable. It's a special syntax to evaluate the variable before processing the tag. This is because some tags require a variable and some require a value. Another syntax for this is `$(<variable>)`.

![Index page of Image App](http://i.imgur.com/pxhsnQg.png)

## Create the View Page

Every image will need it's own page in the web app. Luckily we don't need to create a new page in Sproute for each entry, we can just have one. Let's call it `view`. Include a get request to get the data about the image:

~~~
{{ get /data/images/_id/:params.id?single=true as image }}
~~~

Using the HTTP interface we can filter results based on a field; in this case the `_id` field using the placeholder in the route (`params.id`). The `?single=true` parameter will return the object rather than a single element collection.

Let's render some of the data:

~~~
<h2>{{image.caption}}</h2>
<img src="{{image.url}}" />
<div>{{image.description}}</div>
<div>
	Posted by {{image._creatorName}}, 
	{{ date :image._created MMM D, YYYY }},
	{{image.likes}} Likes
</div>
~~~

We should also render the responses, sorted by most recent:

~~~
{{ get /data/responses/imageID/:params.id?sort=_created,desc as responses }}

{{ each responses as response }}
	<div class="response">
	<strong>{{response._creatorName}}</strong>
	{{response.content}}
	</div>
{{ / }}
~~~

Remember when I said every bit of data is created through an HTTP interface? This means we have a very simple way of inserting data:

~~~
<form action="/data/responses?goto={{self.url}}" method="post">
<input type="hidden" name="imageID" value="{{params.id}}" />
<textarea name="content"></textarea>
<button type="submit">Post Response</button>
</form>
~~~

We need to create a Route so that this page is accessible. Click Route and add the following:

- Route: `/image/:id`, Page: `view`

There's still a few things missing from this app. Users need a way to login and register and then submit their image. Thankfully this is a matter of 3 basic pages and 3 basic routes.

![Image View page](http://i.imgur.com/RuPo7SU.png)

# Create Login and Register

User accounts are built into Sproute. You simply need to create a form and point to the login and register end-points. Let's create the login page and you can create register on your own. Create a new page called `login`:

~~~
<form action="/api/login?goto=/" method="post">
<label>
	<div>Username:</div>
	<input type="text" name="name" />
</label>
<label>
	<div>Password:</div>
	<input type="password" name="pass" />
</label>
<button type="submit">Login</button>
</form>
~~~

Super simple stuff. The `?goto=` parameter tells the app where to redirect the user to after logging in. Now create a new route:

- Route: `/login`, Page: `login`

Have a go creating the register page yourself. Just change the action property to `/api/register`.

## Create the Submit Page

We need a way for users to submit their own images. This can be done with a simple HTML form. Create a new page called `submit`:

~~~
<form action="/data/images?goto=/" method="post">
<label>
	<div>Caption:</div>
	<input type="text" name="caption" />
</label>
<label>
	<div>URL:</div>
	<input type="text" name="url" />
</label>
<label>
	<div>Description:</div>
	<textarea name="description"></textarea>
</label>
<button type="submit">Submit Image</button>
</form>
~~~

Remember to create a route:

- Route: `/submit`, Page: `submit`

## 'Like' an Image

You may have noticed we haven't created any logic to let users 'like' an image. It requires some special work to only let users like an image once. To do this, we need to store who has liked a particular image. Create a new model called `likes` with the following:

- `likeID` - Text, Required, **Unique**

We also need a page that will do the liking logic. Create a new page called `like`:

~~~
{{ set key $(params.id)-$(session.user._id) }}

{{ get /data/likes/likeID/:key?single=true as resp }}

{{ if resp }}
	{{ error You liked this already }}
{{ else }}
	{{ set obj.likeID :key }}
	{{ set inc.likes 1 }}

	{{ post /data/likes/ obj admin }}
	{{ post /data/images/_id/:params.id/inc inc admin }}
{{ / }}
~~~

This page will create a unique key combining the users ID and the images ID. If it already exists in the model, it means they have already liked it. Otherwise increment the like counter and save the unique key in the new model. 

Notice `admin` in the `post` tag. This will run the request with the user-type of admin. We can create a permission that requires admins to be able to modify the like model. Remember we already set write access to admin for the like field.

Now create the following route:

- Route: `/like/:id`, Page: `like`

We can then add a like link in the `view` page:

~~~
<a href="/like/{{image._id}}">Like this Image</a>
~~~

## Lock it down!

The final thing we should do is add some permissions so naughty people can't tamper with the like data. Add the following permissions with the user type of admin:

- Method: `* ALL`, Route: `/data/likes`, User: `Admin`
- Method: `* ALL`, Route: `/data/likes/*`, User: `Admin`

## Summary

We're done! This tutorial has covered a lot but by now you should have a fully functional image sharing application. Have fun with it and see if you can extend it with more features. Be sure to read the [documentation](http://getsproute.com/docs) or [contact us](http://getsproute.com/contact) for any support questions.