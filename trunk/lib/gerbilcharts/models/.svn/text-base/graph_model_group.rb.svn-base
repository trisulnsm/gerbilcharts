module GerbilCharts::Models

# GraphModelGroup - a bunch of related models that are targeted at a
# 		single output surface
#
class GraphModelGroup
  
  attr_accessor :models
  attr_accessor :name
  attr_accessor :href
  attr_accessor :emptycaption
  attr_accessor :units
  attr_accessor :x_markers
  attr_accessor :ref_model
  
  def initialize(n="Untitled-Group")
    @models=[]
    @name=n
    @units=""
  end
  
  def <<(m)
    @models << m
  end
  
  def add(m)
    @models << m
  end
  
  def delete(m)
    @models.delete(m)
  end
  
  def delete_by_index(i)
    @models.delete_at(i)
  end
  
  def set_null(i)
    @models[i]=nil
  end
  
  def compact_models
    @models.compact!
  end
  
  def count
    return @models.size
  end
  
  def each_model
    @models.each do |m|
      yield m
    end
  end
  
  def clear_models
    @models.clear
  end
    
  # sort options
  #   :dir => (:ascending or :descending)
  #   :mode => (:latest, :total )
  def sort(opts={})
    
    raise "Missing sort direction" if not defined? opts[:dir]
    raise "Missing sort mode" if not defined? opts[:mode]
    
    @models.sort! { |m1,m2| m1.latest_val <=> m2.latest_val }
    
    @models.reverse! if opts[:dir] == :descending
  
  end
  
  # each model, index over code block
  def each_model_with_index
    @models.each_with_index do |m,i|
      yield m,i
    end
  end
  
  # each user data over code block
  def each_user_data
    each_model do |mod|
      yield mod.userdata if mod.hasUserData?
    end
  end

  # rangeoptions
  # [+:auto+]	 automatic rounded max and min range
  # [+:auto_0+]  automatic rounded max and 0 min
  # [+[min,max+] manual scaling
  #
  def effective_range_x(rangeopts=nil)
	
	return effective_round_range_x if rangeopts.nil?

	if  rangeopts.is_a?(Array) and rangeopts.size == 2
    		reffx = RawRange.new
		reffx.update(rangeopts[0])
		reffx.update(rangeopts[1])
		return reffx
	else
		case rangeopts.to_sym
			when :auto	;return effective_round_range_x
			when :auto_0 	;return effective_round_range_x
			else		;raise "Unknown range option"
		end
	end
  end
  
  # effective round range
  # rounds both x and y scales, returns two ranges 
  def effective_round_range
    
    return 0,0 if  @models.empty?
    
    reffx = RawRange.new
    reffy = RawRange.new
    @models.each do |m|
      reffx.update_r(m.xrange)
      reffy.update_r(m.yrange)
    end    
    
	# todo : need to convert the round_given method to a class method
    return models[0].rounderx.round_given(reffx), models[0].roundery.round_given(reffy)
    
  end

  # round the x ranges of all models
  def effective_round_range_x

    return 0,0 if  @models.empty?
    
    reffx = RawRange.new
    @models.each do |m|
      reffx.update_r(m.xrange)
    end    

	if reffx.invalid?
		reffx.update 10
	end


    return models[0].round_given_x(reffx)
  end
  
  # rangeoptions
  # [+:auto+]	 automatic rounded max and min range
  # [+:auto_0+]  automatic rounded max and 0 min
  # [+[min,max+] manual scaling
  #
  def effective_range_y(rangeopts=nil)
  	if rangeopts.nil?
		return effective_round_range_y0
	end

	if rangeopts == :auto
		return effective_round_range_y
	elsif rangeopts == :auto_0
		return effective_round_range_y0
	elsif  rangeopts.respond_to?('size') and rangeopts.size == 2
    	reffy = RawRange.new
		reffy.update(rangeopts[0])
		reffy.update(rangeopts[1])
		return reffy
	end
  end
  
  # round the y ranges of all models but minimum fixed at 0
  def effective_round_range_y0
    reffy = RawRange.new
    reffy.zeromin
    @models.each do |m|
      reffy.update_r(m.yrange) 
    end    
    return @models[0].round_given_y(reffy)
  end

  def effective_round_range_y
    reffy = RawRange.new
    @models.each { |m| reffy.update_r(m.yrange) }   
    return @models[0].round_given_y(reffy)
  end
  
  def sweep_interval
      return @models[0].sweep_interval
  end
  
  # sum of model ranges  with min y being 0
  def cumulative_round_range_y0

    return 0,100 if models.empty? 

    reffy = RawRange.new
    reffy.update(0)
    @models.each do |m|
      reffy.update(m.yrange.rmax+reffy.rmax) if m.yrange.rmax
    end    

 	reffy.update(ref_model.yrange.rmax)  if has_ref_model?
    return models[0].round_given_y(reffy)

  end

  # sum of model ranges  
  def cumulative_round_range_y
    reffy = RawRange.new
    @models.each do |m|
      reffy.update(m.yrange.rmax+reffy.rmax)
    end    
 	reffy.update(ref_model.yrange.rmax)  if has_ref_model?
    return models[0].round_given_y(reffy)
  end



  # sweep for an interval with y scale starting 0
  # this is most appropriate for network traffic charts
  def cumulative_sweep_round_range_y0
  	reffy=RawRange.new
	reffy.zeromin
	return cumulative_sweep_round_range_y_generic(reffy)
  end

  # sweep for an interval with y scale 
  def cumulative_sweep_round_range_y0
  	reffy=RawRange.new
	return cumulative_sweep_round_range_y_generic(reffy)
  end


  def cumulative_round_range
    
    return 0,0 if  @models.empty?
    
    reffx = RawRange.new
    reffy = RawRange.new
    @models.each do |m|
      reffx.update_r(m.xrange)
      reffy.update(m.yrange.rmax+reffy.rmax)
    end    
    
    return models[0].rounderx.round_given(reffx), models[0].roundery.round_given(reffy)
    
  end
  
  def models_digest
    mnames = ""
    @models.each do |m|
      mnames << m.name
    end
    dig=Digest::MD5.hexdigest(mnames)
    return dig
  end
  
  def setSessionKey(k)
    @sessionKey=k
  end
  
  def contentKey(sessid,extension)
    return sessid + @sessionKey + "." + extension
  end
  
  def setHref(h)
    h1=h.gsub("{","%7B")
    @href=h1.gsub("}","%7D")
  end
  
  def hasHref?
    return @href != nil
  end
  
  def randomizeModels(mode=:latest_value)
    @models.each do |m|
      if mode==:latest_value
        m.randomizeLastValue
      end
    end
  end
  
  # recreate all models with new params
  def recreateModels(new_opts)
    @models.each do |m|
        m.updateOptions(new_opts)
        m.recreate
    end
  
  end
  
  # empty ?
  def empty?
    return @models.empty?
  end
  
  # empty string
  def empty_caption
    return "No activity" if @emptycaption.nil?
    return @emptycaption
  end

  def has_x_markers?
	not x_markers.nil?
  end

  def has_ref_model?
  	not @ref_model.nil?
  end



private

  # :nodoc:
  def cumulative_sweep_round_range_y_generic(reffy)
      
    rx = effective_round_range_x
            
	# prepare models for sweeping
	sweep_pos= rx.rmin
	sweep_to = rx.rmax
      
	@models.each do | mod|
	  mod.begin_sweep
	end
        
	# perform the sweep
	while (sweep_pos<=sweep_to)  
		acc_y = 0
		@models.each do | mod, i|
			acc_y +=  mod.sweep(sweep_pos)
		end
		sweep_pos += sweep_interval
		reffy.update(acc_y)
	end

 	reffy.update(ref_model.yrange.rmax)  if has_ref_model?

    return models[0].round_given_y(reffy)
      
  end  
  
end

end

