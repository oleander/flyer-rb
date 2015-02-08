class Flyer::ViewObject
  attr_reader :params, :id

  #
  # @controller ActionController::Base
  # @path Proc
  # @message Proc
  # @params Hash
  # @id Object
  #
  def initialize(controller, path, message, params, id)
    @controller = controller
    @path       = path
    @message    = message
    @params     = params
    @id         = id
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
    raise Flyer::PathNotGivenError.new unless @path
    @controller.instance_eval(&@path)
  end
end