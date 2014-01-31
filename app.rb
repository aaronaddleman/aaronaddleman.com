# Use the app.rb file to load Ruby code, modify or extend the models, or
# do whatever else you fancy when the theme is loaded.

# pagination array
require 'will_paginate'
require 'will_paginate/array'
require 'will_paginate/view_helpers/sinatra'

# table of contents support
require 'maruku'
require 'nokogiri'

# code coloring
# require "rack/pygments"

require 'date'
require 'json'

module Nesta
  class FileModel
    def updates
      JSON.parse(metadata('updates'))
    end
  end

  module Overrides
    module Renderers
      def json(template, options = {}, locals = {})
        defaults, engine = Overrides.render_options(template, :haml)
        renderer = Sinatra::Templates.instance_method(engine)
        renderer.bind(self).call(template, defaults.merge(options), locals)
      end
    end
  end

  class App
    Tilt.prefer Tilt::RedcarpetTemplate
    # Uncomment the Rack::Static line below if your theme has assets
    # (i.e images or JavaScript).
    #
    # Put your assets in themes/pro_v0.1/public/pro_v0.1.
    #
    # use Rack::Static, :urls => ["/pro_v0.2"], :root => "themes/pro_v0.2/public"

    helpers WillPaginate::Sinatra::Helpers

    
    

    def print_code(opt={})
      filename = opt[:filename]
      theme = opt[:theme] || "brilliance_black"
      syntax = opt[:syntax]
      show_code = opt[:show_code] || true

      text = File.read(Dir.pwd + '/public/' + filename)
      processor = Textpow::RecordingProcessor.new
      result = Uv.parse( text, "xhtml", syntax, false, "eiffel")

      # download_link = "<span id=\"download\"><a href=\"/#{filename}\">Download the #{filename.split("/").last}</a></span>"

      haml(:print_code, :layout => false, :locals => { :code => result, :filename => filename })

      case show_code
      when true
        return haml(:print_code, :layout => false, :locals => { :code => result, :filename => filename })
      when false
        return download_link
      end
      
      # result = result + download_link
      # return result
    end

    helpers do
      # Add new helpers here.
      def can_generate_toc?
        [:Maruku, :Nokogiri].all? { |cls| Object.const_defined?(cls) }
      end

      # Provide page TOC
      def toc(page, toc_template = :table_of_contents)
        return nil unless can_generate_toc?
        # headings = Nokogiri::HTML(page.body(self)).css('h2 h3')
        headings = Nokogiri::HTML(page.body(self)).xpath('//h2')

        toc_headers = headings.inject({}) do |mappings, header_node|
          mappings[header_node.attr('id')] = header_node.content
          mappings
        end
        haml(toc_template, :layout => false, :locals => { :toc_headers => toc_headers })
      end
      
      def protected!
        unless authorized?
          response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
          throw(:halt, [401, "Not authorized\n"])
        end
      end

      def authorized?
        @auth ||=  Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['admin', 'admin']
      end
      
    end

    
    # Add new routes here.
    get '/protected/*' do
      protected!
      # "Welcome, authenticated client"
      
      set_common_variables
      parts = params[:splat].map { |p| p.sub(/\/$/, '') }
      @page = Nesta::Page.find_by_path(File.join(parts))
      raise Sinatra::NotFound if @page.nil?
      @title = @page.title
      set_from_page(:description, :keywords)
      cache haml(@page.template, :layout => @page.layout)
      
    end

    get '/feed/:name.json' do
      # content_type :xml, :charset => 'utf-8'
      set_from_config(:title, :subtitle, :author)
      # @articles = Page.find_articles.select { |a| a.date }[0..9]
      @articles = Page.find_articles
      cache haml(:all, :format => :xhtml, :layout => false)
    end

    get '/example.json' do
      content_type :json
      { :key1 => 'value1', :key2 => 'value2' }.to_json
    end

  end
end
