require "extlib"
require "uri"

module NamedRoutes
  def path(*args, &block)
    routes.path(*args, &block)
  end

  def routes
    ::NamedRoutes::Routes
  end
  extend self
end

dir = File.dirname(__FILE__)
require "#{dir}/named-routes/routes"
require "#{dir}/named-routes/uri"
