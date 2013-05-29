# Users

Sproute comes with User Accounts straight out of the box. To make use of them you should create some front-end HTML to send requests to the following end-points.

### POST /api/login
- `name`: Username of the account.
- `pass`: Password of the account.

Create a session on the server for a user. If they are already logged in, an error will be returned.

### POST /api/logout

Sending a POST request to this URL will logout the currently logged in user.

### POST /api/register
- `email`: Email address.
- `name`: Username.
- `pass`: Password.
- `role`: Role; defaults to `member`.

Use this end-point over `/data/users`. Will create a new user with the data provided. If you have extended the user model, include the data in the body.

When specifying a role, you will only be allowed to use the lowest role (`member`). If you are logged in when creating a user, you can set the role to your level or lower.

### GET /api/logged

Returns the object of the user logged or `false` if not logged in.