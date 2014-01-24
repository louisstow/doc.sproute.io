# Building a Reddit-clone in Sproute

[Reddit](http://reddit.com) is a link-sharing website with users, categories and a voting system to decide which links should be displayed first.

The first thing we should do is identify the dynamic data then define the model that will store the links. The model will need to store the title, the destination link, the subreddit (or category) and how many votes the link has received. Every other field will be created for us through the [built-in fields](/docs/rest#built-in-fields).

## Models
Create a model called `links` and create the following fields and properties:

- `title`: Text, Required
- `link`: Text, Required
- `subreddit`: Text, Required
- `vote`: Number, Default Value: 0, Write Access: admin

You may add more restrictions if you like such as minimum and maximum lengths. The vote must not be writeable except for admins, the highest [user type](/docs/permissions#user-types), otherwise users could change the value of their vote.

## Pages
Now we need a Page to render this data. Pages are just HTML pages that can be extended with the [Sproute template language](/docs/pages). Click on *Pages* and you will see: header, footer and index. *index* is the home page. *header* and *footer* are pages that will keep a consistent theme by including them in every visible page.

Reddit has a list of the top links from every subreddit (or category) on the front page. We can request this data from the model using a template tag.

	{{ get /data/links as links }}

All data in a Sproute app is accessible through an [HTTP interface](/docs/rest), even in the template language. The previous tag will get **all** rows in the links model. Though there could be many links so we should limit the amount to 20. We should also sort the collection by how many votes it received (highest first). Replace the `get` tag with this:

	{{ get /data/links?limit=20&sort=vote,desc as links }}

This will give us the top 20 links by the vote field and store it in a collection called `links`.

Next we should loop over each item in the collection and render it through HTML.

	<ul>
	{{ each links as link }}
		<li>
			<strong>{{link.vote}}</strong>
			<a href="{{link.link}}">{{link.title}}</a>
		</li>
	{{ / }}
	</ul>

The `each` tag will iterate over a collection so everything inside the tag and it's closing tag ( `{{ / }}` ) will be repeated and rendered for each element.

Variables are displayed by surrounding the variable name with two curly braces `{{ <var> }}` (spaces are optional).

We should display some more information about the link because we can. Let's add another line containing some of the meta data.

	<ul>
	{{ each links as link }}
		<li>
			<strong>{{link.vote}}</strong>
			<a href="{{link.link}}">{{link.title}}</a>
			<div>
				<a href="/r/{{link.subreddit}}">{{link.subreddit}}</a>
				submitted by {{link._creatorName}},
				{{ ago :link._created }}
			</div>
		</li>
	{{ / }}
	</ul>

You'll notice some fields are being used that we didn't define! These are the built-in fields mentioned earlier. Every row will automatically store the date it was created and the username of the creator.

We also use a handy tag called `ago` which will return the date in an approximate time from now (e.g. 5 hours ago). Notice the little colon ( `:` ) before the variable. It's a special syntax to evaluate the variable before processing the tag. This is because some tags require a variable and some require a value. Another syntax for this is `$(<variable>)`.

Now we need a way for users to submit a link. To prevent spam, users should be made to register an account before submitting links. Fortunately, user accounts are built into Sproute so this is as easy as creating a Page and a Route (more on this soon).

Create a new Page called `login` and add the following HTML:

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

This is just a basic HTML form. The magic happens in `/api/login` which is an internal endpoint to create a session for a [user](/docs/users) and give them [access](/docs/permissions) to parts of your application. The query option `goto` will redirect the user to a URL, in this case index.

Do the same for register but change the action endpoint from `/api/login` to `/api/register`.

## Routes
One thing you might have noticed by now is that this page is not yet accessible from the browser. This is because we need to define a Route to match a URL to a Page.

Click on `Route` to see the current routes. There should be one where `/` will point to `index`. Create a route for login where the Route is `/login` and the page is `login` (listed in the select menu). Do the same for register.

The reason you must use Routes is because applications can have complex URLs that don't always match up exactly to a page. An example in this reddit clone is subreddits where the URL `/r/<subreddit>` will point to a special page. We will cover this later in the guide.

One more page we will need is a submit page where users can actually submit their links. Because all data is accessibly and modified over an HTTP interface, we just need a simple HTTP form here as well.

    <form action="/data/links?goto=/" method="post">
    <label>
        <div>Title:</div>
        <input type="text" name="title" />
    </label>
    <label>
        <div>URL:</div>
        <input type="text" name="link" />
	  </label>
    <label>
        <div>Subreddit:</div>
        <input type="text" name="subreddit" />
    </label>
    <button type="submit">Submit Link</button>
    </form>

This will send a POST request to the [HTTP interface](/docs/rest) and create a row in the model. After which it will send the user back to the index route. **Remember to create a Route to point to the submit page called `/submit`**.

You might have noticed this page can be accessible by users that aren't logged in. We have two options to solve this: add a check in the page with template tags or add a permission. We'll go over both starting with the template tag solution. Prepend the following in the submit page.

    {{ unless session.user }}
        {{ redirect /login }}
    {{ / }}

This will perform some logic so if the `session.user` variable is empty, redirect the user to the `/login` route. This is my preferred method as a redirect is more user-friendly than an error message.

## Permissions
The other option is through Permissions. Click `Permissions` to see a list of default permissions. You will see some [complex routes](/docs/routes) and a required [user type](/docs/permissions#user-types). This will perform a check at the very start of the request to see if the current user meets the minimum required user type.

We can add our own permission for the route `/submit` that requires the minimum user type to be `Member`. If the user does not meet this requirement they will be given an error message formatted in JSON. You should also use `* ALL` for the method as this corresponds to HTTP method and routes will respond to a GET *and* POST requests.

The other permissions provide some default security that prevents just anyone from deleting or modifying data unless they are the owner or an admin. However you may change these permissions to your discretion.

Now let's go back to the subreddit page we have not yet created. Create a new page called `subreddit` and copy all the code from `index` as the subreddit listing page will be largely similar.

The only modification we will need to make is to the `get` tag.

    {{ get /data/link/subreddit/:params.name?limit=20&sort=vote,desc as links }}

This will filter the results based on the `subreddit` field in the model where the value is equal to `:params.name`. Let's create the route before explaining the `params` object.

Create a route to point to the subreddit page with the following pattern: `/r/:name`. This will match all URLs beginning with `/r/` and store the value of `name` as a property on `params` in the page. This explains `:params.name`; whatever value is passed into the URL will be matched and stored in `params.name`.

The biggest feature we left out is voting! How does a user vote on a link? We added a restriction where only admins can write to the `vote` field. Therefore we need a special page that will allow us to run logic before modifying the data and do so with any role we choose (specifically admin).

## Complex Pages
Create a page called `vote` and the following route: `/vote/:id/:vote`. Then we are able to send the unique link identifier and the user vote, either `up` or `down` (e.g. `/vote/v0c670w79gxecdi/up`).

Before we start writing the template logic to increment the vote, we need a way to validate if the user has voted before so they cannot vote multiple times. This can be implemented with a model that will store the link identifier and user identifier along with their vote. That way we can detect if the user has already voted on a link.

Create a Model called `votes` with the following fields:

- `linkID`: Text, Required, Unique
- `vote`: Text, Required, Allowed Values: up, down

The `linkID` will be a text field with the combination of the link ID and the user ID.

Now back to the `vote` page. Add the following code:

    {{ set key $(params.id)-$(session.user._id) }}

    {{ get /data/votes/linkID/:key?single=true as resp }}

    {{ if params.vote eq up }}
        {{ set inc.vote 1 }}
    {{ else }}
        {{ set inc.vote -1 }}
    {{ / }}
    
    {{ if resp }}
        {{ error You voted already }}
    {{ else }}
        {{ set obj.linkID :key }}
        {{ set obj.vote :params.vote }}

        {{ post /data/votes/ obj admin as resp }}
        {{ post /data/links/_id/:params.id/inc inc admin }}
        ok
    {{ / }}

... Let me explain. 

We create a variable called `key` through the tag: `set`. It concatenates the `linkID` and logged in `user._id` and will generate something like: `1fkmauihynnmxnu3di-13hd7v64in4xtj4i`. We query the database to see if there are any rows with that unique key. If so then the user has already voted so throw an [error](/docs/pages#error-message). The `single=true` query option will return the first result in an object instead of array.

If the user has not voted, it will create an object called `obj` with the generated key and user's vote. Then it will create a new record in the `votes` model with the user type of `admin` using the `post` tag.

Another `post` tag will [increment](/docs/rest#datamodelfieldvalueinc) the vote field based on the users vote set above in the `inc` object. We also need to run this request as an `admin` as we previously set the Write Access to `admin`.

Now users can vote with the following links in `index` and `subreddit`:

    {{ each links as link }}
        ...
        <a href="/vote/{{link._id}}/up">Upvote</a>
        <a href="/vote/{{link._id}}/down">Downvote</a>
        ...
    {{ / }}

Ideally this would be done with an AJAX request as to not take the user to another page.

The last thing we will do is add some more permissions so that users can't modify any of the vote data. Add the following routes with the user type of `admin`: 

- `ALL /data/votes`
- `ALL /data/votes/*`

Obviously we can't cover absolutely every feature of reddit in this guide but it should introduce you to the core concepts and show you the power of Sproute. Sign up for a free account now at [http://getsproute.com](http://getsproute.com).