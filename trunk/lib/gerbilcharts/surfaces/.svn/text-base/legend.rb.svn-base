module GerbilCharts::Surfaces

# = Legend
# legend panel shows names/colors of items in a separate box (transparent)
class Legend < GraphElement
  
    attr_reader   :width
    attr_reader   :showvalues
    
    def initialize(opts={})
      @class = "legendpanel"
      super(opts)
      @width = opts[:dim] if defined? opts[:dim]
    end
    
    def int_render(g)
	  return if not parent.get_global_option(:enable_legend,true) 

	  w=g.newwin("legendpanel_mini")
	  g.setactivewindow(w)

      # count determines the bounds
      @bounds.bottom = @bounds.top + 15 * parent.modelgroup.count
      g.rectangle_r(@bounds, {:class => @class})

	  # toggle detail/mini legend 
	  g.rectangle(@bounds.left-5,@bounds.top,5,5, {:href => "javascript:void(0);", 
	  											   :onclick => "showDetailedLegend();",
												   :fill => "white",
												   :stroke => "none" })
	  g.textout(@bounds.left-7,@bounds.top+5,'<', {'font-size' => '9', :href => "javascript:void(0);", 
	  											   :onclick => "showDetailedLegend();", :stroke => '#DDDDDD' })

      rbox = Rect.new
      rbox.initfrom(@bounds)
      rbox.left += 20
      rbox.right = rbox.left + 10
      rbox.top += 2
      rbox.bottom = rbox.top+10
       
      parent.modelgroup.each_model_with_index do | mod, i|

		# Adding tool tips
		opts = { :class => "legendtext" }
		opts.merge!(:onmouseover => "OpacityDown(evt)", :onmouseout => "OpacityUp(evt)") 
		opts.store(:gerbiltooltip1, mod.name) 
		opts.store(:gerbiltooltip2, "Latest Value = #{mod.latest_val}")
	
	    # Selector
        ctlbox = Rect.new
		ctlbox.initfrom(rbox)
		ctlbox.offset_x(-16)
	    ctlbox.deflate(1)
        g.circle_r(ctlbox, {:id => "lbx#{i}", :fill => 'gray', :stroke => 'none', :href => "javascript:void(0);", :onclick => "ToggleVisibility(#{i})"})
	
		boxopts = {:id => "item#{i}"}
		boxopts.store(:fill , color_for_id(i)) if i > 10
		g.rectangle_r(rbox, boxopts )
		g.textout(rbox.right+5, rbox.bottom-2, mod.name,opts)
						
        rbox.top += 10 + 5
        rbox.bottom = rbox.top+10

      end

	  g.setactivewindow
      
    end

    def align_to_anchor(anc)
      super
      @bounds.deflate_v(10,10)
      @bounds.deflate_h(2,4)
      if @width
        @bounds.left = @bounds.right - @width
      end
    end
end
end

