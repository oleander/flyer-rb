Rails.application.routes.draw do
  root to: "application#index"
  get "/path" => "application#path", as: "path"
end