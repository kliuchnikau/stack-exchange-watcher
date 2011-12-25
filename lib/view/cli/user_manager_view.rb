class View::Cli::UserManagerView
  def initialize output
    @output = output
  end

  def show_list users
    if users.nil? or users.empty?
      return @output.puts "No results found"
    end
    @output.puts "Found #{users.count} users"
  end
end