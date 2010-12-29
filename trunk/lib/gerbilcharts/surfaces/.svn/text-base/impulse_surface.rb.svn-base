module GerbilCharts::Surfaces

# = Impulse Bar Surface w/ transparency
#   impulse duration = width of bar
class ImpulseSurface < Surface
    def initialize(opts={})
      super(opts)
    end
    
    def int_render(g)
      
	  range_options_x = parent.get_global_option(:scaling_x,:auto)
	  range_options_y = parent.get_global_option(:scaling_y,:auto)
      rx = parent.modelgroup.effective_range_x(range_options_x)
      ry = parent.modelgroup.effective_range_y(range_options_y)
      
	  impulse_width = 2
	  x2  = scale_x Time.at(0),rx
	  x1  = scale_x Time.at(parent.modelgroup.models[0].bucket_size_secs),rx
	  impulse_width = (x2-x1).abs if x2 != x1

      # ajax if used
      if parent.usesAjax?
        set_ajaxSurfaceContext(rx.rmax,ry.rmax,"IMPULSE")
      end


      
	  w=g.newwin("impulse", "stroke-width" => impulse_width)
	  g.setactivewindow(w)

      parent.modelgroup.each_model_with_index do | mod, i|
        opts = {:id => "lineitem#{i}"}
        firstpoint=true
        xpos=0
        ypos=0
        mod.each_tuple do |x,y|
          xpos = scale_x x,rx
          ypos = scale_y y,ry
          g.line(xpos,@bounds.bottom,xpos,ypos,opts)
        end
      end
      
	  g.setactivewindow
    end

end

end
