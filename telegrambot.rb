require 'telegram/bot'

class TelegramBot
  attr_reader :my_bot, :user_chat_id, :user_first_name, :user_last_name

  def initialize(token)
    @my_bot = Telegram::Bot::Client.new(token)
    @user_chat_id ||= ''
    start_listen
  end

  def send_message(text)
    my_bot.api.send_message(chat_id: user_chat_id, text: text)
  end

  def take_user_data(rqst)
    @user_chat_id = rqst.chat.id
    @user_first_name = rqst.from.first_name
    @user_last_name = rqst.from.last_name
  end

  def start_listen
    loop do
      begin
        my_bot.run do |bot|
          bot.listen do |rqst|
            Thread.start(rqst) do |rqst|
              begin
                case rqst.text
                when '/start'
                  take_user_data(rqst)
                  send_message("Hello #{user_first_name}")
                when '/stop'
                  send_message("Bye, #{user_first_name}")
                end
              rescue StandardError
                # <RESCUE, можно сделать лог в файл типа "RESCUE PRCSNG">
              end
            end
          end
        end
      rescue StandardError
        # <RESCUE, можно сделать лог в файл типа "RESCUE API">
      end
    end
  end
end
