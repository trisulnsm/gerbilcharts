module GerbilCharts::Surfaces

# Basic Grid - just X-markers light dashed
#
class BasicGrid < Grid
    def initialize(opts={})
      super(opts)
      @class = "grid"
    end
    
    def int_render(g)
      super
    end
    
end

end
