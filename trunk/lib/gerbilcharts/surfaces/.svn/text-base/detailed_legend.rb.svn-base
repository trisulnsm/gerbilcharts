module GerbilCharts::Surfaces

# = Legend
# legend panel shows names/colors of items in a separate box (transparent)
class DetailedLegend < GraphElement
  
	WIDTH_MAX = 500
	STAT_TABLE_OFFSET=120

    attr_reader   :width
    attr_reader   :showvalues
    
    def initialize(opts={})
      @class = "legendpanel"
      super(opts)
      @width = opts[:dim] if defined? opts[:dim]
    end
    
    def int_render(g)

	  return unless parent.get_global_option(:enable_detailed_legend,true) 

	  w=g.newwin("legendpanel_detail", {:visibility => 'hidden'} )
	  g.setactivewindow(w)


	  # get max modname, used to calculate width of detailed panel
	  max_name_length=0
      parent.modelgroup.each_model do | mod |
	  	max_name_length = [max_name_length,mod.name.length].max
	  end

	  @bounds.left = @bounds.right-WIDTH_MAX  if @bounds.width > WIDTH_MAX

      # count determines the bounds
      @bounds.bottom = @bounds.top + 16 + 15 * parent.modelgroup.count
      g.rectangle_r(@bounds, {:class => @class})

	  # toggle detail/mini legend 
	  g.rectangle(@bounds.left-5,@bounds.top,5,5, {:href => "javascript:void(0);", 
	  											   :onclick => "showMiniLegend();",
												   :fill => "white",
												   :stroke => "none" })
	  g.textout(@bounds.left-4,@bounds.top+5,'>', {'font-size' => '9', :href => "javascript:void(0);", 
	  											   :onclick => "showMiniLegend();", :stroke => '#DDDDDD' })

      
      rbox = Rect.new
      rbox.initfrom(@bounds)
      rbox.left += 2
      rbox.right = rbox.left + 10
      rbox.top += 2
      rbox.bottom = rbox.top+10
       


	  stat_label_pos = rbox.right + STAT_TABLE_OFFSET
	  lab = %w(Max Min Avg Latest).inject("") { |m,ai| m += ai.rjust(9)}  
      g.textout(stat_label_pos, rbox.bottom-2, lab, {'xml:space' => 'preserve', :class => "legendstats"} )

      rbox.top += 16
      rbox.bottom = rbox.top+10

      parent.modelgroup.each_model_with_index do | mod, i|

		# Adding tool tips
		opts = { :class => "legendtext" }
		opts.merge!(:onmouseover => "OpacityDown(evt)", :onmouseout => "OpacityUp(evt)") 
		opts.store(:gerbiltooltip1, mod.name) 
		opts.store(:gerbiltooltip2, "Latest Value = #{mod.latest_val}")
	
        g.rectangle_r(rbox, :id => "item#{i}")
        g.textout(rbox.right+5, rbox.bottom-2, mod.name,opts)

		stat_ana = mod.get_statistical_analysis

	  	stat_label_pos = rbox.right + STAT_TABLE_OFFSET
		outs = mod.formatted_val(stat_ana[1]).to_s.rjust(9) +
			   mod.formatted_val(stat_ana[0]).to_s.rjust(9) +
			   mod.formatted_val(stat_ana[2]).to_s.rjust(9) +
			   mod.formatted_val(stat_ana[4]).to_s.rjust(9) 
        g.textout(stat_label_pos, rbox.bottom-2, outs, {'xml:space' => 'preserve', :class => 'legendstats'} )

        
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

