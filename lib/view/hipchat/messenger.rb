require 'hipchat'

class View::Hipchat::Messenger
  def initialize token_id, room_id, from_who = 'SE Watcher'
    @token_id, @room_id, @from_who = token_id, room_id, from_who
  end

  def send_msg(message)
    if message.empty?
      logger.info("No new messages for hipchat")
      return
    end

    hipchat_client[@room_id].send(@from_who, message, notify: true, message_format: 'text')
    logger.info("Sent to hipchat: #{message}")
  end

  def send_msg_and_wait(message, sec)
    send_msg(message)
    sleep sec
  end

  attr_writer :logger

  private

  def logger
    @logger ||= begin
                  require 'logger'
                  Logger.new('/dev/null')
                end
  end

  def hipchat_client
    @hipchat_client ||= HipChat::Client.new(@token_id)
  end
end
