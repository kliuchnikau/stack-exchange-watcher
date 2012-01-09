require 'blather'

class View::Xmpp::QuestionsManagerView
	def initialize daemon, client_id, host
		@daemon = daemon
		@client_id = client_id
		@host = host
	end

	def show_list questions
		return unless questions
		messages = []
		questions.each do |qst|
			messages << View::QuestionsFormat.format_question(@host, qst)
		end

		send_message(messages.join('\n'))
	end

	private

	def send_message(message)
		if @daemon.status == :ready
			@daemon.write Blather::Stanza::Message.new(@client_id, message)
		else
			@daemon.register_handler :ready do
				@daemon.write Blather::Stanza::Message.new(@client_id, message)
			end
		end
	end
end