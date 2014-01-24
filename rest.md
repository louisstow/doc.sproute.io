# HTTP Interface

After defining your data in [models](/docs/models) you need to be able to interact and create the data. This is done through an HTTP interface.

All URLs to access and modify models are under the URL `/data/<model>/`.

## GET

### /data/&lt;model&gt;

Retrieve all rows under the model.

~~~
GET /data/articles
~~~

### /data/&lt;model&gt;/&lt;field&gt;/&lt;value&gt;

Retrieve rows under a model where the field matches the value.

~~~
GET /data/articles/_id/5196eecb08e4860000000001
~~~

### Query Options:

- `?limit=[skip,]offset`: Limit the amount of rows returned. Skip is the starting point (defaults to `0`). Offset is how many rows to return after the starting point.

- `?sort=field[,asc|desc]`: Sort the results based on a field in ascending or descending order (defaults to ascending).

- `?single=true`: If one result is returned, return the object instead of a single element array.

## POST

### /data/&lt;model&gt;

Insert a new row into a model. The body of the POST request can be formatted in JSON or standard form data.

~~~
POST /data/articles/
{title: "New post", category: "news", body: "This is the content"}
title=New%20post&category=news&body=This%20is%20the%20content
~~~

### /data/&lt;model&gt;/&lt;field&gt;/&lt;value&gt;

Update existing data in a model.

~~~
POST /data/articles/_id/5196eecb08e4860000000001
{category: "tech"}
~~~

### /data/&lt;model&gt;/&lt;field&gt;/&lt;value&gt;/inc

Increment a numerical field. The body should have the field to increment as the key and the difference as the value. Can be a negative number to decrement.

~~~
POST /data/articles/_id/5196eecb08e4860000000001/inc
{thumbsUp: 1}
~~~

### Query Options:

- `?goto=url`: After the POST redirect to a URL.

## DELETE

### /data/&lt;model&gt;

Remove an entire model. Be very careful with this!

~~~
DELETE /data/articles/
~~~

### /data/&lt;model&gt;/&lt;field&gt;/&lt;value&gt;

Remove all rows where the field matches the value.

~~~
DELETE /data/articles/_id/5196eecb08e4860000000001
~~~

### Query Options:

- `?goto=url`: After the DELETE redirect to a URL.

## Built-In fields

Every row in a model comes with useful fields.

- `_id`: A unique value to each row.
- `_created`: UNIX timestamp of when the row was created.
- `_creator`: The ID of the user who created the row.
- `_creatorName`: The username of the creator.
- `_lastUpdated`: UNIX timestamp of when the row was last modified.
- `_lastUpdator`: The ID of the user who last updated the row.
- `_lastUpdatorName`: The username of the user who last updated the row.