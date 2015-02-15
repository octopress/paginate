# Octopress Paginate

Simple and flexible pagination for Jekyll sites featuring:

- Simple configuration
- Paginate posts and collections
- Page limits (Because who's reading page 35?)
- Filter by categories or tags
- Multi-language support (with [octopress-multilingual](https://github.com/octopress/multilingual))

[![Build Status](http://img.shields.io/travis/octopress/paginate.svg)](https://travis-ci.org/octopress/paginate)
[![Gem Version](http://img.shields.io/gem/v/octopress-paginate.svg)](https://rubygems.org/gems/octopress-paginate)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://octopress.mit-license.org)

## Installation

If you're using bundler add this gem to your site's Gemfile in the `:jekyll_plugins` group:

    group :jekyll_plugins do
      gem 'octopress-paginate'
    end

Then install the gem with Bundler

    $ bundle

To install manually without bundler:

    $ gem install octopress-paginate

Then add the gem to your Jekyll configuration.

    gems:
      - octopress-paginate

## Usage

To paginate posts, create a page to be used as the pagination template.

```
---
title: Post Index
paginate: true
---

{% for post in paginator.posts %}
/ do stuff /
{% endfor %}
```

Paginating collection is almost the same as posts except you need to set the collection to paginate.

```
---
title: Penguin Index
paginate:
  collection: penguins
---

{% for penguin in paginator.penguins %}
/ do stuff /
{% endfor %}
```

### Multilingual pagination

If you are running a multilingual site with [octopress-multilingual](https://github.com/octopress/multilingual), simply set a language for your pagination template and posts will be filtered by that language. For example:

```
---
Title: "Deutsch Posts"
permalink: /de/posts/ # <- Or wherever makes sense on your site
paginate: true
lang: de  # <- Add a language
---

{% for posts in paginator.posts %}
/ do stuff /
{% endfor %}
```

That's all there is to it.

### Template variables

Just like Jekyll's paginator, your pagination pages will have access to the following liquid variables.


```yaml
paginator.total_pages          # Number of paginated pages
paginator.total_posts          # Total number of posts being paginated
paginator.per_page             # Posts per page
paginator.limit                # Maximum number of paginated pages
paginator.page                 # Current page number
paginator.previous_page        # Previous page number (nil if first page)
paginator.previous_page_path   # Url for previous page (nil if first page)
paginator.next_page            # Next page number (nil if last page)
paginator.next_page_path       # Next page URL (nil if last page)

# If you're pagination through a collection named `penguins`
pagination.total_penguins      # Total number of peguins being paginated
```

## Configuration

Pagination is configured on a per-page basis under the `paginate` key in a page's YAML front-matter. Setting `paginate: true` enables pagination with these defaults.

```yaml
paginate:
  collection:   posts
  per_page:     10             # maximum number of items per page 
  limit:        5              # Maximum number of pages to paginate (false for unlimited)
  permalink:    /page:num/     # pagination path (relative to template page)
  title_suffix: " - page :num" # Append to template's page title
  category:     ''             # Paginate items in this category
  categories:   []             # Paginate items in any of these categories
  tag:          ''             # Paginate items tagged with this tag
  tags:         []             # Paginate items tagged with any of these tags
```

Why set a pagination limit? For sites with lots of posts, this should speed up your build time considerably since Jekyll won't have to generate and write so many additional pages. Additionally, I suspect that it is very uncommon for users to browse paginated post indexes beyond a few pages. If you don't like it, it's easy to disable.

### Site-wide pagination defaults

You can set your own site-wide pagination defaults by configuring the `pagination` key in Jekyll's site config. 

<!-- title:"Site wide configuration _config.yml" -->

```yaml
pagination:
  limit: false
  per_page: 20
  title_suffix: " (page :num)"
```

Note: this will only change the defaults. A page's YAML front-matter will
override these defaults.

### Pagination permalinks

Assume your pagination template page was at `/index.html`. The second pagination page would be 
published to `/page2/index.html` by default. If your template page was at `/posts/index.html` or if was configured
with `permalink: /posts/` the second pagination page would be published to `/posts/page2/index.html`.


Here are some examples:

```
paginate:
  permalink /page-:num/  # => /page-2/index.html
  permalink /page/:num/  # => /page/2/index.html
  permalink /:num/       # => /2/index.html
```

You get the idea.

## Contributing

1. Fork it ( https://github.com/octopress/paginate/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
