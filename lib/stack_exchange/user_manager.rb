module StackExchange
  class UserManager
    def initialize se_api_client
      @api = se_api_client
    end

    def all_users
      result = []
      page = 1
      users = get_users(page)

      result += users.users
      total_users = users.total
      while result.count < total_users
        page += 1
        result += get_users(page).users
      end
      result
    end

    def find_from_country country, reputation = 0
      all_users.select {|u| u.location =~ /#{country}/i }
    end

    private

    def get_users(page)
      @api.users.fetch({:pagesize => 100, :page => page})
    end
  end
end