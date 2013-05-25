# Controller

This is another `JSON` file where the key represents a **route** and the value is the view to render.

### Routes
A route is an entry point into your application, a URL. Using routes it is simple to make clean URLs for your application. You need to create a pattern and when a requested URL matches the pattern the view you specified will be rendered.

The requested URL `/items/342/` will match the route `/items/:id/`.

Using a placeholder in the route (`:id`) means anything between the slashes will match the route and the value will be stored in the `params` object with the key `id`.

An astericks `*` can be used as a wildcard to make a route match without using it's value in a parameter. This is mostly useful for namespacing parts of your application, for instance `/admin/*` matches absolutely every URL with `/admin/` at the start e.g. `/admin/users/`.

### View
When a requested URL matches a route, it will use the view specified to render the page. The page will have access to information about the request such as any query parameters (`/?queryParam=value`), or placeholders in a route.

### Example
Below is an example `controller.json` file for a simple blog.

~~~
{
	"/": "index", //landing page
	"/article/:id": "article", //single page for article
	"/write": "write" //page to write new articles
}
~~~