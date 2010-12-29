module GerbilCharts::Models

# A rounded range from a raw range 
# Example : RawRange (102,8991) = RoundRange (100,10K)
#
class RoundRange < RawRange
 
  attr_reader  :lmax
  
  # given a raw range, we calculate a round range
  def initialize(raw_range)
    super()
    @rmin=round_min(raw_range.rmin) if not raw_range.rmin.nil?
    @rmax=round_max(raw_range.rmax) if not raw_range.rmax.nil?
    @lmax=label_step  if not raw_range.rmax.nil?
  end
 
   # provide labels
   # 	yields two items (value,string label)
   #
   # 	Usage example:
   # 	r.each_label do |v,s|
   # 	  p "Value = #{v} Label String = #{s}"
   # 	end
   #
   def each_label

	return if not @lmax
     
    raise "Range not aligned with presets (call round range first)" if not @lmax
    raise "No data points in model" if @rmax == -1  
    return  if @lmax == 0
    
    if @rmin % @lmax != 0
      v = (@rmin+@lmax) - (@rmin%@lmax)
    else
      v = @rmin
    end
    while (v<=@rmax) do
      yield v, format_suffix(v)    
      v = v+@lmax
    end
   end

  # provide ticks (per label interval)
  def each_tick(tpl)
    
      return  "Range not aligned with presets (call round range first)" if not @lmax  

      return if @lmax==0
	  return if tpl==0
      
      lint = @lmax/tpl
	  return if lint==0
      if @rmin % lint != 0
        v = (@rmin+lint) - (@rmin%lint)
      else
        v = @rmin
      end
      while (v<@rmax) do
        yield v
        v = v+lint
      end
  end
  
private
  # round_max (ceiling)
  def round_max(raw)
       last_pre=1
       if raw.abs  > PRESETS.last[0]
          return raw
       else
         PRESETS.reverse_each do |pre|
		 	if raw >= 0
					break if pre[0] < raw.abs
					last_pre=pre[0]
			else
					last_pre=-pre[0]
					break if pre[0] < raw.abs
			end
         end
       end
       return last_pre
  end
  
  # round_min (floor)
  def round_min(raw)
     last_pre=0
     PRESETS.each do |pre|
	 	if raw >=0 
			break if pre[0]  > raw
			last_pre=pre[0]
		else
			last_pre=-pre[0]
			break if pre[0]  > raw.abs
		end
     end
     return last_pre
   end

  # labels
  def label_step
    del = @rmax-@rmin
    
    last_pre=0.2
    if del > PRESETS.last[0]
          return del/10
    else
         PRESETS.reverse_each do |pre|
            break if pre[0] < del
            last_pre=pre[1]
         end
    end
   return last_pre
  end

end

end

