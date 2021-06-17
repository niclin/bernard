# frozen_string_literal: true

require "sidekiq"
require "sidekiq/web"
require "sidekiq-status"
require "sidekiq-status/web"
require "sidekiq/cron/web"

Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDIS_URL"] }

  config.average_scheduled_poll_interval = 10
  # sidekiq-status
  config.server_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Server
    chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes
  end
  # sidekiq-status
  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
    chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes
  end

  SidekiqUniqueJobs::Server.configure(config)
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_URL"] }

  # sidekiq-status
  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
    chain.add Sidekiq::Status::ClientMiddleware
  end
end

# sidekiq-cron
schedule_file = "config/schedule.yml"

if Rails.env.development?
  dev_schedule_file= "config/schedule.dev.yml"
  if File.exist?(dev_schedule_file)
    schedule_file = dev_schedule_file
  end
end

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
