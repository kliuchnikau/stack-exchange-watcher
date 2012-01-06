class OutputSpy
  def messages
	  @messages ||= []
  end

  def puts msg
	  messages << msg
  end
end

def output
  @output ||= OutputSpy.new
end