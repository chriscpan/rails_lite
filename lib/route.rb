class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
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

  # use pattern to pull out route params
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
