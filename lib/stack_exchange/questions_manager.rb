module StackExchange
  class QuestionsManager
    def initialize requestor, logger = nil
      @requestor = requestor
      @tag_checks = {}
      @logger = logger
    end

    def get_new_questions tag
      request_unixtime = current_time
      query_params = prepare_query_params(tag, request_unixtime)

      result_page = fetch_result(query_params)
      set_last_tag_check(tag, request_unixtime)

      result_page.items
    end

    def set_last_tag_check tag, unixtime
      @tag_checks[tag] = unixtime
    end

    def get_last_tag_check tag
      @tag_checks[tag]
    end

    private

    def current_time
      Time.now.to_i
    end

    def fetch_result(query_params)
      @requestor.questions.fetch(query_params)
    end

    def formatted_date unixtime
      unixtime ? Time.at(unixtime).strftime('%H:%M:%S') : '"Any"'
    end

    def prepare_query_params(tag, request_time)
      last_tag_check = get_last_tag_check tag
      query_params = {:pagesize => 30, :page => 1, :sort => 'creation', :tagged => tag}
      query_params[:fromdate] = last_tag_check if last_tag_check
      query_params[:todate] = request_time
      query_params[:site] = 'stackoverflow'

      if @logger
        @logger.info("Querying for '%s' questions for period %s - %s" %
                     [tag,
                      formatted_date(last_tag_check),
                      formatted_date(request_time)])
      end

      query_params
    end
  end
end
