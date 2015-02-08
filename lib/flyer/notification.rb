require_relative "errors"
require_relative "view_object"

class Flyer::Notification
  attr_accessor :valid, :params, :id, :limit

  @@notifications = []

  def self.init(&block)
    @@notifications << block
  end

  def self.reset!
    @@notifications = []
  end

  #
  # @return Array<Flyer::Notification>
  #
  def self.notifications
    @@notifications
  end

  #
  # @controller ActionController::Base
  #
  def initialize(controller)
    @on = []
    @controller = controller
  end

  #
  # Raise an error if @id or @message is missing
  #
  def validate!
    raise IdMissingError.new unless @id
    raise MessageMissingError.new unless @message
  end

  #
  # Mark current notification has used
  #
  def used!
    cookies.signed.permanent[token] = current_count + 1
  end

  #
  # @return Boolean Has the notification expired?
  #
  def expired?
    return false unless @valid

    if @valid[:to]
      if Date.parse(@valid.fetch(:to)) < Date.today
        return true
      end
    end

    if @valid[:from]
      if Date.parse(@valid.fetch(:from)) > Date.today
        return true
      end
    end
  end

  #
  # @return Boolean Should the notification be visible?
  #
  def visible?
    return false if hit_limit?
    return false if expired?
    return true if @on.empty?
    @on.any?{ |blk| @controller.instance_eval(&blk) }
  end

  #
  # @return Flyer::ViewObject Object to be passed to view
  #
  def view
    Flyer::ViewObject.new(@controller, @path, @message, @params)
  end

  #
  # @block Proc The evaluation if @block should yield a path
  #
  def path(&block)
    @path = block
  end

  #
  # @block Proc The evaluation if @block should yield a string
  #
  def message(&block)
    @message = block
  end

  #
  # @block Proc The evaluation if @block should yield a boolean
  #
  def on(&block)
    @on << block
  end

  private

  def token
    "not.#{id}"
  end

  def hit_limit?
    limit and current_count >= limit
  end

  def current_count
    cookies.signed[token].to_i
  end

  def cookies
    @controller.send(:cookies)
  end
end