module StackExchange
  class QuestionsManager
    def initialize requestor
      @requestor = requestor
      @tag_checks = {}
    end

    def get_new_questions tag
			request_unixtime = current_time
			query_params = prepare_query_params(tag, request_unixtime)

      result_page = @requestor.questions.fetch(query_params)
      set_last_tag_check(tag, request_unixtime)

      result_page.questions
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

    def prepare_query_params(tag, request_time)
      last_tag_check = get_last_tag_check tag
      query_params = {:pagesize => 30, :page => 1, :sort => 'creation', :tagged => tag}
      query_params[:fromdate] = last_tag_check if last_tag_check
			query_params[:todate] = request_time
      query_params
    end
  end
end