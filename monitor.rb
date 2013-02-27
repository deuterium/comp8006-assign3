#!/usr/bin/ruby
#
puts "This is a test ruby script: " + __FILE__

#open file
begin
	file = File.new(ARGV[0], "r")
	while (line = file.gets)
		puts line
	end
	file.close
rescue => err
	puts "Exception: #{err}"
	puts "Proper invocation: ./monitor logToParse"
	err
end

