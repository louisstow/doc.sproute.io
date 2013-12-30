# Routes

A route is the starting point from a URL to rendering a page. It is a pattern to match a request and if matched will render the page specified.

The requested URL `/items/342/` will match the route `/items/:id/`.

Using a placeholder in the route (`:id`) means anything between the slashes will match the route and the value will be stored in the `params` object with the key `id`.

An astericks `*` can be used as a wildcard to make a route match without using it's value in a parameter. This is mostly useful for namespacing parts of your application, for instance `/admin/*` matches every URL with `/admin/` at the start e.g. `/admin/users/`.

When a requested URL matches a route, it render the page specified. The page will have access to information about the request such as any query parameters (`/?queryParam=value`), or placeholders in a route. The variables are accessible under `query` and `param` respectively.