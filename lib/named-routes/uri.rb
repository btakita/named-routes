module NamedRoutes
  class Uri
    attr_reader :routes, :scheme

    def initialize(routes, scheme)
      @routes, @scheme = routes, scheme
    end

    def method_missing(method_name, *args, &block)
      "#{scheme}://#{routes.host}#{routes.send(method_name, *args, &block)}"
    end
  end
end
