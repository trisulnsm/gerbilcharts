module GerbilCharts::SVGDC

# = SVGEllpise 
# Draws a circle at x, y, and radius rx, ry
#
class SVGEllipse < SVGShape
  
  attr_accessor :x,:y,:rx,:ry
  
  def initialize(x,y,rx,ry)
    @x,@y,@rx,@ry=x,y,rx,ry
    super()
  end
  
  def render(xfrag)
    h = { :cx => @x, :cy => @y, :rx => @rx, :ry => @ry }
    xfrag.ellipse(h.merge(render_attributes))
  end
end

end
