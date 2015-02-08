# Flyer

Handle user notifications in Rails programmatically.

## Install

`gem install flyer`

## Usage

``` ruby
# config/initializers/flyer.rb
Flyer::Notification.init do |config|
  # Unique id. Used to uniquely identify a notification.
  config.id = "new-user"

  # Message to be passed to view. Is evaluated in the view context.
  config.message { "Your nickname is #{current_user.nickname}" + icon "flash" }

  # Optional. Path to be pssed to view. Is evaluated in the controller context.
  config.path { challenge_path }

  # Optional. Only display notification if this blocks evaluates to true
  # The block is evaluated in the controller context.
  config.on { current_user.admin? and not first_visit? }

  # Optional. Number of times to display the notification 
  # for each user. Default is 1.
  config.limit = 1

  # Optional. When should the notification be visible?
  config.valid = { from: "2015-04-01", to: "2016-04-01" }

  # Optional. Arbitrary data to be passed to view. 
  config.params = { timeout: 10 }
end
```

``` erb
-- app/views/_notifications.html.erb (any view)
<% notifications.each do |notification| %>
  <%= notification.path %>
  <%= notification.message %>
  <%= notification.params %>
<% end %>
```