class ControllerBase
  attr_reader :req, :res

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
    @already_built_response = false
    @params = Params.new(req, route_params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise if already_built_response?
    @res.status=302
    @res.header["location"] = url
    @already_built_response = true
    @session.store_session(@res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise if already_built_response?
    @res.body = content
    @res.content_type = content_type
    @already_built_response = true
    @session.store_session(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    template = File.read("views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
    erb_template = ERB.new(template).result(binding)

    render_content(erb_template, "text/html")
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    if !already_built_response?
      self.send(name)
    end
  end

  def session
    @session ||= Session.new(@res)
  end
end
