module GerbilCharts::Surfaces

# = Surface - graph surface
# Base class for all surfaces (line,bar,pie,area,...)
#
class Surface < GraphElement

    def initialize(opts={})
      @class = "surfacepanel"
      super(opts)
    end
    
    def int_render(g)
    end

    def set_ajaxSurfaceContext(mxx, mxy, type)
      parent.set_ajaxContext(:axmxx => mxx, :axmxy => mxy, :axsurface => type)
    end
end

end
