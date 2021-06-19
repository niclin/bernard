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
    "2021"
  end

  # 放假日
  def holidays
    {
      "#{year}/1/1" => "元旦",
      "#{year}/2/10" => "彈性放假",
      "#{year}/2/11" => "除夕",
      "#{year}/2/12" => "春節(初一)",
      "#{year}/2/13" => "春節(初二)",
      "#{year}/2/14" => "春節(初三)",
      "#{year}/2/15" => "彈性放假(初四)",
      "#{year}/2/16" => "彈性放假(初五)",
      "#{year}/2/28" => "和平紀念日",
      "#{year}/3/1" => "彈性放假",
      "#{year}/4/2" => "彈性放假",
      "#{year}/4/3" => "兒童節",
      "#{year}/4/4" => "清明節",
      "#{year}/4/5" => "彈性放假",
      "#{year}/5/1" => "勞動節",
      "#{year}/6/14" => "端午節",
      "#{year}/9/18" => "中秋節",
      "#{year}/9/20" => "彈性放假",
      "#{year}/10/10" => "國慶日",
      "#{year}/10/11" => "彈性放假",
      "#{year}/12/31" => "彈性放假",
    }
  end

  # 補班日
  def removed_weekends
    ["#{year}/2/20", "#{year}/9/11"]
  end
end

HolidayTasks.new
