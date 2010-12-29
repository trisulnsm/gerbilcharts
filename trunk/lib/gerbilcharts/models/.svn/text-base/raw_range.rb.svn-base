module GerbilCharts::Models

# RawRange 
# 	Maintains a range when values are added to a model
# 	This tracks the raw min/max values 
class RawRange  < Presets
  
  attr_reader :rmax,:rmin
  
  def  initialize
    @rmax,@rmin=nil,nil
  end

  def invalid?
  	@rmin.nil?
  end
  
  # update - updates the range
  # 	newval - new incoming value
  #
  def update(newval)
	if not newval.nil?
	    @rmax=newval if @rmax.nil? or newval > @rmax 
	    @rmin=newval if @rmin.nil? or newval < @rmin 
	end 
  end
  
  # update - updates the range (using another range)
  # 	newval - new range
  #
  def update_r(range)
    update(range.rmax)
    update(range.rmin)
  end
  
  
  # returns the min/max 
  #
  def min_max
    yield @rmin,@rmax if block_given?
    return @rmin,@rmax
  end
  
  def reset
    @rmin,@rmax=nil,nil
  end
  
  def to_s
    "Min = #{@rmin} Max=#{@rmax}"
  end
  
  def delta
    return @rmax-@rmin
  end
  
  # scales a value with respect to the range
  # 	val = scale this value
  def scale_factor(val)
    f = (val-@rmin).to_f/(@rmax-@rmin).to_f
    return f
  end

  def zeromin
    @rmin=0
  end

  def format_value(val)
    return format_suffix(val)
  end
  
   # provide labels for raw range
   # 	assumes ticks = 5
   # 	yields two items (value,string label)
   #
   # 	Usage example:
   # 	r.each_label do |v,s|
   # 	  p "Value = #{v} Label String = #{s}"
   # 	end
   #
   def each_label(ticks=4)
     
    raise "No data points in model" if @rmax == -1  
    
	label_interval = (@rmax-@rmin)/ticks
    v = @rmin
    while (v<=@rmax) do
      yield v, format_suffix(v)    
      v = v+label_interval
    end
   end

  # provide ticks (per label interval)
  # for raw range simply divide the max and min into ticks
  def each_tick(ticks=4)
    
	  label_interval = (@rmax-@rmin)/ticks
      v = @rmin
      while (v<@rmax) do
        yield v
        v = v+label_interval
      end
  end
  
  
end

end
