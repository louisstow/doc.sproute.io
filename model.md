# Model

Most web applications need persistant data to store things like users, status updates or messages. Sproute makes that incredibly simple. All data is created and retrieved through an [HTTP interface](/docs/database).

The way data is stored in Sproute applications is similar to a relational database. You have a **collection** which is similar to a table. Inside a collection there are **fields**. You never *have* to define the fields, but it is recommended you do for security reasons.

To define a collection, simply create a JSON file where the filename is the name of the collection. For example `articles.json` will create a collection called `articles`.

If security is not a concern, you can leave the file with an empty object `{}` however it is highly recommended you define the data.

Data is defined in JSON in an object where the key is the field name and the value is an object of properties of the field.

~~~
{
	"title": {"type": "String"},
	"category": {"values": ["tech", "news", "thoughts"]},
	"body": {"type": "String"},
	"thumbsUp": {"type": "Number", "default": 0, "access": "anyone"},
	"thumbsDown": {"type": "Number", "default": 0, "access": "anyone"}
}
~~~

### type

Use this to ensure the type of the data in the field. Available values are `String` and `Number`.

~~~
"type": "String"
~~~

### values

If the field can only have very specific values, include them in this array. Whenever a field is updated or inserted it will ensure the value is one specified.

~~~
"values": ["admin", "moderator", "vip", "member"]
~~~

### required

Ensure the field has a value upon insertion.

~~~
"required": true
~~~

### default

If the field is not required and doesn't have a value, use this default value.

~~~
"default": 0
~~~

### access

This is a slightly more advanced restriction and allows you to specific which users can access the data in the field. Expects an object with a `w` (write) and `r` (read) property. If both are the same then set access to the string.

The value of the `w` and `r` property is a user type. This is explained in much more detail under [permissions](/docs/permissions).

~~~
"access": {"w": "admin", "r": "anyone"}
"access": "admin"
~~~

### maxlen

Maximum length of the value if it is a string.

### minlen

Minimum length of the value if it is a string.

### max

Maximum number value.

### min

Minimum number value.