module GerbilCharts::Surfaces

# == Area Surface w/ transparency
# The transparency kind of allows hidden items to be shown
# 
# ===Options
#	:scaling_x		:auto, :auto_0, or array [minval,maxval]
#   :scaling_y		
#	:butterfly		true/false for butterfly chart (alternate models on +/- y)
#	:zbucketsize	if no data for this many 'x', then insert a zero
#
class AreaSurface < Surface
    def initialize(opts={})
      super(opts)
    end
    
    def int_render(g)


	  range_options_x = parent.get_global_option(:scaling_x,:auto)
	  range_options_y = parent.get_global_option(:scaling_y,:auto)
	  butterfly       = parent.get_global_option(:butterfly,false)
      zbucketsize 	  = parent.get_global_option(:zero_bucketsize,nil)

      rx = parent.modelgroup.effective_range_x(range_options_x)
      ry = parent.modelgroup.effective_range_y(range_options_y)


      # any filters ?
       if parent.get_global_option(:filter,false)
	  g.curr_win.add_options({:filter => "url(##{parent.get_global_option(:filter,false)})" })
       end 

      # ajax if used
      if parent.usesAjax?
        set_ajaxSurfaceContext(rx.rmax,ry.rmax,"AREA")
      end

	  # butterfly chart
	  ry.update(-ry.rmax) if butterfly 

	  y_zero = scale_y 0,ry
      
      parent.modelgroup.each_model_with_index do | mod, i|
        g.begin_polygon
        firstpoint=true
        xpos,ypos=0,0
		last_x=nil
        mod.each_tuple do |x,y|

		  y =-y if butterfly and i.odd?

          xpos = scale_x x,rx
          ypos = scale_y y,ry

          if firstpoint 
            g.polygon_point xpos,y_zero
            firstpoint=false
          end

		  unless zbucketsize.nil?
		  	if last_x && (x-last_x) > zbucketsize
        		g.polygon_point scale_x(last_x,rx) ,y_zero
        		g.polygon_point scale_x(x,rx) ,y_zero
			end
			last_x=x
	      end

          g.polygon_point xpos,ypos
        end
        g.polygon_point xpos,y_zero
        g.end_polygon(:id => "item#{i}", "opacity"=>"0.3")
      end
    end

end


end
