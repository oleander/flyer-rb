class Flyer::Notification
  attr_accessor :expire, :params, :id, :limit

  def self.init(&block)
    Flyer::NOTIFICATIONS << block
  end

  def initialize(controller)
    @on = []
    @controller = controller
  end

  def smessage(&block)
    @message = block
  end

  def message
    @controller.view_context.
      instance_eval(&@message).html_safe
  end

  def on(&block)
    @on << block
  end

  def run?
    if not hit_limit? and not expired?
      @on.all?{ |blk| @controller.instance_eval(&blk) }
    end
  end

  def used!
    cookies.signed.permanent[token] = current_count + 1
  end

  def expired?
    @expire && Date.parse(@expire) < Date.today
  end

  def spath(&block)
    @spath = block
  end

  def path
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