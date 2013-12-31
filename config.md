# Configuration

Sproute uses a `JSON` file named `config.json` to configure any settings or options you need to tweak. Out of the box, you will not need to configure many of these values.

### Error View

When an error occurs render a custom page instead of the default JSON response. The page will have a list of error messages under `error`.

~~~
{{ each error as e }}
	<div>{{e.message}}</div>
{{ / }}
~~~

### Anti CSRF

To prevent an attack known as Cross-Site Request Forgery. A unique token will be generate for each user and stored in the session date under the key `_csrf`. Any non-GET request to the server will require the token in the request body.

~~~
<input type='hidden' name='_csrf' value='{{session._csrf}}' />
~~~

### reCAPTCHA

To implement a CAPTCHA you can use [reCAPTCHA](https://www.google.com/recaptcha/admin/create) by setting up a public and private key.

Put the private key in the config then to use a CAPTCHA in a form, use the template tag:

~~~
{{ captcha <public key> }}
~~~

### Rate Limit

To avoid spamming on your space, you can set a rate limit in seconds to prevent frequent POST requests.