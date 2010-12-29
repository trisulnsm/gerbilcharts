module GerbilCharts::Surfaces

# = SurfaceBackground
# See the stylesheet surfaceback for customization
#
class SurfaceBackground < Panel
    def initialize(opts={})
      super(opts)
      @class = "surfaceback"
    end
end

end
