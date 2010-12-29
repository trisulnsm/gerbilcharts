module GerbilCharts::Surfaces

# = Horizontal name axis
#
# Draws names of models instead of values, used for bar charts 
class HorizontalNameAxis < Axis

    def initialize(opts={})
      @class = "haxis"
      super(opts)
    end
        
    def int_render(g)
			super      
			xp = @bounds.left + parent.anchor.element_spacing + parent.anchor.element_width/2
			parent.modelgroup.each_model_with_index  do |m,i|
				yoff=get_stagger_off(i,10)

				#Adding tool tips to the text 	
				opts = { :class => "axislabel","text-anchor"=> "middle" }
				parent.get_global_option(:auto_tooltips,false)

				opts.merge!(:onmouseover => "OpacityDown(evt)", :onmouseout => "OpacityUp(evt)") 
				opts.store(:gerbiltooltip1, m.name) 
				opts.store(:gerbiltooltip2, "Val = #{m.latest_val}")
			
				g.textout(xp, @bounds.top+15+yoff, m.name[0..14], opts)
				xp += parent.anchor.element_width + parent.anchor.element_spacing
			end
	 end
  end
end
