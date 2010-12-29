module GerbilCharts::Surfaces

#  Matrix  Surface
#  Conversation Chart is drawn
#
class MatrixSurface < Surface
  
    def initialize(opts={})
      super(opts)
    end
    
    def int_render(g) 
      # any filters ?
     if parent.get_global_option(:filter,false)
	g.curr_win.add_options({:filter => "url(##{parent.get_global_option(:filter,false)})" })
     end 
       
     # An Outer Rectangle
     g.rectangle(@bounds.left, @bounds.top, @bounds.right, @bounds.bottom)

     # Adding horizontal and vertical lines to the rectangle
     # Vertical Lines
     vline_spacing = @bounds.width / (parent.modelgroup.zendlen+1)
     vline_next = 0
     for i in 0...(parent.modelgroup.zendlen)
          g.line(vline_spacing+vline_next,@bounds.top,vline_spacing+vline_next,@bounds.bottom,:class => "gridlinev")
          vline_next += vline_spacing 
     end
    
     # Horizontal Lines
      hline_spacing = (@bounds.height)/ (parent.modelgroup.aendlen+1) 
      hline_next = @bounds.top
      for i in 0...(parent.modelgroup.aendlen)
          g.line(@bounds.left,hline_spacing+hline_next,@bounds.right,hline_spacing+hline_next,:class => "gridlineh")
          hline_next += hline_spacing
      end  
      
      # X - Axis
      aend = hline_spacing/2 + @bounds.top
      parent.modelgroup.aenduniq.each_with_index do |item,i|
            g.textout(@bounds.left,@bounds.left+(hline_spacing)+aend,item, {:class => "elementlabel"})
            aend += hline_spacing       
      end

     # Y - Axis
     zend = vline_spacing/2
     parent.modelgroup.zenduniq.each_with_index do |item,i|
	   xpos = @bounds.left+vline_spacing+zend 
	   ypos = @bounds.left+(hline_spacing/2)+@bounds.top
           opts = {:class => "elementlabel",
                   "text-anchor" => "middle", 
                   :transform => "rotate(-45 #{xpos} #{ypos})"}
           g.textout(@bounds.left+vline_spacing+zend,@bounds.left+(hline_spacing/2)+@bounds.top,item,opts)
           zend += vline_spacing          
     end

    # Drawing circle based on the values 
      cy_value = 0
      parent.modelgroup.hash.each_pair do |key,value|
          cx_value = 0
          value.each_with_index do |item,i|
                 if item == 0
                    opts = {:id => "item20"}
                 else
  	 	    opts = {:id => "item#{i}"}
                 end
                 # Adding Tool Tips 
                 string ="(" + key + "," + parent.modelgroup.zenduniq[i] +")"
                 if parent.get_global_option(:auto_tooltips,false)
                                  opts.merge!(:onmouseover => "OpacityDown(evt)", :onmouseout => "OpacityUp(evt)")
                                  opts.store(:gerbiltooltip1, string)
                                  opts.store(:gerbiltooltip2, "Val = #{item}")
                 end   
                 # Calculating Radius of the circle based on values
                 radius = (((item.to_f)/parent.modelgroup.sort[0].to_f).to_f * (hline_spacing/2)).to_f
		 radius = radius * parent.modelgroup.multiply_factor
                 g.addshape(GerbilCharts::SVGDC::SVGCircle.new(@bounds.left+vline_spacing+(vline_spacing/2)+cx_value,
                                                               @bounds.left+hline_spacing+(hline_spacing/2)+cy_value+@bounds.top,
                                                               radius),
                                                               opts)
                 cx_value += vline_spacing
          end
          cy_value += hline_spacing  
      end
   end
end
end
