module GerbilCharts::Surfaces

# == Axis - base for all axis types (attach to model)
#
class Axis < GraphElement
    attr_reader :stagger_levels
  
    def initialize(opts={})
      super(opts)
      set_defaults()
      @stagger_levels = opts[:stagger] if  opts[:stagger]
    end
    
    def set_defaults
      @class = "axispanel"
      @stagger_levels=1
    end
    
    def int_render(g)
      g.rectangle_r(@bounds, {:class => @class})
    end
    
    def get_stagger_off(level, offset)
      return (level % @stagger_levels) * offset
    end
    
end

end
