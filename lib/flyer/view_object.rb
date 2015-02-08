class Flyer::ViewObject
  attr_reader :params

  #
  # @controller ActionController::Base
  # @path Proc
  # @message Proc
  # @params Hash
  #
  def initialize(controller, path, message, params)
    @controller = controller
    @path       = path
    @message    = message
    @params     = params
  end

  #
  # @return String
  #
  def message
    @controller.view_context.
      instance_eval(&@message).to_s.html_safe
  end

  #
  # @return Path / String
  #
  def path
    raise PathNotGivenError.new unless @path
    @controller.instance_eval(&@path)
  end
end