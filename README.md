# New docu

This is a small explanation about the project, how to use it and how to add new files.

## Docker Compose

We use docker-compose to make it easy to run this project.  
For the first time `docker-compose build` has to be runned. This can take a couple of minutes, but should only be done once in your lifetime, so don't worry.  
After that, you are good to go! Just type `docker-compose up` in the console -in the base directory- and it should work.  
The base URL is [`localhost:4000/apps`](http://localhost:4000/apps)
## How to add new documentation to the project

To add new docu for the project we need to fill a couple of steps.  
First, adding the raml files. This files should be modified later to include descriptions and so on. This process is exactly the same as in the old documentation.  
After that, the category page has to be created. With the description and images and so on.  
And finally, the category has to be included on the sidebar.
### The raml files

The raml files go in `_raml` directory. The suggested structure is:  
`/_raml/`  
&nbsp; &nbsp; `/category_name/`  
&nbsp; &nbsp; &nbsp; &nbsp; `category-expecific-method-request.json`  
&nbsp; &nbsp; &nbsp; &nbsp; `category-expecific-method-response.json`  
&nbsp; &nbsp; &nbsp; &nbsp; ...  
&nbsp; &nbsp; &nbsp; &nbsp; `category_name.raml`  
This is suggested, because `.json` files are not needed, but this way improves the readability of the `.raml` file and makes it easier to modify it to include descriptions and every other attributes.  
For the `.raml` file the following structure is not compatible with the project
```
/{category_id}:
  ...
/{category_id}/category_function:
```
It has to be changed to this style
```
/{category_id}:
  ...
  /category_function:
```
### The description of the category

For each new category a file on `apps/api-reference/` has to be created with the name being `resource-category_name.md`. This file is a little more complex, so let's check what needs to be included on it.

```
---
layout: page
key: api-resources-category_name
title: Category_name
---
This is a description text for the category

{% image the_image_of_the_category.png %}

{% assign global_key = page.key %}
<ul id="resource-list">
  {% for page in site.pages %}
    {% assign match = page.key | regex_match: '^apps-api-([a-z]+)-category_name(.*)-information$' %}
    {% assign visible = global_key | versioning_visible: page.url %}
    {% if match and visible %}
      <li class="resource-entry">
        <span class="http-method http-method-{{ page.raml_method.method | downcase }}">{{ page.raml_method.method }}</span>
        <a href="{{ page.url | prepend: site.baseurl }}#docs">{{ page.raml_resource.relative_uri }}</a>
      </li>
    {% endif %}
  {% endfor %}
</ul>
```
First, we need to include the category name on the `key` and on the `title`. E.g.
```
---
layout: page
key: api-resources-carts
title: Carts
---
```
After that, we can include any text we want to describe the category. We can also use images with this tag `{% image the_image_of_the_category.png %}`. The place to store this images is `/assets/images/`.  
Finally, we have to modify one line of the `html` part:  
```
{% assign match = page.key | regex_match: '^apps-api-([a-z]+)-category_name(.*)-information$' %}
``` 
To include there the `category_name` we choose in the previous part.
### The sidebar

To add a new category to the sidebar, the file to modify is `_data/sitemap-apps.yml`. Each new category it needs an entry which consists on two fields `title` and `link`. This two fields need to be added below the `API Reference` entry.  
The `title` is the visible name on the sidebar and the `link` needs to have the structure `page:api-resources-category_name#docs` where the category_name is the same that the one on `.raml`.
```
- key: api-rest
  title: API reference
  entries:
    - title: All resources
      link: page:api-resources-all#docs
    - title: Category_name
      link: page:api-resources-category_name#docs
```
