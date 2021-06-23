
SLACKBOMBZONE_WEBHOOK_URL = "https://hooks.slack.com/services/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".freeze
WEST_WORLD = "#west_world"

SLACK_COLOR = OpenStruct.new(
  success: "#2eb886",         # green
  unknow: "#FFC922",          # yellow
  warn: "#fd9413",            # orange
  alert: "#FD3232",           # red
  gray_alert: "#AAAAAA"       # gray
).freeze

SLACK_EMOJI = OpenStruct.new(
  success: ":white_check_mark:",
  unknow: ":interrobang:",
  warn: ":warning:",
  alert: ":bangbang:",
  gray_alert: ":grey_exclamation:"
).freeze

# 檢視此 API 取得對應 ID
# API https://api.slack.com/methods/usergroups.list/test
SLACK_TEAM = OpenStruct.new(
  cs: "S01S6ACKK6V",
  pm: "S020NFBR4AX",
  qa: "SKJUYPVNC",
  tpm: "S01SHF6TQBA",
  rails_team: "S01RCTJ7T7Z",
  account_team: "S01RLU89H9C"
).freeze
