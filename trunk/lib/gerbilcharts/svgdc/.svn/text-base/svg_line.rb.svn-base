module GerbilCharts::SVGDC

# = SVGLine
# A simple svg line that honors the rendering attributes 
#
# See tests for examples
#
class SVGLine < SVGShape
  
  attr_reader :x1, :y1, :x2, :y2
  
  def initialize(x1,y1,x2,y2)
    super()
    @x1,@y1,@x2,@y2=x1,y1,x2,y2
  end
  
  def render(xfrag)
    fmt="%.2f"
    h= { :x1 => fmt%@x1, :y1 => fmt%@y1, :x2 => fmt%@x2, :y2 => fmt%@y2 }
    xfrag.line( h.merge(render_attributes))
  end
  
end


end
