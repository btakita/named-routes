require "extlib"
require "uri"

module NamedRoutes
  def path(*args, &block)
    routes.path(*args, &block)
  end

  def paths
    ::NamedRoutes::Routes
  end
  alias_method :routes, :paths

  extend self
end

dir = File.dirname(__FILE__)
require "#{dir}/named-routes/routes"
require "#{dir}/named-routes/schemed_uri"
