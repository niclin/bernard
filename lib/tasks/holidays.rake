# 每年行政局行事曆公布之後
# 設定 year(年份) / holidays(放假日) / remove_weekends(補班日) 的 methods
# 執行 rake migration:build:holiday 即可
class HolidayTasks
  include Rake::DSL

  def initialize
    namespace :migration do
      namespace :build do
        task holiday: :environment do
          generate!
        end
      end
    end
  end

  private

  def generate!
    Holiday.create_a_year_of_holidays!(year, holidays.keys, removed_weekends)

    holidays.each do |date, description|
      holiday = Holiday.find_or_create_by(date: date)
      holiday.update(description: description, is_holiday: true)
    end
  end

  # 年度
  def year
    "2022"
  end

  # 放假日
  def holidays
    {
      "#{year}/1/1" => "元旦",
      "#{year}/1/31" => "除夕",
      "#{year}/2/1" => "春節(初一)",
      "#{year}/2/2" => "春節(初二)",
      "#{year}/2/3" => "春節(初三)",
      "#{year}/2/4" => "彈性放假(初四)",
      "#{year}/2/5" => "春節(初五)",
      "#{year}/2/28" => "和平紀念日",
      "#{year}/4/4" => "兒童節",
      "#{year}/4/5" => "清明節",
      "#{year}/5/1" => "勞動節",
      "#{year}/5/2" => "勞動節(補假)",
      "#{year}/6/3" => "端午節",
      "#{year}/9/9" => "中秋節(補假)",
      "#{year}/9/10" => "中秋節",
      "#{year}/10/10" => "國慶日",
    }
  end

  # 補班日
  def removed_weekends
    ["#{year}/1/22"]
  end
end

HolidayTasks.new
