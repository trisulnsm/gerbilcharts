module GerbilCharts::Charts

# Matrix Chart
class ConversationRing < ChartBase
  
  def initialize(opt={})
    super(opt)
  end

  
  def create_chart_elements
    # filters if required 
    @thechart.create_filter(GerbilCharts::SVGDC::LinearGradientVertical.new("vertgrad","rgb(255,255,255)","rgb(224,224,224)"))

    # additional filter by name
    @thechart.create_filter(GerbilCharts::SVGDC::LikeButton.new('LikeButton')) if @gerbilfilter == 'LikeButton'   

 
    # other elements    
    @thechart.add_child(GerbilCharts::Surfaces::SurfaceBackground.new(:orient => ORIENT_OVERLAY))
    @thechart.add_child(GerbilCharts::Surfaces::TitlePanel.new(:orient => ORIENT_OVERLAY, :dim => 30))
    @thechart.add_child(GerbilCharts::Surfaces::ConversationRing.new(:orient => ORIENT_OVERLAY), :anchor => true)  
end



end



end
