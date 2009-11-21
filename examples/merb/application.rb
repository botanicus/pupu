class MerbExample < Merb::Controller
  def _template_location(action, type = nil, controller = controller_name)
    controller == "layout" ? "layout.#{type}" : "#{action}.#{type}"
  end

  def index
    render
  end

  def static
    render params[:template]
  end
end
