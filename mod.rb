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
end
