module GerbilCharts::SVGDC

# = SVGPolygon
#
# A polygon identified by the operstring. Sorry this is not the best way to do it
# The oper string consists of M x y L x y style commands. See SVG spec.
# todo : accept an array of coords and automatically construct the oper string
#
class SVGPolygon < SVGShape

  attr_reader :operstring
  
  def initialize
    @operstring = ""
  end
  
  def addpoint(x,y)
    # truncate to 2 significant places (cuts down SVG size)
    xf,yf = "%.2f"%x, "%.2f"%y
    @operstring << "#{xf},#{yf} "
  end
  
  def render(xfrag)
    h= {:points => @operstring }
    xfrag.polygon( h.merge(render_attributes))
  end
  
  def isempty?
    return @operstring.length==0
  end
  
end


class SVGSquarizedPolygon < SVGPolygon


  def addpoint(x,y)
  	@lastpt ||= [] 
	
	unless @lastpt.empty?
			xf,yf = "%.2f"%x, "%.2f"%@lastpt[1]
			@operstring << "#{xf},#{yf} "
			xf,yf = "%.2f"%x, "%.2f"%y
			@operstring << "#{xf},#{yf} "
	end

	@lastpt = [x,y]
  end
  
end

end
