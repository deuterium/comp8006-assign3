#!/usr/bin/ruby
#Comments and stuff
#
#
#
#
#User Configuration Section

#number of attempts in a 30 minute period of time before an IP is blocked
numAttempts = 3

#time to ban IP for
banTime = 60

#
#
#
#
#IMPLEMENTATION DO NOT MODIFY
load "attempt.rb"

puts "This is a test ruby script: " + __FILE__

$attempts = []

#Parse line for authentication
def parseLine(line)
	if line.include? "Failed password" and !line.include? "invalid user"
		lineArray = line.split(pattern=" ")
		$attempts.push(Attempt.new(lineArray[0], lineArray[1], lineArray[2], lineArray[10]))	
	elsif line.include? "Failed password" and line.include? "invalid user"
		lineArray = line.split(pattern=" ")
		$attempts.push(Attempt.new(lineArray[0], lineArray[1], lineArray[2], lineArray[12]))
	end
end

#write comments here !!!!!!!!!!!!!!!!!! :)
def checkAttempts()
	sameAttempts = []
	$attempts.each do |a|
		$attempts.each do |b|
			if a.ip.eql? b.ip
				sameAttempts.push(a)
				break
			end
		end
	end
	sameAttempts.each do |a|
		#compare times for stuff here, if close, new array? :)
		#new array length compared to numOfAttempts and then iptables rule
		puts a.to_time
		print a.ip + ": "
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
