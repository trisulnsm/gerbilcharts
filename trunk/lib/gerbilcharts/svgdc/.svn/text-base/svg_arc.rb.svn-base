module GerbilCharts::SVGDC

# = SVGARC - a simple elliptical arc
#
class SVGArc < SVGShape
  
  attr_accessor :cx,:cy
  attr_accessor :px,:py
  attr_accessor :qx,:qy
  attr_accessor :r1,:r2
  attr_accessor :angle

  

  # cx,cy = center point
  # r1,r2 = radius 1, 2
  # px,py = starting point
  # qx,qy = ending  point
  #
  # To create rectangle top left corner at (10,10) and width 200,height 100 do :
  #  SVGRect.new (10,10,200,150) 
  def initialize(cx,cy,r1,r2,px,py,qx,qy,angle)
      @cx,@cy,@r1,@r2,@px,@py,@qx,@qy=cx,cy,r1,r2,px,py,qx,qy
      @angle=angle
      super()
  end
  
  def render(xfrag)
    d_str = "M#{cx},#{cy}  L#{px},#{py} A#{r1},#{r2} 0 #{anglestr}  #{qx},#{qy} "
    h= { :d =>  d_str }
    render_base(xfrag) { xfrag.path( h.merge(render_attributes)) }
  end

  def anglestr
	angle >= 180 ? "1,1" : "0,1"
  end
  
end

end
