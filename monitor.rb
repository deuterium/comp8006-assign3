#!/usr/bin/ruby
#
load "attempt.rb"

puts "This is a test ruby script: " + __FILE__

$attempts = []

#Parse line for authentication
def parseLine(line)
	if line.include? "Failed password"
		lineArray = line.split(pattern=" ")
		$attempts.push(Attempt.new(lineArray[0], lineArray[1], lineArray[2], lineArray[10]))
	end
end

def checkAttempts()
	sameAttempts = []
	$attempts.each do |a|
		$attempts.each do |b|
			if a.ip.eql? b.ip
				sameAttempts.push(b)
			end
		end
	end
	sameAttempts.each do |a|
		puts a.time
	end
end

##BEGIN LOGIC
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

checkAttempts
