module Flyer
  NOTIFICATIONS = []
end

require "flyer/controller_additions"
require "flyer/notification"

ActionController::Base.class_eval do
  include Flyer::ControllerAdditions
end