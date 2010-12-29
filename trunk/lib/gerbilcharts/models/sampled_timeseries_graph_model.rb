module GerbilCharts::Models


# = SampledTimeSeriesGraphModel
# Time series graph model with sample polling interval
# we expect discrete points at approx regular intervals
# a missing interval implies zero value !
#
# This class is mainly used for its sweep methods.
# TODO: Example here
#
class SampledTimeSeriesGraphModel < TimeSeriesGraphModel

  attr_reader :bucketsize		# sample interval (polling interval)

  def initialize(name,bucketsize,opt={})
    super(name,opt)
    raise "Sampled time series model : required param bucketsize missing" unless opt[:bucketsize]
    @bucketsize = opt[:bucketsize] 
  end
  
  def sweep_interval
      return @bucketsize
  end
  
  # begin a sweep session
  def begin_sweep
      @last_sweep_pos=0
  end

  # sweep this bucket
  def sweep2(tval)
    
    return 0 if @xarr.length == 0
    return 0 if @last_sweep_pos >= @xarr.length
    
    p "Sweep at tval = #{tval}"
    
    xv=@xarr[@last_sweep_pos]
    if bucket_diff(tval,xv) < 1
        @last_sweep_pos+=1
        return @yarr[@last_sweep_pos-1]
    else 
        return 0
    end    
  end
  
  # sweep this bucket
  def sweep(tval)

    return 0 if @xarr.length == 0
    return 0 if @last_sweep_pos >= @xarr.length
    
    
    xv=@xarr[@last_sweep_pos]
    
    if tval < xv
        return 0
    end
    
    nBucks=bucket_diff(xv,tval)
    if nBucks <= 1
        @last_sweep_pos+=1
        rval = @yarr[@last_sweep_pos-1]
    else 
        @last_sweep_pos+= nBucks
    end    
    return rval.nil? ? 0:rval
   
  end
    
  # how many buckets separate the two buckettimes
  def bucket_diff(tv1,tv2)
    return (tv2-tv1).abs / @bucketsize
  end

  def bucket_size_secs
  	return @bucketsize
  end

  
end

end

