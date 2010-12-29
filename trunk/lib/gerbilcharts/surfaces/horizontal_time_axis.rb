module GerbilCharts::Surfaces

# =  HorizontalTimeAxis
# 	 Draws time labels along x-axis
# 	 Most charts use this type of x-axis in time series charts
class HorizontalTimeAxis < HorizontalAxis

    def initialize(opts={})
      @class = "haxis"
      super(opts)
    end
    
    def int_render(g)
      super

      range_options_x = parent.get_global_option(:scaling_x,:auto)
      rx = parent.modelgroup.effective_range_x(range_options_x)
      sfmt = Time.at(rx.rmin).getlocal.to_s


      g.textout(@bounds.left-20, @bounds.top+22, sfmt, {:class => "axislabelt0" })
      g.line(@bounds.left,@bounds.top,@bounds.left,@bounds.top+2,{:class => "axistickmajor"})
      
    end
    
end

end
