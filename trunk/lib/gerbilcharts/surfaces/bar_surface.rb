module GerbilCharts::Surfaces

# = Bar Surface
# Draws latest values from models in a bar chart
#
# Options 
#  element_width : optimum width of bars
#  element_spacing : optimum spacing of bars
class BarSurface < Surface
  
    attr_reader     :element_width		# optimum width of bar
    attr_reader     :element_spacing	# optimum spacing between bars
  
    def initialize(opts={})
      super(opts)
      @element_width = opts[:element_width]||20
      @element_spacing = opts[:element_spacing]|| 25
    end
    
    def int_render(g)  
       # bail out of empty models quickly
       if parent.modelgroup.empty?
       		g.textout(@bounds.left + @bounds.width/2, @bounds.height/2, 
                 	  parent.modelgroup.empty_caption,{"text-anchor" => "middle"})
        	return
       end

       # any filters ?
       if parent.get_global_option(:filter,false)
	  g.curr_win.add_options({:filter => "url(##{parent.get_global_option(:filter,false)})" })
       end 
    
    
       # see if the element spacing or width need to be adjusted to fit
       nmodels = parent.modelgroup.count
       extra_space = @bounds.width - (nmodels * (@element_width + @element_spacing) + @element_spacing)
       if extra_space < 0
			  delta_per_item = extra_space/(2*nmodels)
			  @element_width += delta_per_item
			  @element_spacing += delta_per_item
	   else
	   	  @element_spacing += extra_space /(nmodels)
       end
		  
       # atleast one model is present, chhug along  
       range_options_y = parent.get_global_option(:scaling_y,:auto)
       ry = parent.modelgroup.effective_range_y(range_options_y)
       set_ajaxSurfaceContext(0,ry.rmax,"BAR") if parent.usesAjax?
     
       xpos = @bounds.left + @element_spacing 
       parent.modelgroup.each_model_with_index do | mod, i|
			   y=mod.latest_val
			   ypos = scale_y y,ry
       
			   # Adding tool tips to the rectangle 
			   opts = {:id => "item#{i}"}
			   if parent.get_global_option(:auto_tooltips,false)
				opts.merge!(:onmouseover => "OpacityDown(evt)", :onmouseout => "OpacityUp(evt)") 
				opts.store(:gerbiltooltip1, mod.name) 
				opts.store(:gerbiltooltip2, "Val = #{mod.latest_val}")
			   end

			   opts.merge!(:href => mod.href) if mod.hasHref?
       
			   # draw the bar
			   g.rectangle(xpos, ypos, @element_width, @bounds.bottom - ypos, opts)
			   g.textout( xpos+@element_width/2, ypos-5, 
						  mod.latest_formatted_val,
						  {:class => "elementlabel", "text-anchor" => "middle"})
			   xpos += @element_spacing + @element_width       
       end      
    end
end

end
