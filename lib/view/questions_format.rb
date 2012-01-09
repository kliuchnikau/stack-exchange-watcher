class View::QuestionsFormat
	def self.format_question(host, qst)
		tags = qst.tags.join(', ')
		creation_date = Time.at(qst.creation_date).strftime('%H:%M:%S')
		link = "#{host}/questions/#{qst.question_id}/"
		msg = "#{link} \"#{qst.title}\" [#{tags}] (#{creation_date})"
		msg
	end
end