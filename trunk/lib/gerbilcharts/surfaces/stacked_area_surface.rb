module GerbilCharts::Surfaces

# == Stacked Area Surface w/ transparency
# models are expected to be 'sweepable' (use a bucketized time series model)
#
class StackedAreaSurface < Surface
    def initialize(opts={})
      super(opts)
    end
    
    def int_render(g)
	  range_options_x = parent.get_global_option(:scaling_x,:auto)

      rx = parent.modelgroup.effective_range_x(range_options_x)
      ry = parent.modelgroup.cumulative_sweep_round_range_y0
	  
      # ajax if used
      if parent.usesAjax?
        set_ajaxSurfaceContext(rx.rmax,ry.rmax,"SA")
      end


	  # draw reference if any
	  if parent.modelgroup.has_ref_model?
	   		ref_model = parent.modelgroup.ref_model

	  		y_zero = scale_y 0,ry
        	g.begin_polygon
        	firstpoint=true
        	xpos,ypos=0,0
			last_x=nil
        	ref_model.each_tuple do |x,y|

				xpos = scale_x x,rx
			    ypos = scale_y y,ry

          		if firstpoint 
					g.polygon_point xpos,y_zero
					firstpoint=false
          		end

				if last_x && (x-last_x) > parent.modelgroup.sweep_interval
					g.polygon_point scale_x(last_x,rx) ,y_zero
					g.polygon_point scale_x(x,rx) ,y_zero
				end
				last_x=x

          		g.polygon_point xpos,ypos
        	end
        	g.polygon_point xpos,y_zero
        	g.end_polygon(:id => "ref_mod")
      end
            
      # prepare models for sweeping
      sweep_pos= rx.rmin
      sweep_to = rx.rmax
      polygons = []
	  modnames = []
	  
	  klass_poly = parent.get_global_option(:squarize,false) ? 
	  					GerbilCharts::SVGDC::SVGSquarizedPolygon :
	  					GerbilCharts::SVGDC::SVGPolygon 

      parent.modelgroup.each_model do | mod|
          mod.begin_sweep
          polygons << klass_poly.new
		  modnames << mod.name
      end
        
      # sweep interval
      sweep_interval = parent.modelgroup.sweep_interval
      
      # perform the sweep
      while (sweep_pos<=sweep_to)  
            acc_y = 0
            parent.modelgroup.each_model_with_index do | mod, i|
              acc_y +=  mod.sweep(sweep_pos)

              xpos = scale_x sweep_pos,rx
              ypos = scale_y acc_y,ry
              
              if polygons[i].isempty?
                  polygons[i].addpoint(xpos,@bounds.bottom)
              end
              
              polygons[i].addpoint(xpos,ypos)
            end
            
            sweep_pos += sweep_interval
     end

     # layout all polygons in reverse
     i=polygons.length-1
	 last_x = scale_x sweep_to,rx
     polygons.reverse_each do |p|
	    p.addpoint(last_x,@bounds.bottom)

		opts = {:id => "item#{i}" }
		if parent.get_global_option(:auto_tooltips,false)
			opts.merge!(:onmouseover => "OpacityDown(evt)", :onmouseout => "OpacityUp(evt)") 
			opts.store(:gerbiltooltip1, modnames[i]) 
		end

        g.addshape(p,opts)
        i -= 1
     end
      
    end

end

end
