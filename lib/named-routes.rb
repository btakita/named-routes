require "active_support"
begin
  require "active_support/hash_with_indifferent_access"
rescue LoadError
  require "active_support/core_ext/hash/indifferent_access"
end
begin
  require "active_support/core_ext/object/to_query"
rescue LoadError
  require "active_support/core_ext/object/conversions"
  require "active_support/core_ext/array/conversions"
  require "active_support/core_ext/hash/conversions"
end
require "active_support/core_ext/class/inheritable_attributes"
require "uri"

module NamedRoutes
  def named_route(*args, &block)
    named_routes.uri(*args, &block)
  end
  alias_method :path, :named_route
  alias_method :route, :named_route
  alias_method :uri, :named_route

  def named_routes
    ::NamedRoutes::Routes
  end
  alias_method :paths, :named_routes
  alias_method :routes, :named_routes
  alias_method :uris, :named_routes

  extend self
end

dir = File.dirname(__FILE__)
require "#{dir}/named-routes/concern"
require "#{dir}/named-routes/routes"
require "#{dir}/named-routes/schemed_uri"
