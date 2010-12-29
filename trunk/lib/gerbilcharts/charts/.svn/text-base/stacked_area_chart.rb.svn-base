module GerbilCharts::Charts

# = StackedAreaChart
# The models are stacked on top of each other !
#
class StackedAreaChart < ChartBase

  def initialize(opt={})
    super(opt)
  end
  
  def create_chart_elements
    
    # other elements
    @thechart.add_child(GerbilCharts::Surfaces::SurfaceBackground.new(:orient => ORIENT_OVERLAY))
    @thechart.add_child(GerbilCharts::Surfaces::StackedGrid.new(:orient => ORIENT_OVERLAY))
    @thechart.add_child(GerbilCharts::Surfaces::TitlePanel.new(:orient => ORIENT_OVERLAY, :dim => 30))
    @thechart.add_child(GerbilCharts::Surfaces::StackedAreaSurface.new(:orient => ORIENT_OVERLAY),:anchor => true)
    @thechart.add_child(GerbilCharts::Surfaces::Legend.new(:orient=> ORIENT_OVERLAY, :dim => @legend_width))  
    @thechart.add_child(GerbilCharts::Surfaces::DetailedLegend.new(:orient=> ORIENT_OVERLAY, :dim => 3*@legend_width))  
    @thechart.add_child(GerbilCharts::Surfaces::VerticalAxis.new(:orient => ORIENT_WEST, :dim => 40 , :cumulative => true ))
    @thechart.add_child(GerbilCharts::Surfaces::HorizontalTimeAxis.new(:orient => ORIENT_SOUTH, :dim => 25 ))

    # optional features
    if @feature_timetracker
        @thechart.add_child(GerbilCharts::Surfaces::Tracker.new(:orient => ORIENT_SOUTH, :dim => 10 ))
    end
  end
end

end

