require 'time'
require 'slack'
require 'clockwork'
require 'yaml'

include Clockwork

config_file = YAML.load_file('config.yml')
LOG_FILE="log/next_group"

Slack.configure do |config|
  config.token = config_file['slack']['token'] || ENV['SLACK_TOKEN']
  if config.token == ''
    STDERR.puts "TOKEN is blank...\n"
    exit(1)
  end
end

def post_slack_messeage(subject, config_file)
  # post slack messeage

  Slack.chat_postMessage(
    channel: config_file['slack']['channel'] || ENV['SLACK_CHANNEL'],
    username: 'bot',
    text: subject,
    icon_url: 'http://2.bp.blogspot.com/-c1dEoxGvncY/UYzZhH-nugI/AAAAAAAAR7c/GJ1mk-SovxU/s400/oosouji_soujiki.png'
  )
end

def get_current_num()
  # get current number from file

  File::open(LOG_FILE, "r") {|f|
    num = f.gets
    return num.to_i
  }
end

def write_count(num)
  # write current num

  File::open(LOG_FILE, "w") {|f|
    f.print(num)
    return nil
  }
end

handler do |job|
  case job
  when 'lab-cleaner-day.job'
    begin
      today = Time.now
      num_group = [1, 2, 3, 4]

      if today.strftime('%w') == '5'
        # if today Friday
        count = get_current_num
        subject = today.strftime('%x') + "\nToday is Friday!\n" + "Today cleaner group is " + num_group[count].to_s

        post_slack_messeage(subject, config_file)

        if count == num_group.length
          count = 1
          write_count(count)
        else
          count += 1
          write_count(count)
        end

      else
        # if today not Friday
        # do nothing
      end
    rescue => e
      post_slack_messeage(e, config_file)
    end
  end
end

every(1.day, 'lab-cleaner-day.job', :at => '18:00')
# every(10.seconds, 'lab-cleaner-day.job')
