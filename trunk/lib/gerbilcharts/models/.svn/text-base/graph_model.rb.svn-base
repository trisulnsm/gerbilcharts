module GerbilCharts::Models

# = GraphModel - Basic interface to a model in GerbilCharts
#
# You can create your own model as long as all the methods here are implemented
# or you can use one of the predefined graph models.
#
#
class GraphModel
  
  attr_accessor :name			  # name of the model (eg, "backup_server")
  attr_accessor :altname		  # alternate name 
  attr_reader   :href			  # href for interactive use
  attr_reader   :userdata	      # any user object
  attr_reader   :userlabel1       # map to tooltip 1 
  attr_reader   :userlabel2       # map to tooltip 2
  attr_reader   :transformer      # value transformer (a lambda function)
  
  def initialize(n="Untitled")
    @name=n
	@transformer = nil
  end
  
  def min_max_x
    yield 0,0    
  end
  
  def min_max_y
    yield 0,0
  end
  
  def each_value_pair
    yield 0,0
  end
  
  def count
    0
  end
  
  # clean up the href (todo: improve this)
  def setHref(h)
    h1=h.gsub("{","%7B")
    @href=h1.gsub("}","%7D")
  end
  
  def hasHref?
    return @href != nil
  end
  
  def setUserData(d)
    @userdata=d
  end
  
  def hasUserData?
    return @userdata != nil
  end
  
  def hasUserTips?
    return @userlabel1 != nil
  end
  
  def setUserTip1(t)
    @userlabel1=t
    @userlabel2="" if @userlabel2.nil?
  end
  
  def setUserTip2(t)
    @userlabel2=t
    @userlabel1="" if @userlabel1.nil?
  end
  
  def updateOptions(opts)
    @name = opts[:name] if opts[:name]
  end
  
  def recreate
    # no op (override this)
  end
  
  def transformer=(trlambda)
    @transformer = trlambda
  end

  def is_timeseries?
	return false
  end
end

end
