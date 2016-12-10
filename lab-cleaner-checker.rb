require 'time'
require 'slack'
require 'clockwork'
require 'yaml'

include Clockwork

config_file = YAML.load_file('config.yml')
count = config_file['start_num']

handler do |job|
  case job
  when 'lab-cleaner-day.job'
    Slack.configure do |config|
      config.token = config_file['slack']['token']
      if config.token == "" then
        p "TOKEN is blank...\n"
        exit(1)
      end
    end
   
    today = Time.now
    num_group = [1,2,3,4]
    
    if today.strftime('%w') == "5" then
      # if today Friday
      subject = today.strftime('%x') + "\nToday is Friday!\n" + "Today cleaner group is " + num_group[count].to_s
  
      Slack.chat_postMessage(
        channel: '#cleaner-logger',
        username: 'bot',
        text: subject
      )

      if count == 3 
        count = 0
      else
        count += 1
      end

    else
      # if today not Friday
      subject = today.strftime('%x') + "\nToday is not Friday...\n"

      Slack.chat_postMessage(
        channel: '#cleaner-logger',
        username: 'bot',
        text: subject
      )
    end
  end
end

every(1.day, 'lab-cleaner-day.job' , :at => '18:00')
