module GerbilCharts::Charts

# =Line Chart
# Each model is a separate line.
#
# options
#
# [+width+]			Width of the chart (pixels)
# [+height+]		Width of the chart (pixels)
# [+style+]			Stylesheet file to be applied
#
# global visual options
# [+circle_data_points]	  draw a solid circle around each data point  
#
class LineChart < ChartBase

  def initialize(opt={})
    super(opt)
  end
  
  def create_chart_elements
	
    # anchor (line surface)
    @thechart.create_filter(GerbilCharts::SVGDC::LinearGradientVertical.new("vertgrad","rgb(255,255,255)","rgb(192,192,192)"))
    
    # other elements
    @thechart.add_child(GerbilCharts::Surfaces::SurfaceBackground.new(:orient => ORIENT_OVERLAY))
    @thechart.add_child(GerbilCharts::Surfaces::BasicGrid.new(:orient => ORIENT_OVERLAY))
    @thechart.add_child(GerbilCharts::Surfaces::TitlePanel.new(:orient => ORIENT_OVERLAY, :dim => 30))
    @thechart.add_child(GerbilCharts::Surfaces::LineSurface.new(:orient => ORIENT_OVERLAY),:anchor => true)
    @thechart.add_child(GerbilCharts::Surfaces::Legend.new(:orient=> ORIENT_OVERLAY, :dim => @legend_width))  
    @thechart.add_child(GerbilCharts::Surfaces::DetailedLegend.new(:orient=> ORIENT_OVERLAY, :dim => 3*@legend_width))
    @thechart.add_child(GerbilCharts::Surfaces::VerticalAxis.new(:orient => ORIENT_WEST, :dim => 40 ))
    @thechart.add_child(GerbilCharts::Surfaces::HorizontalTimeAxis.new(:orient => ORIENT_SOUTH, :dim => 25 ))
  end
end

end
