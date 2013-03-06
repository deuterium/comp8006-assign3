#!/usr/bin/ruby
#Chris Wood - A00741285 - COMP8006 - Assignment 3
#Monitor script to detect failed SSH authentication attempts and,
#if nessecary, block the IP address using Netfilter

############################
#User Configuration Section#     
############################

#number of attempts before an IP is banned in a time range(below) 
$numAttempts = 3

#time to ban IP for in minutes
$banTime = 15

#range of time to ban attempts from
#(period of time for numOfAttempts to apply)
$banRange = 60

##
##
##############################
##############################
#IMPLEMENTATION DO NOT MODIFY#
##############################
load "attempt.rb"

$attempts = []

#Parse line for authentication failures, attempts are turned in to objects
def parseLine(line)
	if line.include? "Failed password" and !line.include? "invalid user"
		lineArray = line.split(pattern=" ")
		$attempts.push(Attempt.new(lineArray[0], lineArray[1], lineArray[2], lineArray[10]))	
	#noticed someone was brute forcing my ssh while I left it on overnight, noticed having
	#an invalid user changed the wording in /var/log/secure and had to change to this logic
	elsif line.include? "Failed password" and line.include? "invalid user"
		lineArray = line.split(pattern=" ")
		$attempts.push(Attempt.new(lineArray[0], lineArray[1], lineArray[2], lineArray[12]))
	end
end

#Basically all the magic happens here, other than loading the file and parsing log
def checkAttempts()
	sameAttempts = []
	
	#look to simillar IPs.....
	$attempts.each do |a|
		$attempts.each do |b|
			if a.ip.eql? b.ip
				#record if the same
				sameAttempts.push(a)
				break
			end
		end
	end
	
	$banRange = $banRange * 60
	banStack = []

	#of attempts with same IP, compare sequential attempts
	sameAttempts.each do |a|
#PROBLEM: if ip switches, banstack is cleared.....better than false bans?
#resolution.....use a hash based on IP?
		if banStack.empty?
			banStack.push(a)
		elsif banStack[banStack.length - 1].ip != a.ip
			banStack.clear
			banStack.push(a)
		else
			banStack.push(a)
		end
		if banStack.length == $numAttempts
			t = banStack[2].to_time - banStack[0].to_time
			#if time difference is in user defined period, ban
			if t <= $banRange
				#system "iptables -A INPUT -s #{a.ip} -j DROP"
				puts "banned: " + a.ip
				banme = a.ip + " " + Time.now.to_i.to_s
				system "echo '#{banme}' >> ban_log"
			end
			banStack.shift
		end
	end
end

def removeLogLine(line)
	line_arr = File.readlines("ban_log")
	line_arr.delete_at(line_arr.index{ |n| n.include? line })
puts line_arr.to_s
	File.open("ban_log", "w") do |f|
		line_arr.each{ |l| f.puts(l) }
	end
end

def unban(ip)

end

def checkLog
	puts "Checking log."
	begin
		file = File.new("ban_log", "r")
		while (line = file.gets)
			line = line.split(pattern=" ")
			t = Time.now.to_i - line[1].to_i 
			if t > ($banTime * 60)    #think shit is broken here
				unban(line[0])
				puts "ip unbanned: " + line[0]
				line = line[0] + " " + line[1]
				removeLogLine(line)
			end
		end
		file.close
	rescue => err
		puts "Exception: #{err}"
		puts "does a log file exist?"
		err
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

#run magic
checkAttempts
checkLog
