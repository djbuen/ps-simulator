require 'sjn'
require 'thread'
require 'mod'
class FCFS 
	include ProcessModule
	attr_accessor :queue
	def initialize n=5
		@queue_list = @ps = []
		@n = n
		@queue = Queue.new
		@att = @awt = 0
		get_processes
	end
	def dispatch
		i = at = 0
		process_queue	
		until @queue.length == 0 
			@ps << @queue.pop
			update_process at,i
			i = (at += 1)
		end	
	end
	def process_queue
		(0..n-1).each do |v|
			remaining_ps = @list - @queue_list
			smallest_arrival_time = remaining_ps[0]
			(0..remaining_ps.length-1).each do |i|
				if smallest_arrival_time.at > remaining_ps[i].at
					smallest_arrival_time = remaining_ps[i]
				end
			end
			@queue_list.push smallest_arrival_time
			@queue.push smallest_arrival_time
		end	
	end
end
