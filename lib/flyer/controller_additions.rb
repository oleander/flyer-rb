module Flyer::ControllerAdditions
  def notifications
    found_notifications = []
    Flyer::Notification.notifications.each do |n|
      notification = Flyer::Notification.new(self)
      n.call(notification)
      if notification.run?
        found_notifications << notification
      end
    end

    found_notifications.each(&:used!)
  end

  def self.included(base)
    base.helper_method :notifications
  end
end