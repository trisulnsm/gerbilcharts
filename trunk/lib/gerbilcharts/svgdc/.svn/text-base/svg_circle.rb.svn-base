module GerbilCharts::SVGDC

# = SVGCircle 
# Draws a circle at x, y, and radius r
#
class SVGCircle < SVGShape
  
  attr_accessor :x,:y,:r
  
  def initialize(x,y,r)
    @x,@y,@r=x,y,r
    super()
  end
  
  def render(xfrag)
    h = { :cx => @x, :cy => @y, :r => @r }
    xfrag.circle(h.merge(render_attributes))
  end
  
end

end
