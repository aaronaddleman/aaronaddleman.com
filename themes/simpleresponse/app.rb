# Use the app.rb file to load Ruby code, modify or extend the models, or
# do whatever else you fancy when the theme is loaded.

module Nesta
  class App
    # Uncomment the Rack::Static line below if your theme has assets
    # (i.e images or JavaScript).
    #
    # Put your assets in themes/simpleresponse/public/simpleresponse.
    #
    use Rack::Static, :urls => ["/simpleresponse"], :root => "themes/simpleresponse/public"

    helpers do
      # Add new helpers here.
      def display_menu_item(item, options = {})
        if item.respond_to?(:each)
          if (options[:levels] - 1) > 0
            haml_tag :li do
              display_menu(item, :levels => (options[:levels] - 1))
            end
          end
        else
          html_class = current_item?(item) ? "active" : nil
          haml_tag :li, :class => html_class do
            haml_tag :a, :<, :href => url(item.abspath) do
              haml_concat item.heading
            end
          end
        end
      end

    end

    # Add new routes here.
  end
end
