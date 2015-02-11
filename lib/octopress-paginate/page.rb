module Octopress
  module Paginate
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

        self.data['title'] ||= self.data['paginate']['collection'].capitlaize
        self.data['title'] << data['paginate']['title_suffix'].sub(/:num/, data['paginate']['page_num'].to_s)
      end
    end
  end
end
