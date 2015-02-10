require "octopress-hooks"
require "octopress-paginate/version"

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

    class SiteHook < Hooks::Site
      def post_read(site)
        site.pages.select {|p| p.data['paginate'] }.each do |page|
          Octopress::Paginate.paginate(page)
        end
      end
    end

    class PageHook < Hooks::Page
      def merge_payload(payload, page)
        if page.data['paginate']
          Octopress::Paginate.page_payload(payload)
        end
      end
    end

    class PaginationPage < Jekyll::Page
      def initialize(site, base, index, template)
        @site = site
        @base = base
        @dir  = File.join(template.dir, template.data['paginate']['permalink'].clone.sub(':num', index.to_s))
        @name = 'index.html'
        process(name)
        read_yaml(File.join(base, File.dirname(template.path)), File.basename(template.path))

        self.data.delete('permalink')
        self.data.merge!({ 'paginate' => template.data['paginate'].clone })
        self.data['paginate']['page_num'] = index
        self.data['title'] << data['paginate']['title_suffix'].sub(/:num/, data['paginate']['page_num'].to_s)
      end
    end

    def paginate(page)
      page.data['paginate'].merge!(DEFAULT.merge(page.data['paginate']))
      add_pages(page)
    end

    def add_pages(page)
      config = page.data['paginate']
      pages = collection(page).size / config['per_page']

      if config['limit'] > 0
        pages = [pages, config['limit'] - 1].min
      end

      pages.times do |i|
        page.site.pages << PaginationPage.new(page.site, page.site.source, i+2, page)
      end
    end

    def collection(page)
      if page['paginate']['collection'] == 'posts'
        page.site.posts
      else
        page.site.collections[page['paginate']['collection']]
      end
    end

    def page_payload(payload)
      p = {}
      p['site'] = {}
      p['site'][payload['page']['paginate']['collection']] = items(payload)
      p
    end

    def items(payload)
      site = payload['site']
      config = payload['page']['paginate']

      items = site[config['collection']]
      n = (config['page_num'] - 1) * config['per_page']
      max = n + (config['per_page'] - 1)
      items[n..max]
    end

  end
end
