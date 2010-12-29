module GerbilCharts::SVGDC

# = SVGWin
# a conceptual window, maps to a 'g' element in the SVG spec
# allows you to layer or nest easily
#
class SVGWin < SVGElement
  attr_reader     :ops
  attr_reader     :transforms

  def initialize(name, opts={})

	# add default options first
    # by default windows will define fill = none and stroke = black
	
    add_options("id"=> name, "fill" => "none", "stroke" => "black" )

    add_options opts

    @ops=[]
	super()
  end
  
  def << (p)
    @ops << p
  end
  
  def add_transformation(t)
    @transforms=Array.new unless @transforms
    @transforms << t
  end
  
  def render(xfrag)
    h= {}
    
    if @transforms
        strt=""
        @transforms.each do |t|
          strt << t.render
        end
        h.store(:transform, strt)
    end
    
    xfrag.g(h.merge(render_attributes)) {
      @ops.each do |op|
         op.render(xfrag)
      end    
    }
  end
end

end
