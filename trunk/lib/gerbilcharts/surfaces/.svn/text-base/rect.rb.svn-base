module GerbilCharts::Surfaces

# = Rect
# Utility class for manipulations on a rectangle
#
class Rect

  attr_accessor :left, :top, :right, :bottom
  
  def initialize()
    @left,@top,@right,@bottom=0,0,0,0
  end
  
  def from_wh(w,h)
    @left=0
    @right=w
    @top=0
    @bottom=h
  end
  
  def deflate_h(l,r)
    @left += l
    @right -= r
  end
  
  def deflate_v(t,b)
    @top += t
    @bottom -= b
  end

  def deflate(n)
	@left+=n
	@top+=n
	@bottom-=n
	@right-=n
  end
  
  def initfrom(r)
      @left=r.left
      @right=r.right
      @top=r.top
      @bottom=r.bottom
  end
  
  def clip_b(dim)    
      @top=@bottom-dim
  end
  
  def clip_t(dim)
      @bottom=@top+dim
  end
  
  def clip_l(dim)
      @right=@left+dim
  end

  def clip_r(dim)
      @left=@right-dim
  end

  def crop_b(dim)
      @bottom=@bottom-dim
  end
  
  def crop_t(dim)
      @top=@top+dim
  end
  
  def crop_l(dim)
      @left=@left+dim
  end

  def crop_r(dim)
      @right=@right-dim
  end
  
  def width
      @right-@left
  end
  
  def height
      @bottom-@top
  end

  def translate_x(newx)
	w=width
	@left=newx
	@right=@left+w
  end

  def offset_x(delta)
	@left+=delta
	@right+=delta
  end
    
 
  def to_s
    "#{@left},#{@top} [w=#{width} h=#{height}]"
  end
  
end

end

