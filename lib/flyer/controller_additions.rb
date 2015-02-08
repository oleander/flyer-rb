module Flyer::ControllerAdditions
  #
  # @return Array<Flyer::ViewObject>
  #
  def notifications
    @notifications ||= begin
      found_notifications = []
      Flyer::Notification.notifications.each do |n|
        notification = Flyer::Notification.new(self)
        n.call(notification)
        notification.validate!
        if notification.visible?
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