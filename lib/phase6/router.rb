module Phase6
  class Route
    attr_reader :pattern, :http_method, :controller_class, :action_name

    def initialize(pattern, http_method, controller_class, action_name)
      @pattern = pattern
      @http_method = http_method
      @controller_class = controller_class
      @action_name = action_name
      # p @http_method
      # p @pattern
    end

    # checks if pattern matches path and method matches request method
    def matches?(req)
      if req.request_method.downcase.to_sym == @http_method &&
         req.path.match(@pattern)
          return true
      else
        return false
      end
    end

    # use pattern to pull out route params (save for later?)
    # instantiate controller and call controller action
    def run(req, res)
      matches = @pattern.match(req.path)
      route_names = matches.names
      route_params = {}
      route_names.each do |name|
        route_params[name] = matches[name]
      end
      @controller_class.new(req, res, route_params).invoke_action(@action_name)
    end
  end

  class Router
    attr_reader :routes

    def initialize
      @routes = []
    end

    # simply adds a new route to the list of routes
    def add_route(pattern, method, controller_class, action_name)
      @routes << Route.new(pattern, method, controller_class, action_name)
    end

    # evaluate the proc in the context of the instance
    # for syntactic sugar :)
    def draw(&proc)
      self.instance_eval(&proc)
    end

    # make each of these methods that
    # when called add route
    [:get, :post, :put, :delete].each do |http_method|
      define_method(http_method) do |pattern, controller_class, action_name|
        add_route(pattern, http_method, controller_class, action_name)
      end
    end

    # should return the route that matches this request
    def match(req)
      @routes.each do |route|
        if route.matches?(req)
          return true
        end
      end
      return nil
    end

    # either throw 404 or call run on a matched route
    def run(req, res)
      if match(req).nil?
        res.status = 404
      else
        run(req, res)
      end
    end
  end
end