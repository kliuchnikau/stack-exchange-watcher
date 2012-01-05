module StackExchange
  class Questions
    def initialize requestor
      @requestor = requestor
      @tag_checks = {}
    end

    def get_new_questions tag

    end

    def set_last_tag_check tag, unixtime
      @tag_checks[tag] = unixtime
    end

    def get_last_tag_check tag
      @tag_checks[tag]
    end
  end
end