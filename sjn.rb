require 'process'
require 'mod'

class SJN
	include ProcessModule
	
	def initialize n=5 
		@ps = Array.new
		@n = n
		_getProcesses
		@att = @awt = 0
	end
	def execute
		at = 0
		(0..@n-1).each do |i|
			min = find_shortest_cpu_burst 
	 		@ps.push min
			update_process at,i
			at += 1
		end
	end
private
	def find_shortest_cpu_burst 
  	remaining_ps = @list-@ps
  	min = remaining_ps[0]
		(1..remaining_ps.length-1).each do |i|
   		if min.bt > remaining_ps[i].bt
    		min = remaining_ps[i]
   		end
  	end
		min
	end
end


