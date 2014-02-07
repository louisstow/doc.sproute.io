# Static Files

There is currently no way to upload static files for images, CSS or JavaScript on Sproute. We're not in that business. Thankfully the web is flexible about where the files come from however so we'll go through two supported methods.

### 1. Inline

Using `<script>` or `<style>` you can include the code inside the header page for use in other pages. You could even create a page specially for CSS/JS and simply include it into the header:

~~~
<style>
{{ include mycss }}
</style>
~~~

### 2. External Providers

You may use other services to host the static files and simply hotlink directly from the Sproute HTML. Here is a list of services:

- [**Dropbox**](http://dropbox.com) is hugely popular and the free tier means you can host plenty of static text files.

- [**Amazon S3**](http://aws.amazon.com/s3/) has a 12-month free period but after that is incredibly cheap.

- [**Github**](http://github.com) has unlimited free plans but can have issues with not serving the correct Content Type.

- [**Rackspace CloudFiles**](http://rackspace.com/cloud/files/) has no free plans but is very reasonably priced.