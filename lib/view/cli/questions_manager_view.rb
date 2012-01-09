class View::Cli::QuestionsManagerView
  def initialize host = 'http://www.stackoverflow.com', output = STDOUT
    @host = host
    @output = output
  end

  def show_list questions
    return unless questions
    questions.each do |qst|
			@output.puts(View::QuestionsFormat.format_question(@host, qst))
    end
  end
end