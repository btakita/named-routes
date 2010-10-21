# NamedRoutes

A simple and generic named routes api. It works really well with Sinatra.

## Installation/Usage

    gem install named-routes

    require "named-routes"

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
    paths.prefix = "admin"

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
    paths.host = "example.com"
    path(:user, "/users/:user_id")
    paths.user(:user_id => 42) # => "/users/42"
    paths.http.user(:user_id => 42) # => "http://example.com/users/42"
    paths.https.user(:user_id => 42) # => "https://example.com/users/42"

It also works with prefixes:

    include NamedRoutes
    paths.host = "example.com"
    paths.prefix = "admin"
    path(:user, "/users/:user_id")
    paths.user(:user_id => 42) # => "/users/42"
    paths.http.user(:user_id => 42) # => "http://example.com/admin/users/42"
    paths.https.user(:user_id => 42) # => "https://example.com/admin/users/42"

And with query params:

    include NamedRoutes
    paths.host = "example.com"
    paths.prefix = "admin"
    path(:user, "/users/:user_id")
    paths.user(:user_id => 42, :foo => "bar of soap") # => "/users/42&foo=bar+of+soap"

## Advanced Usages

You can also inherit Routes to have different sets of Routes. This is useful if you want route sets with different prefixes.

    class AdminRoutes < NamedRoutes::Routes
      self.prefix = "admin"
    end

    class PartayRoutes < NamedRoutes::Routes
      self.prefix = "partay"
    end

    def admin_paths
      AdminRoutes
    end

    def partay_paths
      PartayRoutes
    end

    get admin_paths.path(:user, "/users/:user_id") do # => /admin/users/:user_id
      # ...
    end

    admin_paths.user(:user_id => 42) # => "/admin/users/42"

    get partay_paths.path(:user, "/users/:user_id") do # => /partay/users/:user_id
      # ...
    end

    partay_paths.user(:user_id => 42, :beer => "pabst") # => "/partay/users/42&beer=pabst"

Copyright (c) 2010 Brian Takita. This software is licensed under the MIT License.
