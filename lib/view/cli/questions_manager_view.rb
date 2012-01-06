class View::Cli::QuestionsManagerView
  def initialize host = 'http://www.stackoverflow.com', output = STDOUT
    @host = host
    @output = output
  end

  def show_list questions
    return unless questions
    questions.each do |qst|
      tags = qst.tags.join(', ')
      creation_date = Time.at(qst.creation_date).strftime('%H:%M:%S')
      link = "#{@host}/questions/#{qst.question_id}/"
      @output.puts("#{link} \"#{qst.title}\" [#{tags}] (#{creation_date})")
    end
  end
end