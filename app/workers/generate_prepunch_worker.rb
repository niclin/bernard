class GeneratePrepunchWorker
  include Sidekiq::Worker

  sidekiq_options retry: false
  sidekiq_options unique: :until_and_while_executing

  def perform
    PunchSetting.enable.find_each do |punch_setting|
    end
  end
end