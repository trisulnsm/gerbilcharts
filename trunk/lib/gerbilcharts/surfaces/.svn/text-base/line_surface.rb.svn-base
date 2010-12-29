module GerbilCharts::Surfaces

# = Line Surface
# Simple line drawing 
# Control the color,thickness of the line via the stylesheet item lineitem1, lineitem2 etc
#
# Supported global options
#
# [+circle_data_points+]    Draw a solid circle around datapoints
# [+scaling+]               :auto, :auto_y0
#
class LineSurface < Surface
    def initialize(opts={})
      super(opts)
    end
    
    def int_render(g)
      
	  range_options_x = parent.get_global_option(:scaling_x,:auto)
	  range_options_y = parent.get_global_option(:scaling_y,:auto)
	  butterfly       = parent.get_global_option(:butterfly,false)

      rx = parent.modelgroup.effective_range_x(range_options_x)
      ry = parent.modelgroup.effective_range_y(range_options_y)

	  ry.update(-ry.rmax) if butterfly 

      # ajax if used
      if parent.usesAjax?
        set_ajaxSurfaceContext(rx.rmax,ry.rmax,"LINE")
      end

      parent.modelgroup.each_model_with_index do | mod, i|
      
        mod.each_tuple do |x,y|

		  y = -y if butterfly and i.odd?

		  # the basic line 
          xpos = scale_x x,rx
          ypos = scale_y y,ry
          g.lineto xpos,ypos

		  # datapoint and a tooltip 
       	  opts = {:id => "item#{i}"}
		  if parent.get_global_option(:auto_tooltips,false)
				  opts.merge!(:onmouseover => "OpacityDown(evt)", :onmouseout => "OpacityUp(evt)") 
				  opts.store(:gerbiltooltip1, mod.name) 
				  opts.store(:gerbiltooltip2, "Val = #{y}")
		  end
		  g.circle(xpos,ypos,4,opts) if parent.get_global_option(:circle_data_points,false)
        end
        g.endline(:id => "lineitem#{i}")
      end
      
      #draw each model in the group
    end

end

end
