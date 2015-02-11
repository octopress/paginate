require "octopress-hooks"
require "octopress-paginate/version"
require "octopress-paginate/hooks"
require "octopress-paginate/page"

module Octopress
  module Paginate
    extend self

    DEFAULT = {
      'collection'   => 'posts',
      'per_page'     => 10,
      'limit'        => 5,
      'permalink'    => '/page:num/',
      'title_suffix' => ' - page :num',
      'page_num'     => 1
    }

    LOOP = /(paginate.+\s+in)\s+(site\.(.+?))(.+)%}/

    def paginate(page)
      if page.data['paginate'].is_a? Hash
        page.data['paginate'] = DEFAULT.merge(page.data['paginate'])
      else
        page.data['paginate'] = DEFAULT
      end

      if tag = page.data['paginate']['tag']
        page.data['paginate']['tags'] = Array(tag)
      end

      if category = page.data['paginate']['category']
        page.data['paginate']['categories'] = Array(category)
      end

      add_pages(page)
    end

    def add_pages(page)
      config = page.data['paginate']
      pages = (collection(page).size.to_f / config['per_page']).ceil - 1

      if config['limit'] > 0
        pages = [pages, config['limit'] - 1].min
      end

      page.data['paginate']['pages'] = pages + 1

      new_pages = []

      pages.times do |i|
        new_pages << PaginationPage.new(page.site, page.site.source, i+2, page)
      end

      all_pages = [page].concat(new_pages)

      all_pages.each_with_index do |p, index|

        if index > 0
          prev_page = all_pages[index - 1]
          p.data['paginate']['previous_page'] = index
          p.data['paginate']['previous_page_path'] = prev_page.url
        end

        if next_page = all_pages[index + 1]
          p.data['paginate']['next_page'] = index + 2
          p.data['paginate']['next_page_path'] = next_page.url
        end
      end

      page.site.pages.concat new_pages
    end

    def collection(page)
      collection = if page['paginate']['collection'] == 'posts'
        if defined?(Octopress::Multilingual) && page.lang
          page.site.posts_by_language[page.lang]
        else
          page.site.posts.reverse
        end
      else
        page.site.collections[page['paginate']['collection']].docs
      end

      if categories = page.data['paginate']['categories']
        collection = collection.reject{|p| (p.categories & categories).empty?}
      end

      if tags = page.data['paginate']['tags']
        collection = collection.reject{|p| (p.tags & tags).empty?}
      end

      collection
    end

    def page_payload(payload, page)
      config = page.data['paginate']
      collection = collection(page)
      { 'paginator' => {
        "#{config['collection']}"       => items(payload, collection),
        "page"                          => config['page_num'],
        "per_page"                      => config['per_page'],
        "limit"                         => config['limit'],
        "total_#{config['collection']}" => collection.size,
        "total_pages"                   => config['pages'],
        'previous_page'                 => config['previous_page'],
        'previous_page_path'            => config['previous_page_path'],
        'next_page'                     => config['next_page'],
        'next_page_path'                => config['next_page_path']
      }}
    end

    def items(payload, collection)
      config = payload['page']['paginate']

      n = (config['page_num'] - 1) * config['per_page']
      max = n + (config['per_page'] - 1)

      collection[n..max]
    end

  end
end
