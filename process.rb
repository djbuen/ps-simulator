class Processs
 attr_accessor :id,:at,:bt,:tt,:wt,:te
 def initialize
    @id = rand(1000)
    @bt = rand(20)
    @tt = @wt = @te = 0
    @at = nil
 end
end


