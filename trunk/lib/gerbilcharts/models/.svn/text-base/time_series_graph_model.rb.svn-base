module GerbilCharts::Models

# = TimeSeriesGraphModel
# time series graph model (special case of monotonous)
# we expect discrete points, mainly the x_values are interpreted as timestamp
# therefore we can construct the appropriate preset axis labels.
#
# Eg. We can create round labels such as  8:15 instead of 8:16:47 
#
class TimeSeriesGraphModel < MonotonousGraphModel

  def initialize(name,opt={})
    super(name,opt)
    @rounderx=RoundTimeRange
    @roundery=RoundRange
  end

  # we add Timeval objects (those that respond to tv_sec)
  def add(timeobj, val)
  	super normalize_time_input(timeobj),val 
  end
  
  # crop older than the given timestamp
  def crop_older(cutofftime)
    	crop_at(normalize_time_input(cutofftime))
  end

  # just a check if we need time series
  def is_timeseries?
  	return true
  end

  # normalize input timestamp
  def normalize_time_input(tin)
	if tin.is_a? Time
		return tin
	elsif tin.is_a? Fixnum
		return Time.at(tin)
	elsif tin.is_a? Bignum
		if tin > 0xffffffff
			return Time.at(tin>>32)
		else
			return Time.at(tin)
		end
	end

  	return tin if tin.is_a? Time
  	return Time.at(tin)  if tin.is_a? Fixnum
  	return Time.at(tin>>32)  if tin.is_a? Bignum
	raise "Timeseries graph model expects Time,Bignum,Fixnum to represent time"
  end


  
end

end
