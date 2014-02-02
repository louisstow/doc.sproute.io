# Build a Chat App for Firefox OS

In this tutorial we will build a chat app for Firefox OS from scratch!

A chat app needs persistent data to store all the messages and users. There are multiple free backend-as-a-service solutions we could use such as [Firebase](http://firebase.com) or [Hood.ie](http://hood.ie). In this tutorial we will be using my own solution: [Sproute](http://getsproute.com).

[Create an account](http://getsproute.com/signup) with a unique subdomain then access the Dashboard through http://yoursubdomain.sproute.io/admin.

In Sproute there is a concept called Models. A model defines the dynamic data in our app with properties for data integrity. We will need a model called `messages` with the following fields:

- `to`: Text, Required
- `content`: Text, Required, Min: 1, Max: 140

The `to` field will contain the username the message is addressed to. The `content` field will be the message being sent with some limits on the length. Every other bit of information will be created for us through the [built-in fields](http://getsproute.com/docs/rest#built-in-fields).

We need a way to render the messages, this is done through Pages. A page is basic HTML with embedded [template tags](http://getsproute.com/docs/pages) for retrieving and processing data.

Open the `index` page. This is the main page visible when people view your space. Here we need to retrieve all messages for the logged in user and display them grouped by the recipient. This is possible through the following template tag:

    {{ get /data/messages/to/:session.user.name?sort=_created,desc&limit=10 as messages }}

All data is retrieved through an [HTTP interface](http://getsproute.com/docs/rest) so the `get` tag must take a URL. The request above is retrieving all messages where the `to` field is equal to the logged in user name and stores the results in a variable called `messages`. 

A colon can be used in a template tag to evaluate a variable for processing the tag. We use a query parameter to sort the results by recently created first and limit the results to 10.

Let's display each message in an unordered list:

~~~
<ul>
    {{ each messages as message }}
    <li>
        <a href="/thread/{{message._creatorName}}">
            <strong>{{ message._creatorName }}</strong>
            {{ ago :message._created }}
        </a>
        <div>{{ message.content }}</div>
    </li>
    {{ / }}
</ul>
~~~

Loop over each message in the collection with the `each` tag. In the body of the tag we will print some variables for each message. We have a link to a not-yet-made thread page for each sender, the sender name (`_creatorName`), the message and how long ago it was sent.

We need a way for users to send a message. We can do this with a form:

~~~
<form action="/data/messages?goto=/" method="post">
<label>
    To: <input type="text" name="to" />
</label>
<div>
    <textarea name="content"></textarea>
</div>
<button type="submit">Send</button>
</form>
~~~

As mentioned above, all data is retrieved and modified through an HTTP interface. This means we can use a simple HTML form to create a new message.

User accounts are built into Sproute but we need to create some pages and forms to allow users to register and login. Create a new page called `login`:

~~~
{{ include header }}
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
{{ include footer }}
~~~

Nothing special there. Just a simple HTML form to post the user details to a [user end-point](https://getsproute.com/docs/users#post-apilogin) `/api/login`. The user will then be directed to the value of the `goto` query parameter.

Accessing pages through a request is done with Routes. A route is a pattern for a requested URL that will render a page if matched. There will already be a route for the index page. Create a new route with the pattern `/login` for the login page.

Users can now login but they first need to register. Follow the exact steps for login but replace `/api/login` with `/api/register`. Simple stuff.

One more feature to add is a conversation thread page. Create a new page called thread. This will largely be similar to the index page except we need to filter on the user of the thread.

~~~
{{ get /data/messages/_creatorName/:params.name?sort=created,desc&limit=20 as messages }}
~~~

Filter on the builtin field, `_creatorName` with the value of `params.name`. The params object is a collection of placeholder values created in the route.

One problem with the get request above is it will retrieve all messages even if it's not addressed to us. The solution to this is to filter further inside the `each` tag:

~~~
{{ each messages as message }}
	{{ if message.to eq :session.user.name }}
		... display message here ...
	{{ /if }}
{{ /each }}
~~~

We can also include a reply form using the same HTML form as before but with the `to` field hidden:

~~~
<form action="/data/messages?goto={{self.url}}" method="post">
<input type="hidden" name="to" value="{{params.name}}" />
<div>
	<textarea name="content"></textarea>
</div>
<button type="submit">Send</button>
</form>
~~~

But how do we access this page? We already created links to it in the index page with the pattern `/thread/<user.name>` so let's create a route that will match: `/thread/:name`. This is where `params.name` comes from.

This will be an app on the Firefox Marketplace as a hosted app, meaning the app will load our webpage. Every hosted app needs a manifest file. Create a page called `manifest` and include the necessary [JSON data](https://developer.mozilla.org/en-US/Apps/Developing/Manifest):

~~~
{
	"name": "{{name}}",
	"description": "A simple chat app",
	"launch_path": "/",
	"icons": {
		"128": "/path/to/icon"
	}
}
~~~

Create a Route with the pattern `/manifest.webapp` pointing to the manifest page.

We're done! Test this in the [app manager](https://developer.mozilla.org/en-US/Firefox_OS/Using_the_App_Manager) by using the link to the manifest (e.g. http://chatapp.sproute.io/manifest.webapp).