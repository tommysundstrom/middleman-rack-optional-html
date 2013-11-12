module Rack

  # The Rack::OptionalHtml middleware handles extensionless pages on the Middleman server
  #
  # If there is no match for an url, it will try the same url with some different versions of a .html suffix.
  #
  # The effect is similar to using the Directory Index extension, but is less intrusive in that it will not
  # introduce extra directories, rename the actual page to index.html, etc. Hopefully (but not tested yet)
  # it will also make it easier to link to images.
  #    But, it will only have effect on the Middleman development server. In order to get the same effect on
  # the sharp site, you will need to configure that server to do the same.
  #
  # The easiest way to enable this on an Apache server, add this to the .htaccess file:
  #
  # Options +MultiViews
  #
  # (see http://httpd.apache.org/docs/current/content-negotiation.html#negotiation for some documentation).
  # Other ways are to set it in the httpd.conf or to use redirects in the .htaccess file.
  #
  # I have no experience with other types of servers. On an Rack based server (like Sinatra or Ruby on Rails)
  # I believe that TryStatic ( https://github.com/rack/rack-contrib/blob/master/lib/rack/contrib/try_static.rb )
  # (on which OptionalHtml is based) can be used.
  #
  #
  # To use, add
  #
  # gem "optional_html"
  #
  # to your Gemfile and run `build install`
  #
  # In `config.rb` add
  #
  #   require "rack/middleman/optional_html"
  #   use Rack::OptionalHtml,
  #       :root => "/path/to/your/source/directory/",
  #       :urls => %w[/]
  #
  # Please note that this is an early version. It seams to work as intended, but is not thoroughly tested yet.

  class OptionalHtml

    def initialize(app, options)
        @app = app
        @try = ['', '.html', 'index.html', '/index.html']
      end

      def call(env)
        orig_path = env['PATH_INFO']
        found = nil
        @try.each do |path|
          resp = @app.call(env.merge!({'PATH_INFO' => orig_path + path})) # Using Middleman’s server
          break if 404 != resp[0] && found = resp
        end
        found or @app.call(env.merge!('PATH_INFO' => orig_path))
      end
    end
  end
