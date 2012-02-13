require 'timeout'
# TODO: extend this class to monitor several different tags and several sites
class Watcher::QuestionsWatcher
  def initialize qm, view, logger = nil
    @qm = qm
    @view = view
    @logger = logger
  end

  def check_tag(tag)
    timeout_count = 0
    begin
      questions = @qm.get_new_questions(tag).tap { |q| log_result(q, tag) }
      message = questions.inject('') { |sum, qst| sum + "\n" + View::QuestionsFormat.format_question('http://www.stackoverflow.com', qst) }
      try_send_msg_and_wait(message)
    rescue TimeoutError
      timeout_count += 1
      if timeout_count == 10
        try_send_msg_and_wait('Failed with TimeoutError')
        raise
      end
      retry
    rescue Exception => e
      try_send_msg_and_wait("#{e.class} - #{e.message}\n#{e.backtrace.join("\n")}")
      raise
    end
  end

  # Continuously watch tags
  def watch_tags tag
    loop do
      begin
        check_tag(tag)
      rescue Interrupt
        raise StopIteration
      end
    end
  end

  private

  def log_result(questions, tag)
    results_count = questions.size
    if @logger && results_count > 0
      @logger.info("Found %d results for '%s' tag" % [results_count, tag])
    end
  end

  def try_send_msg_and_wait msg
    # if I make the same query more often than once per minute then it is considered abusive on api level
    @view.send_msg_and_wait(msg, 61)
  end
end