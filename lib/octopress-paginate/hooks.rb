module Octopress
  module Paginate
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
          Octopress::Paginate.page_payload(payload, page)
        end
      end
    end
  end
end
