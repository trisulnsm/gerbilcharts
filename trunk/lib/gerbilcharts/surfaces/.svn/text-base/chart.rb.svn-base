module GerbilCharts::Surfaces

# == Chart - container class
# Base from which all chart are derived
class Chart < GraphElement

  attr_reader    :anchor
  attr_reader    :elements
  attr_reader    :needslayout
  attr_reader    :modelgroup
  attr_reader    :filters
  attr_reader    :href
  attr_reader    :stylesheets
  attr_reader    :javascripts
  attr_reader    :ajaxOptions
  attr_reader    :ajaxContext
  
  def initialize( opt={})
    super(opt)
    set_defaults
    @children  = []
    @filters = []
    @stylesheets = [opt[:style]]  || []
    @stylesheets.flatten!
    @javascripts = [opt[:javascripts]]  || []
    @javascripts.flatten!
    @needslayout=false
  end
  
  # We search for the javascript code in the javascripts directory
  # If you want to inline the javascript, pass "inline:gerbil.js"
  # default is linked 
  #
  def set_defaults
     @javascripts = [ "gerbil.js" ]
  end
  
  def set_modelgroup(g)
    @modelgroup=g
  end
  
  def usesAjax?
    if @ajaxOptions
      return true
    else
      return false
    end
  end
  
  def set_ajaxOptions(h)
    @ajaxOptions={} if @ajaxOptions == nil
    @ajaxOptions.merge!(h)
  end
  
  def set_ajaxContext(h)
    @ajaxContext={} if @ajaxContext == nil
    @ajaxContext.merge!(h)
  end
  
  
  def add_child(e,opts={})
      @children << e
      @needslayout=true
      e.setparent(self)
      set_anchor(e) if opts[:anchor]
  end
  
  def render(ropts={})
    svgdc = GerbilCharts::SVGDC::SVGDC.new(@bounds.width, @bounds.height)

	svgdc.enable_tooltips get_global_option(:auto_tooltips,false)
    
    dolayout if @needslayout

	# bail out of empty models quickly
	if @modelgroup.empty?
		svgdc.textout(@bounds.left + @bounds.width/2, @bounds.height/2,
						@modelgroup.empty_caption,{"text-anchor" => "middle", :class => "titletext"})
	else
		@children.each { |ch| ch.render(svgdc) }
	end

    
	# filters, javascripts, stylesheets 
    @filters.each     { |f| svgdc.add_filter(f) }
    @javascripts.each { |scr| svgdc.add_javascriptfile(scr) }
    @stylesheets.each { |css| svgdc.add_stylesheetfile(css) }  
    
    # set model hash, and other template contexts
    @ajaxContext.store(:axdigest,@modelgroup.models_digest) if @ajaxOptions
    svgdc.set_ajaxOptions(@ajaxOptions) if @ajaxOptions
    svgdc.set_ajaxContext(@ajaxContext) if @ajaxContext
    
    svgdc.render(ropts)
  end
  
  def getmodelgroup
    return @modelgroup
  end
  
  def create_filter(f)
    @filters << f
  end
  
  def sethref(h)
    @href=h
  end
  
protected
  def dolayout
      spare = Rect.new
      spare.from_wh @bounds.width,@bounds.height
      
      @children.each do |ch|
        spare=ch.munch spare
      end

      @anchor.setbounds spare
      
      @children.each do |ch|
        ch.align_to_anchor @anchor
      end
      
      @needslayout=false
  end

private
  def set_anchor(a)
    raise "Only one anchor element supported" if @anchor
    @anchor =a 
  end
end

end

