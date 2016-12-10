require 'time'
require 'slack'
require 'clockwork'
require 'yaml'

include Clockwork

config_file = YAML.load_file('config.yml')
count = config_file['start_num']
Slack.configure do |config|
  config.token = config_file['slack']['token']
  if config.token == ''
    STDERR.puts "TOKEN is blank...\n"
    exit(1)
  end
end

def post_slack_messeage(subject)
  # post slack messeage

  Slack.chat_postMessage(
    channel: '#cleaner-logger',
    username: 'bot',
    text: subject,
    icon_url: 'http://2.bp.blogspot.com/-c1dEoxGvncY/UYzZhH-nugI/AAAAAAAAR7c/GJ1mk-SovxU/s400/oosouji_soujiki.png'
  )
end

handler do |job|
  case job
  when 'lab-cleaner-day.job'

    today = Time.now
    num_group = [1, 2, 3, 4]

    if today.strftime('%w') == '5'
      # if today Friday
      subject = today.strftime('%x') + "\nToday is Friday!\n" + "Today cleaner group is " + num_group[count].to_s

      post_slack_messeage(subject)

      if count == 3
        count = 0
      else
        count += 1
      end

    else
      # if today not Friday
      subject = today.strftime('%x') + "\nToday is not Friday...\n"

      post_slack_messeage(subject)
    end
  end
end

every(1.day, 'lab-cleaner-day.job', :at => '18:00')
# every(10.seconds, 'lab-cleaner-day.job')
