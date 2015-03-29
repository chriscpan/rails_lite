require_relative '../phase3/controller_base'
require_relative './session'

module Phase4
  class ControllerBase < Phase3::ControllerBase
    def redirect_to(url)
      session
      super(url)
      @session.store_session(@res)
    end

    def render_content(content, content_type)
      session
      super(content, content_type)
      @session.store_session(@res)
    end

    # method exposing a `Session` object
    def session
      @session ||= Session.new(@res)
    end
  end
end