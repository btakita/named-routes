# NamedRoutes

A simple and generic named routes api where you can define and call named routes.

## Installation/Usage

    gem install named-routes

## Route Definitions

You can define a named route by providing the name of the method and the definition.

    NamedRoutes.path(:user, "/users/:user_id") # => "/users/:user_id"

You can use this in conjunction with Sinatra routes like so:

    include NamedRoutes
    get path(:user, "/users/:user_id") do
      # ...
    end

If you have multiple handlers for the same route, you can use the block syntax:

    include NamedRoutes
    path(:user, "/users/:user_id") do |_|
      get _ do
        # ...
      end

      post _ do
        # ...
      end
    end

You can also define prefixes on the route definitions:

    include NamedRoutes
    routes.prefix = "admin"

    path(:user, "/users/:user_id") do |_| # => /admin/users/:user_id
      get _ do
        # ...
      end

      post _ do
        # ...
      end
    end

## Route Helpers

You can access the routes by doing the following.

    include NamedRoutes
    routes.host = "example.com"
    path(:user, "/users/:user_id")
    routes.user(:user_id => 42) # => "/users/42"
    routes.http.user(:user_id => 42) # => "http://example.com/users/42"
    routes.https.user(:user_id => 42) # => "http://example.com/users/42"

It also works with prefixes.

    include NamedRoutes
    routes.host = "example.com"
    routes.prefix = "admin"
    path(:user, "/users/:user_id")
    routes.user(:user_id => 42) # => "/users/42"
    routes.http.user(:user_id => 42) # => "http://example.com/admin/users/42"
    routes.https.user(:user_id => 42) # => "http://example.com/admin/users/42"

## Advanced Usages

You can also inherit Routes to have different sets of Routes. This is useful if you want route sets with different prefixes.

    class AdminRoutes < NamedRoutes::Routes
      self.prefix = "admin"
    end

    class PartayRoutes < NamedRoutes::Routes
      self.prefix = "partay"
    end

    def admin_routes
      AdminRoutes
    end

    def partay_routes
      PartayRoutes
    end

    get admin_routes.path(:user, "/users/:user_id") do # => /admin/users/:user_id
      # ...
    end

    admin_routes.user(:user_id => 42) => "/admin/users/42"

    get partay_routes.path(:user, "/users/:user_id") do # => /partay/users/:user_id
      # ...
    end

    partay_routes.user(:user_id => 42) => "/partay/users/42"

Copyright (c) 2010 Brian Takita. This software is licensed under the MIT License.
