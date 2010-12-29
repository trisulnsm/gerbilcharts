module GerbilCharts::SVGDC


# = Transformations
# like translate, rotate, scale, etc
#
class Transformations
 
 def render
   h = {}
   h
 end

end

class TTranslate < Transformations
  
  attr_accessor :tx,:ty
  
  def initialize(tx,ty)
    super()
    @tx,@ty=tx,ty
  end
  
  def render
    "translate(#{@tx} #{@ty}) "
  end
end

class TRotate < Transformations
  
  attr_accessor :radians
  
  def initialize(angle)
    super()
    @radians=angle
  end
  
  def render
    "rotate(#{@radians}) "
  end
end


class TScale < Transformations
  
  attr_accessor :sx, :sy
  
  def initialize(x,y=0)
    super
    @sx=x
    @sy=y if y>0
  end
  
  def render
    if @sy
      "scale(#{@sx} #{@sy} "
    else
      "scale(#{@sx} "
    end
  end
  
end

end

