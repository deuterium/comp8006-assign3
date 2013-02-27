#!/usr/bin/ruby
#
load "attempt.rb"

puts "This is a test ruby script: " + __FILE__

#Parse line for authentication
def parseLine(line)
	if line.include? "Failed password"
		puts line
		lineArray = line.split(pattern=" ")
		o = Attempt.new(lineArray[0], lineArray[1], lineArray[2], lineArray[10])
		puts o.ip
	end
end

#open file
begin
	file = File.new(ARGV[0], "r")
	while (line = file.gets)
		parseLine(line)
	end
	file.close
rescue => err
	puts "Exception: #{err}"
	puts "Proper invocation: ./monitor logToParse"
	err
end

