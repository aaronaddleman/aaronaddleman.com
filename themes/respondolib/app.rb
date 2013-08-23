# Use the app.rb file to load Ruby code, modify or extend the models, or
# do whatever else you fancy when the theme is loaded.

# pagination
require 'will_paginate'
require 'will_paginate/array'
require 'will_paginate/view_helpers/sinatra'

# table of contents support
require 'maruku'
require 'nokogiri'

# code coloring
# require "rack/pygments"

module Nesta
  class App
    Tilt.prefer Tilt::RedcarpetTemplate
    use Rack::Static, :urls => ['/respondolib'], :root => 'themes/respondolib/public'
    helpers WillPaginate::Sinatra::Helpers
  end
end
