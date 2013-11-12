require 'rack'

module Rack
  module Middleman
    def self.release
      "0.0.1"
    end
  end

  autoload :OptionalHtml,               "rack/middleman/optional_html"  
end
