# Permissions

Sproute has user accounts built-in so security is simple. The basic concept is to specify what type of user can access which data. This is defined in a JSON file called `permissions.json`.

### User types

The default user types are `admin` and `member`. You may extend this by creating a `users` [model](/docs/model) and creating a values array in order of superiority.

### Heirarchy

All user types have a heirarchy of superiority. The default order is
`admin > member`. This means any permission you give to a user type is also given to user types above it.

### permissions.json

The permissions file is a JSON object where the key is the HTTP method + URL and the value is a user type. The URL is actually a [route](/docs/controller#Routes) so you can include wildcards to apply the permission to many URLs.

~~~
{
	"POST /data/articles": "admin", //only admin can create an article
	"POST /data/articles/*": "admin", //only admin can update an article
	"GET /write": "admin" //only admin can view the write page
}
~~~