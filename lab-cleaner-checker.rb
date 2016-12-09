require 'time'
require 'slack'
require 'clockwork'

include Clockwork

count = 0

handler do |job|
  case job
  when "lab-cleaner-day.job"
    Slack.configure do |config|
      config.token = ENV["TOKEN"]
      if ENV["TOKEN"] == "" then
        p "TOKEN is blank...\n"
        exit(1)
      end
    end
   
    # 今日の日付を取得
    today = Time.now

    # 班番号
    num_group = [1,2,3,4]
    
    if today.strftime("%w") == "5" then
      # if today Friday
      subject = today.strftime("%x") + "\nToday is Friday!\n" + "Today cleaner group is " + num_group[count].to_s
  
      # slackへ投稿
      Slack.chat_postMessage(
        channel: '#cleaner-logger',
        username: 'bot',
        text: subject
      )

      if count == 3 then
        count = 0
      elsif
        count++
      end

    end
  end
end

every(30.seconds, 'lab-cleaner-day.job')
