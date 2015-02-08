Rails.application.routes.draw do
  root to: "application#index"
  get "/path" => "application#path", as: "path"
  get "/data" => "application#data", as: "data"
end