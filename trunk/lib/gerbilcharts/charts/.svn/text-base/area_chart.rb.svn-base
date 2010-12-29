module GerbilCharts::Charts


# =Area Chart
# Draws each model in a shaded area. 
# We use a transparency to show hidden charts. Not the best looking, but has its uses.
#
class AreaChart < ChartBase

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
    @thechart.add_child(GerbilCharts::Surfaces::BasicGrid.new(:orient => ORIENT_OVERLAY))
    @thechart.add_child(GerbilCharts::Surfaces::TitlePanel.new(:orient => ORIENT_OVERLAY, :dim => 30))
    @thechart.add_child(GerbilCharts::Surfaces::AreaSurface.new(:orient => ORIENT_OVERLAY),:anchor => true)
    @thechart.add_child(GerbilCharts::Surfaces::Legend.new(:orient=> ORIENT_OVERLAY, :dim => @legend_width))  
    @thechart.add_child(GerbilCharts::Surfaces::DetailedLegend.new(:orient=> ORIENT_OVERLAY, :dim => 3*@legend_width))  
    @thechart.add_child(GerbilCharts::Surfaces::VerticalAxis.new(:orient => ORIENT_WEST, :dim => 40 ))
    @thechart.add_child(GerbilCharts::Surfaces::HorizontalTimeAxis.new(:orient => ORIENT_SOUTH, :dim => 25 ))
    
    # optional features
    if @feature_timetracker
        @thechart.add_child(GerbilCharts::Surfaces::Tracker.new(:orient => ORIENT_OVERLAY ))
    end
  end
  
end
   
end
