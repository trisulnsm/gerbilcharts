module GerbilCharts::Surfaces

#  Matrix  Surface
#  Conversation Chart is drawn
#
class ConversationRing < Surface
  
    def initialize(opts={})
      super(opts)
    end
    
    def int_render(g)
         # any filters ?
        if parent.get_global_option(:filter,false)
            g.curr_win.add_options({:filter => "url(##{parent.get_global_option(:filter,false)})" })
        end
      
        # Draw an outer rectangle  
        g.rectangle(@bounds.left, @bounds.top, @bounds.right, @bounds.bottom)
        
        # Draw an outer circle
        center_x = (@bounds.width/2)
        center_y = (@bounds.height/2) + @bounds.top + 10
        radius_x = (@bounds.width/2 - 35)
        radius_y = (@bounds.height/2 - 15)
        g.addshape(GerbilCharts::SVGDC::SVGEllipse.new(center_x,center_y,radius_x,radius_y), :fill => '#FFD' )
       
        
        parent.modelgroup.hash.each_pair do |key,value|
             angle = 360/value.length
             tot_angle = 0
             # Draw the center circle              
             radius1 = 15 
             opts = {:id => "item0"}
             g.addshape(GerbilCharts::SVGDC::SVGCircle.new(center_x,center_y,radius1),opts)
             g.textout(center_x-30,center_y-20,key,:class => 'elementlabel')
              
             # Draw the remaining circles proportion to the largest values
             value.each_with_index do |item,i|
                opts = {:id => "item#{i+1}"}
                label= parent.modelgroup.zenduniq[i]
                string = "(" + key + "-" + label + ")"
                
                # Adding tool tips
                if parent.get_global_option(:auto_tooltips,false)
                                  opts.merge!(:onmouseover => "OpacityDown(evt)", :onmouseout => "OpacityUp(evt)")
                                  opts.store(:gerbiltooltip1, string)
                                  opts.store(:gerbiltooltip2, "Volume #{GerbilCharts::Models::Presets.new.format_suffix(item)}")
                end                               
                
 		# Calculating radius
                radius1 = 20                
                effective_radius = (((item.to_f)/parent.modelgroup.sort[0].to_f).to_f * radius1) 
		effective_radius = [effective_radius,5.0].max

		# draw out
                cx = center_x + (Math.cos((Math::PI/180)*(angle+tot_angle))*(radius_x))
                cy = center_y + (Math.sin((Math::PI/180)*(angle+tot_angle))*(radius_y))
                g.addshape(GerbilCharts::SVGDC::SVGCircle.new(cx,cy,effective_radius),opts)
                g.textout(cx-30,cy-15,label,:class => 'elementlabel')

                tot_angle += angle
            end
         end
    end
end
end
