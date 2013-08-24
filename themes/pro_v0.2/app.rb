# # Use the app.rb file to load Ruby code, modify or extend the models, or
# # do whatever else you fancy when the theme is loaded.

# # pagination
# require 'will_paginate'
# require 'will_paginate/array'
# require 'will_paginate/view_helpers/sinatra'

# # table of contents support
# require 'maruku'
# require 'nokogiri'

# # code coloring
# # require "rack/pygments"

# require 'date'

module Nesta
  class App
    # Tilt.prefer Tilt::RedcarpetTemplate
    # Uncomment the Rack::Static line below if your theme has assets
    # (i.e images or JavaScript).
    #
    # Put your assets in themes/pro_v0.1/public/pro_v0.1.
    #
    use Rack::Static, :urls => ["/pro_v0.2"], :root => "themes/pro_v0.2/public"

    helpers do
      # Add new helpers here.    
    end

    # Add new routes here.

  end
end
