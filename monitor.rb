#!/usr/bin/ruby
#Comments and stuff
#
#
#
#
#User Configuration Section

#number of attempts in a 30 minute period of time before an IP is blocked
numAttempts = 3

#time to ban IP for in minutes
@banTime = 60

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
	
	@banTime = @banTime * 60
	banStack = []

	sameAttempts.each do |a|
		banStack.push(a)
puts a.ip
		if banStack.length == 3
			t = banStack[2].to_time - banStack[0].to_time
puts t	
			if t <= @banTime
				puts "banned"
				puts a.ip
			end
			banStack.shift
		end
				

#compare times for stuff here, if close, new array? :)
		#new array length compared to numOfAttempts and then iptables rule
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
