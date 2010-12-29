module GerbilCharts::Surfaces

class HorizontalAxis < Axis

    def initialize(opts={})
      @class = "haxis"
      super(opts)
    end
        
    def int_render(g)
      super
      
      return if parent.modelgroup.empty?
      
      range_options_x = parent.get_global_option(:scaling_x,:auto)
      rawx = parent.modelgroup.effective_range_x(range_options_x)


	  # need roundx for labels
	  if range_options_x.is_a? Array
      	roundx = GerbilCharts::Models::RoundTimeRange.new rawx
	  else
      	roundx = parent.modelgroup.effective_round_range_x
      end


      roundx.each_label do |val,label|
        xp = scale_x val,rawx

	    break if val>rawx.rmax
          
        # make sure edge ones are visible
        if (xp>=@bounds.right-10)
            xp = @bounds.right-10
        end
          
	if (xp>=15)
		g.textout(xp, @bounds.top+11, label, {:class => "axislabel", "text-anchor" => "middle"})
		g.line(xp,@bounds.top-2,xp,@bounds.top+1, {:class => "axistickmajor"})
	end
      end
      
    end
    
end

end
