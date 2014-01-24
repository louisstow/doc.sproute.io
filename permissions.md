# Permissions

Sproute has user accounts built-in so security is simple. You must create a [route](/docs/routes) and specify which user type can access that route. Users that do not match this type will be given an error.

### User Types

The default user types are `admin` and `member`. You may extend this by updating the `users` [model](/docs/models) and creating a values array in order of superiority (see Heirarchy below).

There are other special built-in user types you may use when specifying permissions:

* `admin`: At least one admin account exists when Sproute is first installed. This account is defined in the [config](/docs/config).
* `owner`: Will ensure the [`_creator`](/docs/rest#built-in-fields) matches the logged in user.
* `member`: Any logged in user.
* `anyone`: No requirement.
* `stranger`: Must *not* be logged in.

### Heirarchy

All user types have a heirarchy of superiority. The default order is
`admin > owner > member > anyone`. This means any permission you give to a user type is also given to user types above it.
