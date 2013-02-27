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
	if line.include? "Failed password"
		lineArray = line.split(pattern=" ")
		$attempts.push(Attempt.new(lineArray[0], lineArray[1], lineArray[2], lineArray[10]))
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
	end
end

#Converts shorthand month strings to numerical numbers
def monthToDig(month)
	case month
	when "Jan"
		return 1
	when "Feb"
		return 2
	when "Mar"
		return 3
	when "Apr"
		return 4
	end
	#etc.....
end

#Returns a time object constructed from an attempt object's local variables
def toTime(a)
	hms = a.time.split(pattern=":")
	time = Time.new(Time.now.year, monthToDig(a.month), a.day.to_i, hms[0].to_i, hms[1].to_i, hms[2].to_i)
	return time
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
