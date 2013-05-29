# Configuration

Sproute uses a `JSON` file to configure any settings or options you need to tweak. Out of the box, you will not need to configure many of these values,

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