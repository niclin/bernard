class Holiday < ApplicationRecord
  validates :date, presence: true

  after_commit :flush_cache!

  # 建立一年份的假日
  def self.create_a_year_of_holidays!(year, add_date = [], remove_date = [])
    start_date = Date.new(year.to_i, 1, 1)
    end_date = Date.new(year.to_i, 12, 31)

    arr = begin
      (start_date..end_date).select { |a| (a.wday == 6 || a.wday == 0) }
          rescue StandardError
            []
    end

    add_date = add_date.map { |a| Date.parse(a) }
    remove_date = remove_date.map { |a| Date.parse(a) }

    a_year_of_holidays = ((arr + add_date) - remove_date).sort

    (start_date..end_date).each do |date|
      find_or_create_by!(date: date, is_holiday: a_year_of_holidays.include?(date))
    end
  end

  def self.at?(date)
    date = Date.parse(date.to_s)

    Rails.cache.fetch("#{date}_is_holiday") do
      find_by(date: date, is_holiday: true).present?
    end
  end

  private

  def flush_cache!
    Rails.cache.delete("#{date}_is_holiday")
  end
end

# == Schema Information
#
# Table name: holidays
#
#  id          :bigint           not null, primary key
#  date        :date
#  description :text
#  is_holiday  :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
