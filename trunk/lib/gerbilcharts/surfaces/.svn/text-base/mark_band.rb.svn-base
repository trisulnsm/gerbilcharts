module GerbilCharts::Surfaces

# = MarkBand
# Mark out a rectangular area on the surface (eg, critical zone)
class MarkBand < GraphElement
    def initialize(opts={})
      @class = "markband"
      super(opts)
    end
    
    def int_render(g)

	return unless parent.modelgroup.has_x_markers?

        range_options_x = parent.get_global_option(:scaling_x,:auto)
        range_options_y = parent.get_global_option(:scaling_y,:auto)

        rx = parent.modelgroup.effective_range_x(range_options_x)
        ry = parent.modelgroup.effective_range_y(range_options_y)

        mx_arr = parent.modelgroup.x_markers

	band_r=@bounds.clone
	band_r.left = scale_x mx_arr[0],rx
	band_r.right = scale_x mx_arr[1],rx

        g.rectangle_r(band_r, {:class => 'x_mk'})

    end
end

end

