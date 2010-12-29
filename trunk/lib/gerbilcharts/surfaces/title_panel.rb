module GerbilCharts::Surfaces

# == TitlePanel
#   just  - left or right justify the title
class TitlePanel < Panel

    attr_accessor   :just
    
    def initialize(opts={})
      @class = "titlepanel"
      @just  = :left
      @just  = opts[:just] if opts[:just]
      
      super(opts)
    end
    
    def int_render(g)
      opts = {:class => "titletext"}
      opts.store(:href, @parent.href) if @parent.href
      
      if @just == :left
        g.textout(@bounds.left, @bounds.top+16,  parent.modelgroup.name, opts)
      else
        g.textout(@bounds.right, @bounds.top+16, parent.modelgroup.name, opts.merge("text-anchor" => "end"))
      end
      
	  xoff=0
      parent.get_global_option(:toolhrefs,[]).each do  |tool|
     	topts = {:class => "titletool"}
        g.textout(@bounds.left + xoff, @bounds.top+29, tool[0] , topts.merge(:href => tool[1]) )
		xoff =xoff+ 7*(tool[0].length )
      end
    end
    
    def align_to_anchor(anc)
      super
      @bounds.deflate_v(4,4)
      @bounds.deflate_h(2,2)
      
      if @width
        @bounds.bottom= @bounds.top + @lay_dimension
      end
      
    end

end


end
