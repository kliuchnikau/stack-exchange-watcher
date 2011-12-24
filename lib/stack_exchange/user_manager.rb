module StackExchange
  class UserManager
    PAGE_SIZE = 100

    def initialize se_api_client
      @api = se_api_client
    end

    def all_users min_reputation = 0
      filter = {}

      page = 1
      filter[:min] = min_reputation if min_reputation > 0
      users = get_users(page, filter)

      result = users.users
      total_users = users.total
      while result.count < total_users
        raise 'jumped over total users count' if page > (total_users / PAGE_SIZE)+1
        page += 1
        result += get_users(page, filter).users
      end
      result
    end

    def find_from_country country, reputation = 0
      all_users(reputation).select {|u| u.location =~ /#{country}/i }
    end

    private

    def get_users(page, filter)
      @api.users.fetch({:pagesize => PAGE_SIZE, :page => page}.merge(filter) )
    end
  end
end