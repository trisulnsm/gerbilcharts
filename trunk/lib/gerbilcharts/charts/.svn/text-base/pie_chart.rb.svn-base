module GerbilCharts::Charts

# = Pie chart
# A standard pie  chart. 
# The latest values of each model is presented as a slice
#
class PieChart < ChartBase



  def initialize(opt={})
    super(opt)

	
  end
  
  def create_chart_elements
    
	# filters if required 
    @thechart.create_filter(GerbilCharts::SVGDC::LinearGradientVertical.new("vertgrad",
																	"rgb(255,255,255)","rgb(224,224,224)"))

    # additional filter by name
    @thechart.create_filter(GerbilCharts::SVGDC::LikeButton.new('LikeButton')) if @gerbilfilter == 'LikeButton'


    # other elements
    @thechart.add_child(GerbilCharts::Surfaces::SurfaceBackground.new(:orient => ORIENT_OVERLAY))
    @thechart.add_child(GerbilCharts::Surfaces::TitlePanel.new(:orient => ORIENT_OVERLAY, :dim => 30, 
																:just => :left))
    @thechart.add_child(GerbilCharts::Surfaces::PieSurface.new(:orient => ORIENT_OVERLAY), :anchor => true)
  end
end


end
