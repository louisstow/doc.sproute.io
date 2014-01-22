# Firefox OS

A common requirement when building Firefox OS applications is the need for a `manifest.webapp` JSON file served with the correct `Content-Type`.

Routes that match `/manifest.webapp` will *always* return a `Content-Type` of `application/x-web-app-manifest+json`. You can create a Page with the require [JSON data](https://developer.mozilla.org/en-US/Apps/Developing/Manifest) and even include template tags.

CORS is also enabled on the [HTTP interface](/docs/rest) so you may use the data storage through XHR without requiring the `systemXHR` permission.