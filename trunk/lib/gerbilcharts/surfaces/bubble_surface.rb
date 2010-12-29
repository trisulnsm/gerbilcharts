module GerbilCharts::Surfaces

#= Bubble Surface
# Data point represented by bubbles using a log scale count
# Control the color,thickness of the line via the stylesheet item lineitem1, lineitem2 etc
# Eg 27,500 = 2x10K bub + 7x1K bub + 5 100 bub (total = 14 bubbles)
#
# Supported global options
#
# [+scaling+]               :auto, :auto_y0
#
class BubbleSurface  < Surface

	BUBGRAINS = [1e+9,1e+8,1e+7,1000000,100000,10000,1000,100,10,1]
	SHAPESZ   = [40,  36,  35,  34,     31,    30,   20,  16, 12,8]
	RSCALE    = 0.50 

    def initialize(opts={})
      super(opts)
    end
    
    def int_render(g)
      rx = parent.modelgroup.effective_round_range_x
      ry = parent.modelgroup.cumulative_sweep_round_range_y0
	  
      # ajax if used
      if parent.usesAjax?
        set_ajaxSurfaceContext(rx.rmax,ry.rmax,"SA")
      end
            
      # prepare models for sweeping
      sweep_pos= rx.rmin
      sweep_to = rx.rmax
	  modnames = []
      parent.modelgroup.each_model do | mod|
          mod.begin_sweep
		  modnames << mod.name
      end

      # sweep interval
      sweep_interval = parent.modelgroup.sweep_interval

	  rbub=@bounds.clone
	  rbub.clip_l(20)
      
      # perform the sweep
      while (sweep_pos<=sweep_to)  

			allshapes = []
            xpos = scale_x sweep_pos,rx
			rbub.translate_x xpos

            parent.modelgroup.each_model_with_index do | mod, i|
              val =  mod.sweep(sweep_pos)
			  allshapes << valtocircles(val)
            end
            
			allshapes.each_with_index do |ai,i|

			  opts = {:id => "item#{i}"}
			  opts.store(:fill,color_for_id(i)) if  i>10

			  if parent.get_global_option(:auto_tooltips,false)
					opts.store(:gerbiltooltip1, modnames[i]) 
			  end


			  ai.each do |shp|
			  	shp.x = rbub.left + rand*(rbub.width)
				shp.y = rbub.bottom - rand*(rbub.height*0.75)
              	g.addshape(shp, opts)
			  end
			end


            sweep_pos += sweep_interval
     end

    end

	# vartoradii
	def valtocircles(val)
		
		splitup=BUBGRAINS.collect do |grain_size|
			n=(val/grain_size)
			val = val%grain_size
			(n*RSCALE).to_i 
		end

		
		ret=[]
		shapes=SHAPESZ.each_with_index do |s,i|
			splitup[i].times do  |t|
              ret << GerbilCharts::SVGDC::SVGCircle.new(0, 0, s) 
			end
		end

		ret

	end


end

end
