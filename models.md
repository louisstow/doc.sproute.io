# Models

Most web applications need persistant data to store things like users, articles, status updates or messages. Sproute makes that incredibly simple. All data is created and retrieved through an [HTTP interface](#http-interface), better known as REST.

The way data is stored in Sproute applications is similar to a relational database. You have a **model** which is similar to a table. Inside a model there are **fields**. A field has some properties to ensure data integrity.

## Properties
### Type

Use this to ensure the type of the data in the field. Available values are `String`, `Boolean` and `Number`.

### Min

Minimum length of the value if it is a string. Minimum value if a Number.

### Max

Maximum length of the value if it is a string. Maximum value if a Number.

### Allowed Values

If the field can only have a specific set of values, include them in this list seperated by spaces. Whenever a field is updated or inserted it will ensure the value is one of those specified.

### Default Value

If the field is *not* required and *doesn't* have a value, use this default value.

### Required

Ensure the field has a value upon insertion or error.

### Unique

Ensure that no duplicate values of this field can exist in the model. This is useful for things like usernames where a user must have a unique name.

### Read/Write Access

Allows you to specific which type of users can read or write the data in the field.

User types are explained in more detail under [permissions](#permissions).

## Handling Errors

If the data provided causes an error on the above properties, the request will not go through and will instead return a JSON list of errors. You may also render a page with the error object by specifying an error page in the [Settings](#error-view).

The returned object will be an array of error objects for each error that occured containing a `message` field explaining the issue.

~~~
[
	{ "message": "Name: exceeded maximum length of 5 characters, got 9." },
	{ "message": "Role: value (cheese) did not exist in [admin, member]." }
]
~~~