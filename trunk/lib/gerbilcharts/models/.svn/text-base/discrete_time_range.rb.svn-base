module GerbilCharts::Models

# =DiscreteTimeRange 
# The range is exactly as specified by individual values.
# The labels are simply those values formatted based on overall time window
#
class DiscreteTimeRange

  attr_reader :points		#discrete points
  
  def  initialize(points_arr=[])
  	@points=points_arr
  end
  
   # provide labels
   # 	Yields two items (value - seconds since Jan 1 1970, string label)
   def each_label
   		@points.each do |t|
			yield t, format_value(t)
		end
   end

  def rmax
	@points.first
  end
 
  def rmin
	@points.last
  end


  # provide ticks (per label interval)
  def each_tick(tpl)
    @points.each do  |t|
      yield t
    end
  end
  
  # format min value completely
  def format_min_value
  	  return format_value(@points.first) 
  end

  
  # scales a value with respect to the range
  def scale_factor(val)
  	df = val - @points.first
	rg = @points.last - @points.first
	return 0 if rg==0.0
	return df/rg
  end


  # format the discrete time value
  def format_value(val)
  	df = @points.last - @points.first 

  	if df  >  2*24*30 			# > 2months get monthly labels
		val.strftime("%b")
  	elsif df  > 1*24*30			# 1-2 months get days
		val.strftime("%b %d")
	elsif df > 1*24*7			# > 1 week get days
		val.strftime("%a")
	else
		val.to_s
	end
  end
  
  
end

end
