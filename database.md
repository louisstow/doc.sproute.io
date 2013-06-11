# Database

After defining your data in [models](/docs/model) you need to be able to interact and create the data. This is done through an HTTP interface.

All URLs to access and modify collections are under the URL `/data/<collection>/`.

## GET

### /data/&lt;collection&gt;

Retrieve all rows under the collection.

~~~
GET /data/articles
~~~

### /data/&lt;collection&gt;/&lt;field&gt;/&lt;value&gt;

Retrieve rows under a collection where the field matches the value.

~~~
GET /data/articles/_id/5196eecb08e4860000000001
~~~

### Query Options:

- `?limit=[skip,]offset`: Limit the amount of rows returned. Skip is the starting point (defaults to `0`). Offset is how many rows to return after the starting point.

- `?sort=field[,asc|desc]`: Sort the results based on a field in ascending or descending order (defaults to ascending).

- `?single=boolean`: If one result is returned, return the object instead of a single element array.

## POST

### /data/&lt;collection&gt;

Insert a new row into a collection. The body of the POST request can be formatted in JSON or standard form data.

~~~
POST /data/articles/
{title: "New post", category: "news", body: "This is the content"}
title=New%20post&category=news&body=This%20is%20the%20content
~~~

### /data/&lt;collection&gt;/&lt;field&gt;/&lt;value&gt;

Update existing data in a collection.

~~~
POST /data/articles/_id/5196eecb08e4860000000001
{category: "tech"}
~~~

### /data/&lt;collection&gt;/&lt;field&gt;/&lt;value&gt;/inc

Increment a numerical field. The body should have the field to increment as the key and the difference as the value. Can be a negative number to decrement.

~~~
POST /data/articles/_id/5196eecb08e4860000000001/inc
{thumbsUp: 1}
~~~

### Query Options:

- `?goto=url`: After the POST redirect the location to a page.

## DELETE

### /data/&lt;collection&gt;

Remove an entire collection. Be very careful with this!

~~~
DELETE /data/articles/
~~~

### /data/&lt;collection&gt;/&lt;field&gt;/&lt;value&gt;

Remove all rows where the field matches the value.

~~~
DELETE /data/articles/_id/5196eecb08e4860000000001
~~~

### Query Options:

- `?goto=url`: After the POST redirect the location to a page.

## In-built fields

Every row in a collection comes with useful fields.

- `_created`: UNIX timestamp of when the row was created.
- `_creator`: The ID of the user who created the row.
- `_creatorName`: The username of the creator.
- `_lastUpdated`: UNIX timestamp of when the row was last modified.
- `_lastUpdator`: The ID of the user who last updated the row.
- `_lastUpdatorName`: The username of the user who last updated the row.