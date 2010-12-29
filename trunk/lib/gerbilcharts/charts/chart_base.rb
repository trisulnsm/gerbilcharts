module GerbilCharts::Charts

# =Chart base - sets up a container for surfaces
#
# You can put together various chart elements and create your own
# chart types. In  fact, all the charts in this module are nothing 
# but a composition of various surfaces
#
# The logic goes something like this :
# 1. A reddish gradient background
# 2. A stacked area surface to represent our data
# 3. Title overlay
# 4. Vertical labels on WEST
# 5. Horiz labels on SOUTH
# 6. Legend on EAST
#
# *A note on stylesheets*
#
# GerbilCharts uses a color scheme from a stylesheet.
# The stylesheets contain the coloring for each model.
#
# Options common for all charts
#
# [+:width+]	   Width of the generated SVG chart in pixels
# [+:height+]	   Height of the generated SVG chart in pixels
# [+:style+]	   CSS Stylesheet to use for the chart (default = brushmetal.css see public gem directory)
#				   Use "inline:css_name" to embed the stylesheet inline  default is to use xref
# [+:scaling_x+]   Allowed values are :auto, :auto_0, and an array [min,max] (default = :auto)
# [+:scaling_y+]   Allowed values are :auto, :auto_0, and an array [min,max] (default = :auto)
# [+:circle_data_points+] Draws a tiny circle around datapoints for tooltips
# [+:enabletimetracker+] Time tracker  javascript selector  (default = false)
#
class ChartBase


  # orientations (same as Surfaces::) 
  ORIENT_NORTH=1
  ORIENT_SOUTH=2
  ORIENT_EAST=3
  ORIENT_WEST=4
  ORIENT_NORTHEAST=5
  ORIENT_NORTHWEST=6
  ORIENT_SOUTHEAST=7
  ORIENT_SOUTHWEST=8
  ORIENT_OVERLAY=9
  ORIENT_OVERLAY_NORTH=10
  ORIENT_OVERLAY_SOUTH=11


  attr_reader     :thechart
  attr_reader     :renderopts
  attr_reader     :feature_timetracker
  attr_reader	  :legend_width
  
  def initialize(opt={})
  
    # suck out local options
    @enabletimetracker=false
    if opt[:enabletimetracker]
        @feature_timetracker=opt[:enabletimetracker]
        opt.delete :enabletimetracker
    end
    
    # pass on options to chart object
    @thechart = GerbilCharts::Surfaces::Chart.new(opt)
    @renderopts = {}

	# common relative widths
	@legend_width = [opt[:width]/4,100].max

	@gerbilfilter = opt[:filter] || ""
  end

  def set_renderoptions=(opts)
  	@renderopts.merge!(opts)
  end
  
  def setmodelgroup(themodel)
    @thechart.set_modelgroup(themodel)
    
    # automatically set hrefs
    if themodel.hasHref?
      sethref(themodel.href)
    end
  end

  def modelgroup=(themodelgroup)
	setmodelgroup(themodelgroup)
  end
  
  # render options
  #   :file => filename
  #   :string => return a string
  def render_base
    create_chart_elements
    @thechart.render(@renderopts)
  end
  
  def render(outfile)
    @renderopts.merge!( :file => outfile )
    render_base
  end
  
  def render_all(opts)
    @renderopts.merge!(opts)  
    render_base
  end
  
  # render xfrag
  def render_frag(xfrag)
    @renderopts.merge!( :xfrag => xfrag )
    render_base
  end
  
  # render string
  def render_string
    @renderopts.merge!( :string => "" )
    render_base
	@renderopts[:string]
  end
  
  # click chart title to go somewhere else
  def sethref(href)
    @thechart.sethref(href)
  end
  
  # all sub charts override this to create custom layouts
  def create_chart_elements
        
  end
  
  # Ajax options (callback frequecy, URL, etc)
  def setAjaxOptions(h)
    @thechart.set_ajaxOptions(h)
  end

  # Ajax context (custom parameters required by server)
  def setAjaxContext(h)
    @thechart.set_ajaxContext(h)
  end
end

end

