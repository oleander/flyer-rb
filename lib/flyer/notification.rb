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

  def self.notifications
    @@notifications
  end

  def initialize(controller)
    @on = []
    @controller = controller
  end

  def validate!
    raise IdMissingError.new unless @id
    raise MessageMissingError.new unless @message
  end

  def on(&block)
    @on << block
  end

  def run?
    return false if hit_limit?
    return false if expired?
    return true if @on.empty?
    @on.any?{ |blk| @controller.instance_eval(&blk) }
  end

  def used!
    cookies.signed.permanent[token] = current_count + 1
  end

  def expired?
    return false unless @valid

    if @valid.fetch(:to)
      if Date.parse(@valid.fetch(:to)) < Date.today
        return true
      end
    end

    if @valid.fetch(:from) 
      if Date.parse(@valid.fetch(:from)) > Date.today
        return true
      end
    end
  end

  def view
    Flyer::ViewObject.new(@controller, @path, @message, @params)
  end

  def path(&block)
    @path = block
  end

  def message(&block)
    @message = block
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