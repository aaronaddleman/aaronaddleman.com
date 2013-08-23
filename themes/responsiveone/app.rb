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
    use Rack::Static, :urls => ['/responsiveone'], :root => 'themes/responsiveone/public'
    helpers WillPaginate::Sinatra::Helpers

    helpers do

      def display_magellan(menu, options = {})
        defaults = { :class => nil, :levels => 2 }
        options = defaults.merge(options)
        if options[:levels] > 0
          haml_tag :ul, :class => options[:class] do
            menu.each do |item|
              display_menu_item(item, options)
            end
          end
        end
      end

      def display_menu_item(item, options = {})
        a_class = options[:aclass] || ""
        if item.respond_to?(:each)
          if (options[:levels] - 1) > 0
            haml_tag :li do
              display_menu(item, :levels => (options[:levels] - 1))
            end
          end
        else
          html_class = current_item?(item) ? "current" : nil
          haml_tag :li, :class => html_class do
            haml_tag :a, :<, :href => url(item.abspath), :class => "#{a_class.to_s}" do
              haml_concat item.heading
            end
          end
        end
      end

    end


  end
  
  class Page < FileModel
    def heading
      regex = case @format
        when :mdown
          /^#\s*(.*?)(\s*#+|$)/
        when :haml
          /^\s*%h1\s+(.*)/
        when :textile
          /^\s*h1\.\s+(.*)/
        end
      markup =~ regex
      Regexp.last_match(1)
    end
  end

end
