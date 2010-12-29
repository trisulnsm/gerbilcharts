module GerbilCharts::Surfaces

# =VerticalAxis
# Mostly contains rounded Y-values
#
class VerticalAxis < Axis

  attr_reader 	:use_cumulative_y		# use the cumulative (sum of all models) range

  def initialize(opts={})
      @class = "vaxis"
      super(opts)

	  @use_cumulative_y = false 
	  @use_cumulative_y = opts[:cumulative] if opts[:cumulative]
    end
    
  def int_render(g)
      
      g.rectangle_r(@bounds, {:class => @class})
      
      return if parent.modelgroup.empty?
      
	  butterfly       = parent.get_global_option(:butterfly,false)

	  if @use_cumulative_y
        ry = parent.modelgroup.cumulative_sweep_round_range_y0
	  else
      	ry = parent.modelgroup.effective_range_y(parent.get_global_option(:scaling_y,:auto))
	  end

	  # butterfly mode
	  ry.update(-ry.rmax) if parent.get_global_option(:butterfly,false)

      ry.each_label do |val,label|
          yp = scale_y val,ry
          yp_label=yp + 4
          
          # make sure the edge ones are visible
          yp_label = max(yp_label,@bounds.top+10)
          
          g.textout(@bounds.right-4, yp_label, label, {:class => "axislabel", "text-anchor" => "end"})
          g.line(@bounds.right-1,yp,@bounds.right+1,yp, {:class => "axistickmajor"})
      end

  end

end

end

