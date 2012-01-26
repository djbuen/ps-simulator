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
		@current_job = @list[0] 
		@time = 1 
		puts "time:" + @time.to_s
		puts @current_job.inspect
		while not done_executing_process
			unless @jobs[@current_job.id]["remaining_time"] == 0
				@jobs[@current_job.id]["remaining_time"] -= 1
				@timeline << @current_job.id
			end
			@time += 1
			puts "time:" + @time.to_s
			get_next_job	
			puts @current_job.inspect
		end	
		compute_time
		compute_wt
	end

	private
	def get_next_job
		@min_left = nil 
		@times = []
		@jobs.each do |k,v|
			if v["process"].at <= @time
				@times << v["remaining_time"]
			end
		end	
		@times.delete 0
		find_jobjob
	end
	def find_jobjob
		@jobs.each do |k,v|
			if v["remaining_time"] == @times.min
					 @current_job = @jobs[k]["process"] 
			end
		end	
	end
end
