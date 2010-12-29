module GerbilCharts::SVGDC

# = SVGRect - a simple rectangle
#
class SVGRect < SVGShape
  
  attr_accessor :x,:y,:w, :h
  

  # x = x position
  # y = y position
  # w = width
  # h = height 
  #
  # To create rectangle top left corner at (10,10) and width 200,height 100 do :
  #  SVGRect.new (10,10,200,150) 
  def initialize(x,y,w,h)
    @x,@y,@w,@h=x,y,w,h
    super()
  end
  
  def render(xfrag)
    h= { :x => @x, :y => @y, :width => @w, :height => @h }
    render_base(xfrag) { xfrag.rect( h.merge(render_attributes)) }
  end
  
end

end
