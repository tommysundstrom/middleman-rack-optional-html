module Rack

  # The Rack::OptionalHtml middleware delegates requests to Rack::Static middleware
  #    * html etc
  # => * Tar bara hand om preview-delen av Middleman
  # => så måste ha motsvarande på apache e dyl 
  # => (jag kan inte andra servrar, men brukar finnas motsvarande)
  # trying to match a static file
  #
  # Examples
  #
  # use Rack::TryStatic,
  #   :root => "public",  # static files root dir
  #   :urls => %w[/],     # match all requests
  #   :try => ['.html', 'index.html', '/index.html'] # try these postfixes sequentially
  #
  #   uses same options as Rack::Static with extra :try option which is an array
  #   of postfixes to find desired file

  class OptionalHtml

    def initialize(app, options)
          @app = app
          @try = ['', '.html', 'index.html', '/index.html', '']   # Empty string in end to make error messages/logs correct.
          not_used = *options.delete(:try)
          ##@try = ['', *options.delete(:try)]
          ##@static = ::Rack::Static.new(
            #lambda { [404, {}, []] },
            #options)
        end

        def call(env)
          orig_path = env['PATH_INFO']
          found = nil
          @try.each do |path|
            resp = @app.call(env.merge!({'PATH_INFO' => orig_path + path})) # Using Middlemans server
            ##resp = @static.call(env.merge!({'PATH_INFO' => orig_path + path}))
            break if 404 != resp[0] && found = resp
          end
          found or @app.call(env.merge!('PATH_INFO' => orig_path))
        end
      end
    end
