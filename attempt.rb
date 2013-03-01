#Object used for collecting valuable information from parse log lines
class Attempt
	def initialize(month, day, time, ip)
	  @month	= month
	  @day		= day
	  @time		= time
	  @ip		= ip
	end
	def month
	  @month
	end
	def day
	  @day
	end
	def time
	  @time
	end
	def ip
	  @ip
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
	def to_time
        	hms = @time.split(pattern=":")
        	t = Time.new(Time.now.year, monthToDig(@month), @day.to_i, hms[0].to_i, hms[1].to_i, hms[2].to_i)
        	return t
	end
end

