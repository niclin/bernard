Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resource :punch_setting

  # Sidekiq Admin Web UI
  require "sidekiq/web"
  require "sidekiq/cron/web"
  authenticate :user, ->(user) { user.is_admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end
end
