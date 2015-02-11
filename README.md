# Octopress Paginate

Simple and flexible pagination for Jekyll sites featuring:

- Simple configuration
- Paginate posts and collections
- Page limits (Because who's reading page 35?)
- Filter by categories or tags
- Multi-language support (with [octopress-multilingual](https://github.com/octopress/multilingual))

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

### To paginate posts

Create a page to be used as the pagination template.

```
---
title: Post Index
paginate: true
---

{% for post in paginator.posts %}
/ do stuff /
{% endfor %}
```

### To paginate collections

This is basically the same as paginating posts, except you have to configure the paginate collection and set up the paginator to
use the collection name.

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

### Template variables

Just like Jekyll's paginator, your pagination pages will have access to the following liquid variables.


```yaml
{{ paginator.total_pages }}          # Number of paginated pages
{{ paginator.total_posts }}          # Total number of posts being paginated
{{ paginator.per_page }}             # Posts per page
{{ paginator.limit }}                # Maximum number of paginated pages
{{ paginator.page }}                 # Current page number
{{ paginator.previous_page }}        # Previous page number (nil if first page)
{{ paginator.previous_page_path }}   # Url for previous page (nil if first page)
{{ paginator.next_page }}            # Next page number (nil if last page)
{{ paginator.next_page_path }}       # Next page URL (nil if last page)

# If you're pagination through a collection named `penguins`
{{ pagination.total_penguins }}      # Total number of peguins being paginated
```

## Configuration

In a page's YAML front-matter, setting `paginate: true` turns that page into a template for pagination. To configure pagination,
set the options for the `paginate` key. Here are the defaults.

```yaml
paginate:
  collection:   posts
  per_page:     10             # maximum number of posts per page 
  limit:        5              # Maximum number of pages to paginate (0 for unlimited)
  permalink:    /page:num/     # pagination path (relative to template page)
  title_suffix: " - page :num" # Append to template's page title
  category:     ''             # Paginate posts in this category
  categories:   []             # Paginate posts in any of these categories
  tag:          ''             # Paginate posts tagged with this tag
  tags:         []             # Paginate posts tagged with any of these tags
```

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
