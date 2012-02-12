# TODO: write tests and extend this class to monitor several different tags and several sites
class Watcher::QuestionsWatcher
  def initialize requestor, view, logger = nil
    @qm = StackExchange::QuestionsManager.new(requestor, logger)
    @view = view
    @logger = logger
  end

  def watch_tags
    timeout_count = 0
    loop do
      begin
        tag = 'ruby'
        questions = @qm.get_new_questions(tag).tap { |q| log_result(q, tag) }
        message = questions.inject('') { |sum, qst| sum + "\n" + View::QuestionsFormat.format_question('http://www.stackoverflow.com', qst) }
        try_send_msg_and_wait(message)
      rescue TimeoutError
        timeout_count += 1
        if timeout_count == 10
          try_send_msg_and_wait('Failed with TimeoutError')
          raise
        end
      rescue Interrupt
        raise StopIteration
      rescue Exception => e
        try_send_msg_and_wait("#{e.class} - #{e.message}\n#{e.backtrace.join("\n")}")
        raise
      end
    end
  end

  def log_result(questions, tag)
    results_count = questions.size
    if @logger && results_count > 0
      @logger.info("Found %d results for '%s' tag" % [results_count, tag])
    end
  end

  private

  def try_send_msg_and_wait msg
    # if I make the same query more often than once per minute then it is considered abusive on api level
    @view.send_msg_and_do(msg) { sleep(61) }
  end
end