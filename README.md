# Extensionless pages when developing a Middleman site

Middleman offers one way to get pretty URLs – URLs without the `.html` suffix – through [Directory Indexes](http://middlemanapp.com/pretty-urls/). This is done by replacing the file with a directory, and making the file the index.html document of that directory.

In most cases, Directory Indexes is the simplest and most Middleman-ish way to go. 

But sometimes an alternative solution is needed. For me, the problem was that I was migrating an existing site, that already had been indexed by Google, and I did not want the URLs of the pages to change. 

## Using the web server to get rid of the extension
An alternative way, is to let the web server handle this. 

For example, on an Apache server, add this to the `.htaccess` file:

`Options +MultiViews` ([Documentation](http://httpd.apache.org/docs/current/content-negotiation.html#negotiation for some documentation)).
 
Other ways to achieve the same thing are to set it in the `httpd.conf` or to use redirects in the `.htaccess` file.

I have no experience with other types of servers, but I believe this possibility exists on most of them. On an Rack based server (like Sinatra or Ruby on Rails) I think that [TryStatic]( https://github.com/rack/rack-contrib/blob/master/lib/rack/contrib/try_static.rb), on which OptionalHtml is based, is a good way to do this.

As long as internal links in your source documents links to URL **with** the `.html` extension, you can now develop the site as usual. The only thing you need to watch out for, is that a URL like `http://www.domain.com/something`, may (depending on server configuration) point to `http://www.domain.com/something.html`, not `http://www.domain.com/something/index.html`, so avoid mixing files and directories with the same name. 

## Getting rid of extensions on the Middleman development server
In my case, with the migrated site, the internal links did not have the `.html` extension. So I created `optional_html`, to make the development server (`middleman server`) behave the same way as the web server for the built site. 

`optional_html` is based on [TryStatic]( https://github.com/rack/rack-contrib/blob/master/lib/rack/contrib/try_static.rb), but adapted to work when using Middlemans development server. 

If there is no match for the requested url, it will try the same url with some different versions of a .html suffix.

## Installation

To use, add

`gem "optional_html", :git => 'https://github.com/tommysundstrom/middleman-rack-optional-html.git'`

to your Gemfile and run `build install`

In `config.rb` add

```
require "rack/middleman/optional_html"
use Rack::OptionalHtml,
   :root => "/path/to/your/source/directory/",
   :urls => %w[/]
```

Please note that this is an early version. It seams to work as intended, but is not thoroughly tested yet.