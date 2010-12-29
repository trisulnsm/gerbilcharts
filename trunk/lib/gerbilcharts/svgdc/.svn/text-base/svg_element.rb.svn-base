module GerbilCharts::SVGDC

#  = SVGElement
#  Base class for all SVG shapes.
#  Contains rendering,  and svg presentation handling code
#  Note : the presentation as passed on as is to the SVG
class SVGElement
  attr_accessor    :custom_style
  attr_reader      :presentations
  attr_reader      :href
  
  
  def initialize()
    @presentations=Array.new

	# default fill and stroke (you can override it)
	@custom_attributes||={}

  end

  def has_presentations?
    defined? @presentations
  end
    
  def render_attributes
    h={}

    if has_presentations?
      @presentations.each do |p|
        h.merge!(p.render)
      end
    end

    if @custom_attributes 
      @custom_attributes.each_pair do |k,v|
        h.store( k, v) 
      end
    end
  
    return h
  end

  def add_presentation(p)
    @presentations << p
  end
  
  def add_options(opt)
    @custom_attributes = {} if not defined? @custom_attributes

    opt.each_pair do |k,v|
      @custom_attributes.store(k,v)
    end
    
    # treat the href custom attribute separately
    if @custom_attributes[:href]
      @href=@custom_attributes[:href]
      @custom_attributes.delete(:href)
    end
  end
  
  def set_id(css_id)
    add_options(:id=> css_id)
  end
  
  def set_class(css_class)
    add_options(:class=> css_class)
  end
  
  def set_href(url)
    @href=url
  end
  
  # base render allows for wrapping with a Anchor tag
  def render_base(xfrag)
    if @href
      xfrag.a("xlink:href" => @href, :target => "_top") {
        yield
      }
    else
      yield
    end
  end
  
end

end

