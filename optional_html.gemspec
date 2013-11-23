Gem::Specification.new do |s|
  s.name        = 'optional_html'
  s.version     = '0.0.1'
  s.summary     = "Rack middleware to make html suffix optional for Middleman development server"
  s.description = "Rack middleware to make html suffix optional for Middleman development server. For production server, use for example Try Static"
  s.authors     = ["Tommy Sundström"]
  s.email       = 'tommy@heltenkelt.se'
  s.files       = %w[
      lib/rack/middleman/optional_html.rb
      lib/rack/middleman.rb
  ]
  s.homepage    = 'https://github.com/tommysundstrom/middleman-rack-optional-html'
end


