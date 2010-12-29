module GerbilCharts::SVGDC

# = SVGText
# A line of text 
class SVGText < SVGElement
   
  attr_reader :x, :y, :str
  
  def initialize(x,y,str)
    super()
    @x,@y,@str=x,y,str
  end
  
  def render(xfrag)
    h= { :x => @x, :y => @y}
    render_base(xfrag) { xfrag.text(@str, h.merge(render_attributes)) }
  end
  
end

end
