require 'process'
require 'mod'

class SRT
	include ProcessModule
	attr_accessor :time,:times,:timeline,:jobs
	def initialize n=5
		@times = []
		@timeline = []
		@n = n
		get_processes
		@jobs = _jobjob
	end
	def dispatch
		process_list
		current_job = @list[0] 
		@time = 1 
		while not done_executing_process
			while turnof current_job 
				@jobs[current_job.id]["remaining_time"] -= 1
				@timeline << current_job.id
				@time += 1
				puts "inner" + @time.to_s
			end
			puts "outer"
			current_job = get_next_job	
			puts current_job.inspect
		end	
	end

	private
	def turnof current_job
		if @time == 1
			return true
		end
	 	@jobs.each do |k,v|
			#check if there are jobs that has shorter remaining time or check if current jobs is not yet done
			if ((@jobs[current_job.id]["remaining_time"] > v["remaining_time"]) && v["remaining_time"]!=0) || @jobs[current_job.id]["remaining_time"] == 0
				return false
			end
		end 	
	  return true	
	end
	def get_next_job
		current_job = nil
		@min_left = nil 
		@times = []
		@jobs.each do |k,v|
			@times << v["remaining_time"]
		end	
		@times.delete 0
		current_job = find_jobjob
		unless current_job
			current_job = find_jobjob
		end
		current_job
	end
	def find_jobjob
		current_job = nil
		@jobs.each do |k,v|
			if v["remaining_time"] == @times.min
		#		if @jobs[k]["process"].at <= @time
					 current_job = @jobs[k]["process"] 
		#			 break
			#	elsif @times.count @times.min > 1
			#		 unless @min_left
			#		 	@min_left = @times.count @times.min
			#		 end
			#	   if @min_left == 0 
			#	   	@times.delete @times.min 
			#	   end
			#	@min_left -= 1
		#		end
			end
		end	
		current_job
	end
end
