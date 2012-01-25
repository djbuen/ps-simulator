require 'process'
require 'mod'

class RR
	include ProcessModule
	attr_accessor :time_quantum,:jobs,:timeline
	def initialize n=5, ts=5,at=true
		@ps = []
		@timeline = []
		@time_quantum = ts
		@n = n
		@att = @awt = 0
		get_processes
		if not at
		  (0..@list.length-1).each do |i|
				@list[i].at = 0
			end	
		end
		@jobs = _jobjob 
	end
	def dispatch
		process_list
			while not done_executing_process
				key = @list.shift
				@jobs.each do |k,v|
					if key.id == k && v["remaining_time"] != 0
						@ps << v["process"] 
						remaining_time = v["remaining_time"] - @time_quantum
						if remaining_time >= 0
							@time_quantum.times do |i|
								@timeline << k
							end
						else
							remaining_time = 0 
							v["remaining_time"].times do |i|
								@timeline << k
							end
						end
					update_hash k,v,remaining_time
					end
				end			
				@list.push key
			end
		compute_time
		compute_wt
	end

	private
		def compute_wt
			rt = @timeline.uniq
				@timeline.each_with_index do |v,i|
						(rt-[v]).each do |p|
							if i <= @jobs[p]["process"].te	
								@jobs[p]["process"].wt += 1
							end
						end		
				end
			rt.each do |pid|
				unless @jobs[pid]["process"].wt == 0
					@jobs[pid]["process"].wt -= 1 
				end
				@jobs[pid]["process"].wt -= @jobs[pid]["process"].at
			end
		end
end
