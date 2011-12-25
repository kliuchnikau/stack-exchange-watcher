class View::Cli::UserManagerView
  def initialize host = 'http://stackoverflow.com', output = STDOUT
    @output = output
    @host = host
  end

  def show_list users
    if users.nil? or users.empty?
      return @output.puts "No results found"
    end
    @output.puts "Found #{users.count} users"

    users.each do |user|
      @output.puts "Id: #{user.user_id}, Name: #{user.display_name}, Reputation: #{user.reputation}, Link: #{@host}/users/#{user.user_id}/"
    end
  end
end