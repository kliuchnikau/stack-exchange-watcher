require 'blather/client/client'
require 'blather/client/dsl'

class View::Xmpp::QuestionsManagerView
  include Blather::DSL

  def initialize client_id, daemon_id, daemon_pass
    @client_id = client_id
    @daemon_id = daemon_id
    @daemon_pass = daemon_pass
  end

  def send_msg_and_do(message, &work)
    begin
      pid = send_msg_in_fork(@client_id, message) if message.length > 0
      yield
    ensure
      if pid
        Process.kill("HUP", pid)
        Process.wait
      end
    end
  end

  private

  def handle_blather_connection_failure message
    attempts = 0
    begin
      yield
    rescue Blather::Stream::ConnectionFailed
      attempts += 1
      if attempts < 5
        sleep(5)
        retry
      else
        shutdown rescue nil
        abort("XMPP CONNECTION FAILED: Cannot deliver message #{message}")
      end
    end
  end

  def send_msg_in_fork(client_id, message)
    pid = fork do
      handle_blather_connection_failure(message) do
        setup @daemon_id, @daemon_pass

        when_ready do
          handle_blather_connection_failure(message) do
            say client_id, message
            shutdown
          end
        end

        EM.run { client.run }
      end
      Signal.trap("HUP") { exit }
    end
    pid
  end
end