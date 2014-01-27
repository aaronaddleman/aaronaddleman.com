# Use the app.rb file to load Ruby code, modify or extend the models, or
# do whatever else you fancy when the theme is loaded.

module Nesta
  class App
    # Uncomment the Rack::Static line below if your theme has assets
    # (i.e images or JavaScript).
    #
    # Put your assets in themes/foundationized/public/foundationized.
    #
    use Rack::Static, :urls => ["/foundationized"], :root => "themes/foundationized/public"

    def foundation_pager(str)
      @doc = Nokogiri::XML::DocumentFragment.parse(str)
      @doc.search('div').map { |e| e.node_name = "ul" }
      @doc.css('a').wrap("<li></li>")
      @doc.css('span[class="gap"]').wrap("<li class=\"unavailable\"></li>")
      @doc.search("span[class='gap']").map { |e| e.node_name = "a"; e.content = "..."}
      @doc.css('em').wrap("<li class=\"current\"></li>")
      @doc.search('./ul/li/em').map {|e| e.node_name = "a"}
      @doc.css('span[class="previous_page disabled"]').wrap("<li class=\"unavailable\"></li>")
      @doc.search('./ul/li/span').map {|e| e.node_name = "a"}
      @doc.to_html
    end

    helpers do
      # Add new helpers here.
      def pages_heading
        @page.metadata('projects heading') || "Pages on #{@page.heading}"
      end
    end

    # Add new routes here.
    get '/css/:sheet.css' do
      content_type 'text/css', :charset => 'utf-8'
      cache scss(params[:sheet].to_sym)
    end
  end
end
