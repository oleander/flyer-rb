require_relative "errors"

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
    raise IdMissingError.new unless id
    raise MessageMissingError.new unless message
  end

  def smessage(&block)
    @message = block
  end

  def message
    @controller.view_context.
      instance_eval(&@message).to_s.html_safe
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

    a1, a2 = false, false
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

  def spath(&block)
    @spath = block
  end

  def path
    raise PathNotGivenError.new unless @spath
    @controller.instance_eval(&@spath)
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