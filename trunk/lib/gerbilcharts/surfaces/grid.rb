module GerbilCharts::Surfaces

# = Grid - grid overlay
#  Draws both x and y grids
class Grid < GraphElement
    
	attr_reader :tick_count

    def initialize(opts={})
      super(opts)
	  @tick_count = 5
    end
    
    def int_render(g)
	  ry = grid_range_y
	  rx = grid_range_x

	  # horizontal grid lines
	  g.newwin('hgrid', {:class => "gridlineh"} ) do |g|
			  ry.each_label do |val,label|
				  yp = scale_y val,ry
				  g.line(@bounds.left,yp,@bounds.right,yp)
			  end
	  end 

	  # horiz subticks
	  g.newwin('hgridsub', {:class => "gridlinesub"} ) do |g|
			  ry.each_tick(@tick_count)  do |val|
				  yp = scale_y val,ry
				  g.line(@bounds.left,yp,@bounds.right,yp)
			  end
	  end

        
      scaling_x  = parent.get_global_option(:scaling_x,:auto)
      rwx = parent.modelgroup.effective_range_x(scaling_x)
	  if scaling_x.is_a? Array
		rx = GerbilCharts::Models::RoundTimeRange.new(rwx)
      end

	  # vertical subticks  
	  g.newwin('vgrid', {:class => "gridlinev"} ) do |g|
			  rx.each_label do |val,label|
				  xp = scale_x val,rwx
				  g.line(xp,@bounds.top,xp,@bounds.bottom)
			  end
	  end


	  g.newwin('vgridsub', {:class => "gridlinesub"} ) do |g|
			  rx.each_tick(0) do |val|
				  xp = scale_x val,rwx
				  g.line(xp,@bounds.top,xp,@bounds.bottom)
			  end
	  end


    end
    
  protected
    
  def grid_range_x
     return parent.modelgroup.effective_round_range_x
  end
    
  def grid_range_y
     return parent.modelgroup.effective_round_range_y0
  end
  
end

end
