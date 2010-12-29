require "extlib"
require "uri"

module NamedRoutes
  def uri(*args, &block)
    routes.uri(*args, &block)
  end
  alias_method :path, :uri
  alias_method :route, :uri

  def uris
    ::NamedRoutes::Routes
  end
  alias_method :paths, :uris
  alias_method :routes, :uris

  extend self
end

dir = File.dirname(__FILE__)
require "#{dir}/named-routes/routes"
require "#{dir}/named-routes/schemed_uri"
