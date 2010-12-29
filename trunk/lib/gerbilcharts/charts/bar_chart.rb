module GerbilCharts::Charts

# =Bar Chart
# A standard bar chart. 
# The latest values of each model is presented as a separate bar.
#
class BarChart < ChartBase

  attr_reader       :staggerlabels
  
  def initialize(opt={})
    super(opt)
    
    @staggerlabels =  optimum_stagger(opt[:width])
    @staggerlabels = opt[:stagger] if opt[:stagger]
  end

  
  def create_chart_elements
    
    # anchor (line surface)
    @thechart.create_filter(GerbilCharts::SVGDC::LinearGradientVertical.new("vertgrad","rgb(255,255,255)","rgb(224,224,224)"))

    # additional filter by name
    @thechart.create_filter(GerbilCharts::SVGDC::LikeButton.new('LikeButton')) if @gerbilfilter == 'LikeButton'
    
    # other elements
    @thechart.add_child(GerbilCharts::Surfaces::SurfaceBackground.new(:orient => ORIENT_OVERLAY))
    @thechart.add_child(GerbilCharts::Surfaces::TitlePanel.new(:orient => ORIENT_OVERLAY, :dim => 30, :just => :right))
    @thechart.add_child(GerbilCharts::Surfaces::BarSurface.new(:orient => ORIENT_OVERLAY), :anchor => true)
    @thechart.add_child(GerbilCharts::Surfaces::VerticalAxis.new(:orient => ORIENT_WEST, :dim => 40 ))
    @thechart.add_child(GerbilCharts::Surfaces::HorizontalNameAxis.new(:orient => ORIENT_SOUTH, :dim => (15 * @staggerlabels.to_i), :stagger => @staggerlabels))
  end


  protected

	# compute the optimum stagger level based on the width of the bar chart so we
	# do not have nasty overlaps atleast when labels are 15 chars wide (eg, big ip address)
	def optimum_stagger(width)
		case width
			when (0..250); return 4
			when (250..350); return 3
			when (350..600); return 2
			else; return 1
		end
	end

end



end
