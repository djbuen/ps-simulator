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
		@jobs = Hash.new
		@list.each do |ps|
			@jobs[ps.id] = { "process" => ps , "remaining_time" => ps.bt }
		end	
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
		def process_list
			sort_by_smallest_at
		end
		def update_hash k,v,remaining_time
			@jobs[k] = { "process" => v["process"], "remaining_time" => remaining_time }
		end
		
		def done_executing_process
			count = 0
			@jobs.each do |key,val|
					if val["remaining_time"] != 0
						count +=1
						break
					end
			end
			return (count == 1)?false:true
		end
		def compute_time
			rt = @timeline.reverse.uniq
			rtime = @timeline.reverse
			te = 0
			p = rt.shift
			until p == nil 
				te = @timeline.length-1
				(0..(@timeline.length)-1).each do |i|
					if p == rtime[i] 
					 	@jobs[p]["process"].te = te
						@jobs[p]["process"].tt = te - @jobs[p]["process"].at
						p = rt.shift
						break
					end
				te -= 1
				end
			end
		end
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
