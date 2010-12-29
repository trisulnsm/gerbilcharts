module GerbilCharts::Models

# == BucketizedTimeSeriedGraphMode
#
# Automatically bucketizes incoming timeseries data into predefined buckets
#
# [+name+]   			Name of the model
# [+bucketsec+]         Bucket size in seconds
# [+opts+]				Model options hash
# 
class BucketizedTimeSeriesGraphModel < TimeSeriesGraphModel
  
  attr_reader   :bucket_size_secs		# current bucket size
  attr_reader   :behavior				# :average or :max
  attr_reader   :last_sweep_pos			# :nodoc:
  
  def initialize(name,bucketsec, opt={})
    super(name,opt)
    @bucket_size_secs=bucketsec
    @samp_count =0
    @behavior = :average
    @last_sweep_pos=0
  end
  
  def sweep_interval
      return @bucket_size_secs
  end

   # add 
   # [+x_val+]		A Time object 
   # [+y_val+]		Value 
   #
   # This will be bucketized by the model automatically
   #
   def add(x_tm,y_val)
    buckettm_in = to_buckettime(x_tm)
    

    # first time
    if @xarr.length==0
        super(buckettm_in,y_val)
        @samp_count=1
        return
    end
      
    # subsequent times
    if buckettm_in== latest_x
        ynew = bucketize(y_val)
    else
        npad = bucket_diff(latest_x,buckettm_in)
        if (npad > 1)
            pad_empty_buckets(latest_x,npad-1)
        end
        super(buckettm_in,y_val)
        @samp_count=1
    end
  end

  # to_buckettime
  #
  # [+tv+]	A Time object
  #
  # returns the time floor of the bucket this belongs to
  # example  8:06 AM will belong to the 8:05AM bucket if bucketsize = 5 min
  #
  def to_buckettime(tv)
      exp=tv.tv_sec.divmod(@bucket_size_secs)
      
      if exp[1] >= @bucket_size_secs/2
        return Time.at(exp[0]*@bucket_size_secs + @bucket_size_secs)
      else
        return Time.at(exp[0]*@bucket_size_secs)
      end
  end
  
  # how many buckets separate the two buckettimes
  def bucket_diff(tv1,tv2)
    return (tv2-tv1).abs / @bucket_size_secs
  end
  
  # insert zero values to represent missing time buckets
  def pad_empty_buckets(tv_first,count)
    for i in (1..count)
      @yarr << 0
      @xarr << tv_first + i*@bucket_size_secs
    end
  end
  
  # accumulate last item
  def bucketize(val)
    
    if @behavior == :average 
      cval = @yarr.last
      cval = (cval * @samp_count) + val
      cval /= (@samp_count+1)
      @yarr[@yarr.length-1]=cval
      @samp_count += 1
    elsif @behavior == :maxima
      cval = @yarr.last
      @yarr[@yarr.length-1]=max(cval,val)
    end
    return @yarr.last

  end
    
  # begin a sweep session
  def begin_sweep
      @last_sweep_pos=0
  end

  # sweep this bucket
  def sweep(tval)
    
    return 0 if @xarr.length == 0
    return 0 if @last_sweep_pos >= @xarr.length
    
    
    xv=@xarr[@last_sweep_pos]
    if tval < xv
        return 0
    elsif tval == xv
        @last_sweep_pos+=1
        rval = @yarr[@last_sweep_pos-1]
    else 
        nBucks=bucket_diff(xv,tval)
        @last_sweep_pos+= nBucks
    end    
    return rval.nil? ? 0:rval
    
  end
  
  
end


end


