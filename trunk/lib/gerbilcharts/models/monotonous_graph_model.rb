module GerbilCharts::Models

# = MonotonousGraphModel
# simple graph model (x increases monotonously)
# All timeseries models are derived from this class
#
class MonotonousGraphModel < GraphModel
  
  attr_reader :xarr							# the x values 
  attr_reader :yarr						    # the y values 
  attr_reader :xrange,:yrange				# raw ranges
  attr_reader :rounderx, :roundery			# rounded ranges according to presets
  
  def initialize(name,opt={})
    super(name)
    @xrange = RawRange.new
    @yrange = RawRange.new
    @rounderx = RoundRange
    @roundery = RoundRange
    @xarr=[]
    @yarr=[]
  end
 
  # add a tuple, apply a transformer lambda is supplied by the user
  #
  # A new datapoint must have a x_val greater than the previous one
  def add(x_val,y_val)

    if @xarr.length > 0 and @xarr.last > x_val
	  # ignoring out of order data 
      # raise "Expecting monotonous series data"  
	  return 
    end
  
  	# x updates
    @xrange.update x_val
    @xarr << x_val 
    
	# y updates
    y_val = @transformer.xform(y_val) if @transformer
    @yarr << y_val
    @yrange.update y_val
     
  end
  
  # add an array of values at once (just a convenience method)
  def add_tuples tarr
    tarr.each do |t|
      add t[0],t[1]
    end
  end
  
  def clear
    @xrange.reset
    @yrange.reset
    @xarr=[]
    @yarr=[]
  end
  
  def count
    @xarr.size
  end

  def latest
    yield @xarr.last, @yarr.last
  end
  
  def latest_x
    return @xarr.last
  end
  
  def latest_val
    return @yarr.last
  end
  
  def latest_x_dbtime
    return (@xarr.last.tv_sec) << 32
  end
  
  def first
    yield @xarr[0],@yarr[0]
  end
  
  def latest_formatted_val
    return @yrange.format_value(@yarr.last)
  end

  def formatted_val rawval
    return @yrange.format_value(rawval)
  end
    
  def ranges
    yield @xrange, @yrange if block_given?
	return @xrange,@yrange
  end
  
  def round_ranges
    if block_given?
     yield @rounderx.new(@xrange), @roundery.new(@yrange) 
	else
     return @rounderx.new(@xrange), @roundery.new(@yrange)
	end
  end
  
  def round_given_x(rx)
    return @rounderx.new(rx)
  end
  
  def round_given_y(ry)
    return @roundery.new(ry)
  end
    
  def each_tuple
    for i in (0 .. @xarr.length-1)
      yield @xarr[i],@yarr[i]
    end
  end
  
  # crop all tuples older than a cutoff window
  #
  # [+cutoffwindow+] 	older than a number of seconds
  #
  def crop_window(cutoffwindow)
    xcutoff = latest_x - cutoffwindow
	crop_at(xcutoff)
  end
  
  # crop all tuples less than an absolute cutoff
  # [+cutoff+]	Cutoff value
  #
  def crop_at(cutoff)
    until @xarr.empty? or @xarr.first >= cutoff
      @xarr.shift
      @yarr.shift
    end
	recompute_ranges
  end

  # all data points newer than a cut off
  def tuples_since(x_last)
      istart = binarySearch(@xarr,x_last,0,@xarr.length)
      for i in istart..@xarr.length-1
        yield @xarr[i],@yarr[i]
      end
  end

  # for test purposes
  def randomizeLastValue
    v=@yarr.last
    @yarr[@yarr.size-1]=v * ( 0.5 + rand())
  end

  # statistical analysis
  # 	standard deviation and 95th percentile go here
  #
  # mode => :normal or :ninety_fifth
  #
  # returns array 0 = min, 1 = max, 2 = avg, 3 = total, 4 = latest
  #  todo :  5 = stddev  
  #  todo : support :ninety_fifth
  #
  def get_statistical_analysis(mode = :normal)
  	return [0,0,0,0,0] if @yarr.size==0

  	a = []
	a[0]= @yrange.rmin
	a[1]= @yrange.rmax
	a[3]=0

	@yarr.each do |v|
		a[3] = a[3] + v
	end
	a[2] = a[3]/@yarr.size
	a[4] = latest_val
	return a
  end
  
private
  # recompute ranges
  def recompute_ranges
  	@xrange.reset
	@yrange.reset

	each_tuple do |x,y|
		@xrange.update x
		@yrange.update y
	end

  end

  # rudimentary binary search
  def binarySearch(array, target, i, n)
    case n
    when 0
        raise ArgumentError
    when 1
        if array[i] == target
            return i
        elsif i+1 < array.length and array[i] < target && array[i+1]>target
            return i
        else
            raise ArgumentError
        end
    else
        j = i + n / 2
        if array[j] <= target
            return binarySearch(array, target, j, n - n/2)
        else
            return binarySearch(array, target, i, n/2)
        end
    end
  end
end

end
