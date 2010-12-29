module GerbilCharts::SVGDC

# =SVGCustomWin
# custom window, the supplier delegate will render the SVG directly using the Builder facilities
# use this for complex SVG elements that cant be handled via the current simplistic GDI like operations
#
class SVGCustomWin < SVGWin

  attr_reader   :render_delegate

  def initialize(name,delegate,opts={})
    @render_delegate=delegate
    super(name,opts)
  end

  def <<(p)
    raise "Cannot add children to a custom SVG Window"
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
        @render_delegate.render_direct(xfrag)
    }
  end
end

end
