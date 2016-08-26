module Octopress
  module Paginate
    if defined?(Jekyll::Hooks)
      Jekyll::Hooks.register :site, :post_read, priority: :low do |site|
        site.pages.select {|p| p.data['paginate'] }.each do |page|
          Octopress::Paginate.paginate(page)
        end
      end
      Jekyll::Hooks.register :pages, :pre_render do |page, payload|
        if page.data['paginate']
          payload['paginator'] = Octopress::Paginate.page_payload(payload, page)
        end
      end
    else
      require 'octopress-hooks'
      class SiteHook < Hooks::Site
        priority :low

        def post_read(site)
          site.pages.select {|p| p.data['paginate'] }.each do |page|
            Octopress::Paginate.paginate(page)
          end
        end
      end

      class PageHook < Hooks::Page
        def merge_payload(payload, page)
          if page.data['paginate']
            payload['paginator'] = Octopress::Paginate.page_payload(payload, page)
          end
        end
      end
    end
  end
end
