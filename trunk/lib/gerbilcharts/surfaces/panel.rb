module GerbilCharts::Surfaces

# = Panel
# General purpose rectangular panel
class Panel < GraphElement
    def initialize(opts={})
      @class = "panel"
      super(opts)
    end
    
    def int_render(g)
      g.rectangle_r(@bounds, {:class => @class})
    end
  
end

end
