# Configuration

Sproute uses a `JSON` file named `config.json` to configure any settings or options you need to tweak. Out of the box, you will not need to configure many of these values.

### name

This is the only required field in the config. It is used to create the database in Mongo. It should contain no spaces.

~~~
"name": "MyApp"
~~~

### admin
- default: `{ name: 'admin', pass: 'admin' }`

When first running your Sproute application you need to create an admin account. This is done by specifying the details under an admin key. Once the app is first started, you **should remove** this key as it poses a security risk.

~~~
"admin": {
	"name": "louis",
	"pass": "my strong password"
}
~~~

### strict
- default: `false`

When set to `true`, data will only be inserted if it has been defined in the model. In production it is recommended to turn this on and properly define your models.

~~~
"strict": true
~~~

### controller
- default: `controller.json`

Relative path to the controller file.

~~~
"controller": "controller.json"
~~~

### views
- default: `views/`

Relative path to the directory of view files.

~~~
"views": "viewsDir/"
~~~

### models
- default: `models/`

Relative path to the directory of view files.

~~~
"models": "modelsDir/"
~~~

### port
- default: `8000`

The port to server the website from.

~~~
"port": 8080
~~~

### extension
- default: `sprt`

File extension for view files. This can be any extensions.

~~~
"extension": "html"
~~~

### static
- default: `public`

Relative path to a directory containing all static asset such as images, JavaScrip source files, CSS stylesheet.

~~~
"static": "assets"
~~~

### cacheViews
- default: `false`

When requesting a view, reload the view each time. This is helpful for debugging so you don't need to restart the server whenever a view changes. Set to `true` in production for faster page serving.

### secret
- default: `<app name>`

A unique value for encrypting session cookies.