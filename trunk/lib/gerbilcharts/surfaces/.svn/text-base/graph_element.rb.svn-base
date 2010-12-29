module GerbilCharts::Surfaces

# Graph - base for everything you place on the graph (all rectangular)
#
class GraphElement

  # constants 
  EXP_FIXED=1
  EXP_FILL=2

  # orientations
  ORIENT_NORTH=1
  ORIENT_SOUTH=2
  ORIENT_EAST=3
  ORIENT_WEST=4
  ORIENT_NORTHEAST=5
  ORIENT_NORTHWEST=6
  ORIENT_SOUTHEAST=7
  ORIENT_SOUTHWEST=8
  ORIENT_OVERLAY=9

  
  # public ro attributes
  attr_reader   :class
  attr_reader   :group
  attr_reader   :bounds
  attr_reader   :lay_orient
  attr_reader   :lay_expand
  attr_reader   :lay_dimension
  attr_reader   :parent
  
  def initialize( opt={} )
      @lay_orient= opt[:orient] if defined? opt[:orient]
      @lay_expand= opt[:expand] if defined? opt[:expand]
      @lay_dimension= opt[:dim] if defined? opt[:dim]
      @bounds = Rect.new
      if opt[:width] and opt[:height]
        @bounds.from_wh(opt[:width],opt[:height]) 
      end
      if opt[:class]
        @class=opt[:class]
      end
      @group="default"
	  @global_chart_options=opt
  end
  
  def needslayout?
    if @lay_orient 
      return true
    else
      return false
    end
  end
  
  def setparent(par)
      @parent=par
  end
  
  def isoverlay?
    if defined? @lay_orient and @lay_orient == ORIENT_OVERLAY
      return true
    else
        return false
    end
  end
  
  def scale_x val,range
    return @bounds.left + @bounds.width * range.scale_factor(val)
  end
  
  def scale_y val,range
  	return 0 if range.invalid?
    return @bounds.bottom - @bounds.height * range.scale_factor(val)
  end
  
  
  def setbounds rcbounds
    @bounds.initfrom rcbounds
  end

  # setup SVG group element and call int_render
  def render(sdc)
      sdc.newwin(@group) do |sdc|
			  int_render(sdc)
	  end
  end
  
  # render direct  - directly render SVG using builder for complex elements
  def render_direct(sdc)
      raise "This Graph Element cannot render directly, incorrect usage"
  end
  
  def munch(layrect)
    raise "Element does not need to be laid out" if not needslayout?
    
    @bounds.initfrom(layrect)
    case @lay_orient
      when ORIENT_SOUTH
            @bounds.clip_b @lay_dimension
            layrect.crop_b @lay_dimension
      when ORIENT_NORTH
            @bounds.clip_t @lay_dimension
            layrect.crop_t @lay_dimension
      when ORIENT_EAST
            @bounds.clip_r @lay_dimension
            layrect.crop_r @lay_dimension
      when ORIENT_WEST
            @bounds.clip_l @lay_dimension
            layrect.crop_l @lay_dimension
      when ORIENT_SOUTHEAST
            @bounds.clip_b @lay_dimension
            @bounds.clip_r @lay_dimension
      when ORIENT_NORTHEAST
            @bounds.clip_t @lay_dimension
            @bounds.clip_r @lay_dimension
      when ORIENT_SOUTHWEST
            @bounds.clip_b @lay_dimension
            @bounds.clip_l @lay_dimension
      when ORIENT_NORTHWEST
            @bounds.clip_t @lay_dimension
            @bounds.clip_l @lay_dimension
    end
    return layrect
  end
  
  def align_to_anchor(anc)
      case @lay_orient
      when ORIENT_SOUTH
            @bounds.left= anc.bounds.left
            @bounds.right=anc.bounds.right
      when ORIENT_NORTH
            @bounds.left= anc.bounds.left
            @bounds.right=anc.bounds.right
      when ORIENT_EAST
            @bounds.top= anc.bounds.top
            @bounds.bottom=anc.bounds.bottom
      when ORIENT_WEST
            @bounds.top= anc.bounds.top
            @bounds.bottom=anc.bounds.bottom
      when ORIENT_OVERLAY
            @bounds.initfrom anc.bounds
    end
  end

  # query a global option, return the defval if option is not set
  def get_global_option(optsym, defval)
		@global_chart_options.has_key?(optsym)? @global_chart_options[optsym]: defval 
  end
  
# utility methods to derived classes  
protected
  
  def max(a,b)
    return (a>b)?a:b
  end
  
  def min(a,b)
    return (a<b)?a:b
  end

  # random but consistent color for ID
  # depends on a lazily generated map of 100 colors 
  def color_for_id(id)
		@@mcolors ||= Array.new(100){ |t| "#%06x" % (rand * 0xffffff) }
		return @@mcolors[id]
  end

end

end

