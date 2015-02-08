ENV["RAILS_ENV"] = "test"

require_relative "dummy/config/environment"
require "flyer"
require "timecop"
require "capybara/rails"
require "capybara/rspec"

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.order = :random
  config.include Capybara::DSL
  config.include Rails.application.routes.url_helpers
end