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
end

