module Flyer::ControllerAdditions
  #
  # @return Array<Flyer::ViewObject>
  #
  def notifications
    @notifications ||= begin
      limit = Flyer.settings.max_notifications ||
        Flyer::Notification.notifications.count

      found_notifications = []
      count = 0
      Flyer::Notification.notifications.each do |n|
        notification = Flyer::Notification.new(self)
        n.call(notification)
        notification.validate!
        if notification.visible? and count < limit
          notification.used!
          found_notifications << notification.view
          count += 1
        end
      end

      ids = found_notifications.map(&:id)
      unless ids.uniq.count == ids.count
        raise Flyer::FoundNonUniqueIds.new
      end

      found_notifications
    end
  end

  def self.included(base)
    base.helper_method :notifications
  end
end