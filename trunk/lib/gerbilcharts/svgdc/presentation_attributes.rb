module GerbilCharts::SVGDC

# = PresentationAttribute
# Wrappers around some simple attributes like Pen and Brush
# For more complex ones, you can just attach the SVG definition to the object you are drawing
#
class PresentationAttribute
  
 attr_reader :color
  
 def initialize(opt) 
   @color=opt[:color]  if defined? opt[:color] 
 end
  
end


class PPen < PresentationAttribute
  
  attr_reader :width
  
  def initialize(opt={})
      super opt
      @width=opt[:width]  if defined? opt[:width] 
  end

  def render
    h={}
    h.store("stroke",       @color) if  @color
    h.store("stroke-width", @width) if  @width
    h
  end
  
end

class PBrush < PresentationAttribute
  
    def initialize(opt={})
      super opt
    end
    
    def render
      h={}
      h.store("fill",       @color) if  @color
      h
    end
end

end

