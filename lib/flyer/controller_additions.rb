module Flyer::ControllerAdditions
  def notifications
    @notifications ||= begin
      found_notifications = []
      Flyer::Notification.notifications.each do |n|
        notification = Flyer::Notification.new(self)
        n.call(notification)
        notification.validate!
        if notification.run?
          notification.used!
          found_notifications << notification.view
        end
      end

      found_notifications
    end
  end

  def self.included(base)
    base.helper_method :notifications
  end
end