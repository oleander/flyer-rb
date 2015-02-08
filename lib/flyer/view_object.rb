class Flyer::ViewObject < Struct.new(:controller, :path, :message, :params)
  attr_reader :params

  def initialize(controller, path, message, params)
    @controller = controller
    @path       = path
    @message    = message
    @params     = params
  end

  def message
    @controller.view_context.
      instance_eval(&@message).to_s.html_safe
  end

  def path
    raise PathNotGivenError.new unless @path
    @controller.instance_eval(&@path)
  end
end