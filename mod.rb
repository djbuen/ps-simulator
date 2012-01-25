module ProcessModule
	attr_accessor :att,:awt,:ps,:n,:list,:newlist
	def _getProcesses
			@list = Array.new
			@n.times do |a|
				@list << Processs.new
				puts 'waiting process ' + @list[a].inspect
			end
	end
	def update_process at,i
		@ps[i].at = at
		unless i==0
			@ps[i].te = @ps[i].bt + @ps[i-1].te
			@ps[i].tt = @ps[i].te - @ps[i].at
			@ps[i].wt = @ps[i].tt - @ps[i].bt
		else
			@ps[i].tt = @ps[i].te = @ps[i].bt
		end
		@att += @ps[i].tt
		@awt += @ps[i].wt
	end
	def view
		@ps.each_with_index do |process,i|
			puts "#{i}:" + process.inspect
		end
		puts "average ATT:" + (@att/@n).to_s
		puts "average AWT:" + (@awt/@n).to_s
	end
	def get_processes
		_getProcesses
		@newlist = []
		until @newlist.length == @n
			at = rand(@n)
			exist = false 
			for ps in @list
				if ps.at == at
					exist = true
					break
				end
			end
			if(not exist)
				@list.each do |ps|
					if ps.at == nil
						ps.at = at
						@newlist << ps
						break
					end
				end	
			end
		end
		@list = @newlist
	end
	def sort_by_smallest_at
		@newlist = []	
		(0..n-1).each do |v|
			remaining_ps = @list - @newlist
			smallest_arrival_time = remaining_ps[0]
			(0..remaining_ps.length-1).each do |i|
				if smallest_arrival_time.at > remaining_ps[i].at
					smallest_arrival_time = remaining_ps[i]
				end
			end
			@newlist.push smallest_arrival_time
		end
		@list = @newlist
	end
	def _jobjob
		@jobs = Hash.new
		@list.each do |ps|
			@jobs[ps.id] = { "process" => ps , "remaining_time" => ps.bt }
		end	
		@jobs
	end
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
end
