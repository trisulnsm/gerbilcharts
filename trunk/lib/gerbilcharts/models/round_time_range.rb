module GerbilCharts::Models

MINUTE=60
HOUR=3600
DAY=86400

# 
# rounded time range - Rounds the max to a nice preset
#  This class allows for labels at clean intervals instead of
#  "Jan 17 2008 11:27:92"
#
class RoundTimeRange < RawRange
 
  attr_reader  :ldelta		# label delta seconds   (eg label every = 2 hrs)
  attr_reader  :rdelta		# range delta seconds 	(eg chart span = 6 hrs)

  # given a raw range, we calculate a round range
  def initialize(raw_range)
    super()
    @rdelta,@ldelta=round_delta(raw_range.delta)
    @rmin=raw_range.rmin

	# this can be rdelta or ldelta for wider or tighter
    #@rmax=round_max(raw_range.rmax,@rdelta)
    @rmax=round_max(raw_range.rmax,@ldelta)
  end
 
   # provide labels
   # 	Yields two items (value - seconds since Jan 1 1970, string label)
   def each_label
     
    raise "Range not aligned with presets (call round range first)" if not @ldelta
    
    return if @ldelta == 0

	v = get_label_start_time

    while (v<=@rmax) do
      yield v, format_timeval(v,@rdelta)    
      v = v+@ldelta
    end
   end

  # provide ticks (per label interval)
  # note the tpl is not used !
  def each_tick(tpl)
    raise "Range not aligned with presets (call round range first)" if not @ldelta
    
    return if @ldelta == 0

	subtick_delta = ideal_subtick_interval(@ldelta)
      
	v = get_label_start_time

    while (v<=@rmax) do
      yield v    
      v = v+subtick_delta
    end

  end
  
  # format min value completely
  def format_min_value
      t = Time.at(@rmin).getlocal
      return t.to_s
  end
  
private
  # round_max (ceiling)
  def round_max(raw, interval)
    return raw if interval == 0 
    ni_secs = (raw.tv_sec+interval)/interval
    return Time.at(interval * ni_secs.to_i)
  end
     
  # round_min (floor)
  def round_min(raw, interval)
    ni_secs = (raw.tv_sec-interval)/interval
    return Time.at(interval * ni_secs.to_i )
  end
  
  # rounded delta time 
  def round_delta(raw_delta)
    
    last_pre=1
    last_lab=1
    if raw_delta > TIMEPRESETS.last[0]
      return raw_delta,raw_delta/10
    else
      TIMEPRESETS.reverse_each do |pre|
        break if pre[0] < raw_delta
        last_pre=pre[0]
        last_lab=pre[1]
      end
    end
    return last_pre,last_lab
  end

  # ideal subticks
  #  You dont want to do a fixed subdivision of a time interval will be ugly
  #  Eg. 10x of 2 hours will be 12 min ticks = FAIL
  def ideal_subtick_interval(label_interval)

	case label_interval
		when (0..1*MINUTE); return 10
		when (1*MINUTE..5*MINUTE); return 1*MINUTE
		when (5*MINUTE..15*MINUTE); return 3*MINUTE
		when (15*MINUTE..1*HOUR); return 5*MINUTE
		when (1*HOUR..2*HOUR); return 15*MINUTE
		when (2*HOUR..6*HOUR); return 30*MINUTE
		when (6*HOUR..12*HOUR); return 1*HOUR
		when (12*HOUR..1*DAY); return 3*HOUR
		else; return 1*DAY
	end
  end

  def get_label_start_time
	# if labeling hours, make sure you account tz weirdness like india GMT +5:30
	if @ldelta >= 86400
	  	 v = Time.mktime(@rmin.year, @rmin.month, @rmin.day+1,
		                 0,0,0,0)
	elsif 
		 tbase = Time.mktime(@rmin.year, @rmin.month, @rmin.day,0,0,0,0)
		 sec_inc = @rmin.tv_sec - tbase.tv_sec
		 v = Time.at( tbase.tv_sec + @ldelta*(sec_inc/@ldelta).ceil)
	end
	return v
  end
end

end
