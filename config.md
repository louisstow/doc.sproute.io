# Configuration

Sproute uses a `JSON` file named `config.json` to configure any settings or options you need to tweak. Out of the box, you will not need to configure many of these values.

### Error View

When an error occurs render a custom page instead of the default JSON response. The page will have a list of error messages under `error`.

To force an API to return JSON instead of the rendered error page, submit the request with an `Accept` header of `application/json` or `application/javascript`.

~~~
{{ each error as e }}
	<div>{{e.message}}</div>
{{ / }}
~~~

### reCAPTCHA

To implement a CAPTCHA you can use [reCAPTCHA](https://www.google.com/recaptcha/admin/create) by setting up a public and private key.

Put the private key in the config then to use a CAPTCHA in a form, use the template tag:

~~~
{{ captcha <public key> }}
~~~

### Rate Limit

To avoid spamming on your space, you can set a rate limit in seconds to prevent frequent POST requests.

### URL

When using a custom domain, put the full URL here for any links that need to point to the space such as password recovery emails. Make sure to leave off a trailing backslash `/`.

You must change your DNS settings on the domain so that the A record points to `115.146.76.79`.