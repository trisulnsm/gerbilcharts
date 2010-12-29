module GerbilCharts::SVGDC

# = SVGPolyLine
# A polyline, like the polygon class 
#
# Send this a series of lineto messages
#
class SVGPolyline < SVGShape
  
  attr_reader :operstring
  
  def initialize
    @operstring = ""
  end
  
  def lineto(x,y)
    fmt="%.2f"
    @operstring << "#{fmt%x},#{fmt%y} "
  end
  
  def render(xfrag)
    h= {:points => @operstring }
    xfrag.polyline( h.merge(render_attributes))
  end
  
end

end
