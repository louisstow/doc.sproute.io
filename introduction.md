## Introduction

Welcome to the Sproute documentation. Before diving into the docs, be sure to sit back and watch the many **[tutorial videos](/videos)**. After watching a few episodes you'll be able to write the docs yourself.

Sproute implements a tried and tested concept known as **MVC** or Model View Controller. It means a segregation of data (the model) and how it's displayed (the view), a controller decides how they interact.

At the very least, your app needs some views and a controller. Not all websites need dynamic data.

<p style="text-align: center; margin: 30px 0">
<a href="/docs/install" class="button">Getting started and installation</a>
</p>

### Core Concepts

1. [**Views**](/docs/views) are pages of HTML which may have template tags inside using the powerful template language.

2. [**Models**](/docs/model) are a definition of your data. You should define what type of data you expect for security reasons.

3. [**Controller**](/docs/controller) is the mapping from requested URLs to views that should be rendered in the browser.

### Data

- [**HTTP interface**](/docs/database) is how you interact with data.

- [**Users**](/docs/users) are built into Sproute applications.

### Tweaking

- <p>[**Config**](/docs/config) lets you tweak settings about your website.</p>

### Security

- [**Permissions**](/docs/permissions) let you decide what kind of users can access what parts of the website, be it pages, rows of data and even fields of data.

- [**Access property**](/docs/model#access) on models definitions.