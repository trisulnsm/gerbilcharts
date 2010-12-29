module GerbilCharts::Charts

# =Compact bar chart
# Tighter layout than a regular bar chart. 
#
class BarChartCompact < ChartBase

  def initialize(opt={})
    super(opt)
  end
  
  def create_chart_elements
    
    # anchor (line surface)
    @thechart.create_filter(GerbilCharts::SVGDC::LinearGradientVertical.new("vertgrad","rgb(255,255,255)","rgb(224,224,224)"))
    
    # additional filter by name
    @thechart.create_filter(GerbilCharts::SVGDC::LikeButton.new('LikeButton')) if @gerbilfilter == 'LikeButton'

    # other elements
    @thechart.add_child(GerbilCharts::Surfaces::SurfaceBackground.new(:orient => ORIENT_OVERLAY))
    @thechart.add_child(GerbilCharts::Surfaces::TitlePanel.new(:orient => ORIENT_OVERLAY, :dim => 30, :just => :right))
    @thechart.add_child(GerbilCharts::Surfaces::BarSurface.new(:orient => ORIENT_OVERLAY),:anchor => true)
    @thechart.add_child(GerbilCharts::Surfaces::HorizontalNameAxis.new(:orient => ORIENT_SOUTH, :dim => 30, :stagger => 2 ))
  end
end


end
