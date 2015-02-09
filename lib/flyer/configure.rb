module Flyer
  def self.configure(&block)
    block.call(settings)
  end

  def self.settings
    @_settings ||= Configure.new
  end

  class Configure < Struct.new(:max_notifications)
  end
end