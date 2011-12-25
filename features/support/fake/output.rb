class Output
  def messages
	  @messages ||= []
  end

  def puts msg
	  messages << msg
  end
end

def output
  @output ||= Output.new
end