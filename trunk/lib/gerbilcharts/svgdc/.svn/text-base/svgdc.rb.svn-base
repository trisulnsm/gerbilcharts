module GerbilCharts::SVGDC

require 'rubygems'
gem 'builder'
require 'builder'

# =SVGDC
#
# Simulates a simple Device Context like CDC in MFC/Windows
#
# ==  A simple example
# Create a 500x400 window, draw a circle, draw 10 rectangles and save it !
#
#     g=SVGDC.new(500,400)
#     g.circle(40,50,20)
#     1.upto(10) do |w|
#     		g.rectangle(80+w*4,10,10*w,45)
#     end
#     g.render("/tmp/tbasic1.svg")
#
class SVGDC
  
  attr_accessor     :width
  attr_accessor     :height
  attr_reader       :curr_win, :base_win
  attr_reader	    :curr_presentation_context
  attr_reader       :svg_predefs
  attr_reader       :svg_styles
  attr_reader       :ref_styles
  attr_reader       :svg_javascript
  attr_reader       :ref_javascripts
  attr_reader       :ajaxOptions
  attr_reader       :ajaxContext
  attr_reader       :use_tooltips
  attr_reader		:embed_style
  
  def initialize(w,h)
    @width,@height=w,h
    @ops = Array.new
    @curr_presentation_context={}
    @base_win=SVGWin.new("Gerbil_Root_Window")
    setactivewindow(@base_win)
    @svg_predefs = [] 
    @use_tooltips=true
	@embed_style=false
  end
  
  # ==Note on Stylesheet
  # 	Searches for the stylesheet in the current directory or in the gerbilcharts/public directory
  # 	If you want to use your own stylesheets put them in the working directory, or in the
  # 	public directory of gerbilcharts.
  # To inline stylesheet use "inline:<stylesheetname>" , eg "inline:brushmetal.css"
  # To embed stylesheet use "embed:<stylesheetname>" , eg "embed:brushmetal.css"
  # Default is to xref a stylesheet 
  def add_stylesheetfile(cssfile_in)
  	return unless cssfile_in
  	cssfile=cssfile_in.gsub(/^inline:/,'')
	if cssfile.length <  cssfile_in.length
   	    @svg_styles = get_file_content(cssfile)
	else
  		cssfile=cssfile_in.gsub(/^embed:/,'')
		if cssfile.length < cssfile_in.length
   	    	@svg_styles = get_file_content(cssfile)
			@embed_style = true
		else
			@ref_styles ||= []
			@ref_styles << cssfile 
		end
	end
  end
  
  # To inline javascript use "inline:<javascript-file-name>"
  #
  def add_javascriptfile(jsfile_in)
  	return unless jsfile_in
  	jsfile=jsfile_in.gsub(/^inline:/,'')
	if jsfile.length <  jsfile_in.length
	      @svg_javascript ||= ""  
	      @svg_javascript << get_file_content(jsfile)      
	else
	      @ref_javascripts ||= [] 
	      @ref_javascripts << jsfile
	end
  end

  def enable_tooltips(bval)
    @use_tooltips=bval
  end
  
  def requires_ajax_block?
    if @ajaxOptions.nil? and @ajaxContext.nil?
      return false
    else
      return true
    end
  end
  
  def requires_tooltips?
    return @use_tooltips
  end
 
  def set_ajaxContext(h)
    @ajaxContext=h
  end
  
  def set_ajaxOptions(h)
    @ajaxOptions=h
  end
  
  def add_filter(filter)
    @svg_predefs << filter
  end
  
  # create a new window ,
  # all subsequent operations work on this new window 
  def newwin(name, opts={})
    w=SVGWin.new(name, opts)
    @curr_win << w
	@curr_win = w
	yield self  if block_given?
	reset if block_given?
	return w if not block_given?
  end
  
  def reset
  	@curr_win = @base_win
  end

  def setactivewindow(w=nil)
    @curr_win = w ? w : @base_win
  end
  
  # render to XML Builder fragment
  def render_to_frag(doc,opts)
    
       # if options has windowonly option, then just render the top most window 
       if opts[:windowonly] 
         # render contents of top window
         doc.g(:id => "GerbilSVGGraph") {
             @curr_win.render(doc)
         }        
         return
       end
    
    
       # svg base attributes
       svg_attributes = {:xmlns => "http://www.w3.org/2000/svg", 
	   					 "xmlns:xlink" => "http://www.w3.org/1999/xlink", 
						 :version => "1.1", :width => @width, :height => @height}

	   # hook up javascript support 
       if requires_ajax_block? or requires_tooltips?
         svg_attributes.store(:onload,"Init(evt)") 
		 svg_attributes.store(:onunload,"Uninit(evt)")
       end
       
       doc.svg(svg_attributes)   {
       
       # stylesheet (inlined into SVG)
       doc.style(@svg_styles, :type => "text/css")  if @svg_styles and not @embed_style
    
       # javascripts (ajax, etc) hrefed
       @ref_javascripts &&   @ref_javascripts.each do |scr|
           doc.script(:type => "text/javascript", "xlink:href" => scr)
       end
    
       # javascript inlined again
       if @svg_javascript
         doc.script(:type => "text/javascript") { doc.cdata!(@svg_javascript) }
       end
        
       # defs (all image filters go here)
       doc.defs() {
         @svg_predefs.each do |filter|
           filter.render(doc)
         end
       }
       
       # Ajax block (for gerbilAjax.js library)
       if requires_ajax_block?
         doc.g(:id => "GerbilAjaxBlock") {
            
            ao = {:id => "GerbilAjaxOptions"}
            @ajaxOptions.each_pair do |k,v|
              ao.store(k,v)
            end
            doc.g(ao)
            
            if @ajaxContext
              ac = {:id => "GerbilAjaxContext"}
              @ajaxContext.each_pair do |k,v|
                ac.store(k,v)
              end
              doc.g(ac)
            end
         }
       end
       
       # render contents of top window
       doc.g(:id => "GerbilSVGGraph") {
           @curr_win.render(doc)
       }
       
       # render tooltips optional
       if @use_tooltips
          doc.g(:id=>'ToolTip', :opacity=>'0.8', :visibility=>'hidden', "pointer-events"=>'none') {
              doc.rect(:id=>'tipbox', :x=>'0', :y=>'5', :width=>'88', :height=> '40', :rx=> '2', :ry=> '2', :fill=>'white', :stroke=>'black')
              doc.text(:id=>'tipText', :x=>'5', :y=>'20', "font-family"=> 'Arial', "font-size"=>'12') {
                doc.tspan(:id=>'tipTitle', :x=>'5', "font-weight"=>'bold') {
                  doc.cdata!("")
                }
                doc.tspan(:id=>'tipDesc', :x=>'5', :dy=> 15,  "fill"=>'blue') {
                  doc.cdata!("")
                }
              }
          }
       end
     }      

	 # convert external stylesheet css to inline styles
	 
  end
  
  # render the SVG fragments to a string
  # options
  def render_to_string(opts={})
   
   # render all the elements accumulated so far
   svg_string=""
   doc = Builder::XmlMarkup.new(:target => svg_string, :indent => 2, :standalone => "no")
   doc.instruct!
   doc.declare! :DOCTYPE, :svg, :PUBLIC,"-//W3C//DTD SVG 1.1//EN","http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"

   # stylesheet instruction if hreferenced
   if @ref_styles
	@ref_styles.each do |css|
	   doc.instruct! "xml-stylesheet",  :href => css, :type => "text/css"
	end
   end
   
   render_to_frag(doc,opts)
   
   # return the svg_string (inline if embedding desired)
   return @embed_style ?  do_embed_styles(svg_string) : svg_string

  end
  
  # render the SVG to a file
  def render_to_file(outpath,opts={})
    svg_string = render_to_string(opts)
    File.open(outpath, 'w') { |file|
       file.write(svg_string)
    } 
  end
  
  # synonym for render_to_file with no options
  def render(opts={})
      opts[:string]=render_to_string(opts) if opts[:string]
      render_to_file(opts[:file],opts)     if opts[:file]
      render_to_frag(opts[:xfrag],opts)  if opts[:xfrag]
  end
  
  # prime the graphics object 
  def prime_object(gobj, opt)
    add_selected_presentations(gobj)
    add_options(gobj,opt)
    gobj
  end
  
  # add presentation attributes
  def add_selected_presentations(gobj)
    @curr_presentation_context.each do |k,v|
      gobj.add_presentation v
    end
  end
  
  # add other options (eg, CSS class)
  def add_options(gobj, opt)
    gobj.add_options(opt)
    gobj
  end
  
  # add a shape directly with options
  def addshape(shape,opt={})
      @curr_win << prime_object(shape,opt)
  end
  
  def circle(x,y,r,opt={})
    @curr_win << prime_object(SVGCircle.new(x,y,r),opt)
  end
  
  def moveto(x,y)
    @curr_polyline=SVGPolyline.new
    @curr_polyline.lineto(x,y)
  end
  
  def lineto(x,y)
    @curr_polyline=SVGPolyline.new if not @curr_polyline
    @curr_polyline.lineto(x,y)
  end
  
  def endline(opt={})
    if @curr_polyline
      @curr_win << prime_object(@curr_polyline,opt)
    end
    @curr_polyline=nil
  end
  
  def begin_polygon
    @curr_polygon=SVGPolygon.new
  end
  
  def polygon_point(x,y)
  	  @curr_polygon ||= SVGPolygon.new
      @curr_polygon.addpoint(x,y)
  end
  
  def end_polygon(opt={})
      @curr_win << prime_object(@curr_polygon,opt)
      @curr_polygon=nil
  end
  
  
  def line(x1,y1,x2,y2, opt={})
    @curr_win << prime_object(SVGLine.new(x1,y1,x2,y2), opt)
  end
  
  def textout(x,y,str, opt={})
    @curr_win << prime_object(SVGText.new(x,y,str), opt)
  end

  # utility method
  # 	automatically adds the 'font-family: monospace" , "stroke :none", "fill: black"
  # 	they can all be overridden by passing in an opt
  #
  def textout_monospace(x,y,str,opt={})
  	defopt = { "font-family" => "monospace", "stroke" => "none", "fill" =>  "black" }
	defopt.merge!(opt) if opt

	textout(x,y,str,defopt)

  end


  def rectangle(x,y,w,h, opt={})
    @curr_win << prime_object(SVGRect.new(x,y,w,h), opt)
  end
  
  def rectangle_r(r, opt={} )
    rectangle(r.left, r.top, r.width, r.height, opt)
  end
  
  def circle_r(r, opt={} )
    circle( (r.left + r.right)/2, (r.bottom+r.top)/2, [r.width,r.height].min/2, opt)
  end
  
  def select_presentation(opt={})
    @curr_presentation_context.store(:pen,opt[:pen])      	if opt[:pen]
    @curr_presentation_context.store(:brush,opt[:brush])      if opt[:brush]
  end

  def clear_presentation
  	@curr_presentation_context = []
  end
  
private

  # search for the file in the current directory or the gem path
  def  get_file_content(fname)
		if File.exists? fname
		   return File.read(fname)
		else
		   try_from_gem = File.dirname(__FILE__) + "/../public/" + fname
		   return File.read(try_from_gem) if File.exists? try_from_gem
		end
	   raise "Resource #{fname} not found in current directory or in the gerbilcharts/public folder"
  end

  # external styles to  inline (for svg_web)
  def do_embed_styles(svgdoc_string)

  	if @ref_styles
		css_string = File.read('@ref_styles')
	else
		css_string = @svg_styles
	end

	css_inliner = GerbilCharts::SVGDC::CssInliner.new(css_string)
	return css_inliner.inline_doc(svgdoc_string)

  end



end

end
