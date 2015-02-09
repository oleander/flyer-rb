module Flyer::ControllerAdditions
  #
  # @return Array<Flyer::ViewObject>
  #
  def notifications
    @notifications ||= begin
      limit = Flyer.settings.max_notifications ||
        Flyer::Notification.notifications.count

      found_notifications = []
      Flyer::Notification.notifications.each_with_index do |n, index|
        notification = Flyer::Notification.new(self)
        n.call(notification)
        notification.validate!
        if notification.visible? and index < limit
          notification.used!
          found_notifications << notification.view
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