module GerbilCharts::Surfaces

# Stacked Grid - grid overlay
# Used for stacked area surface. Maps the sum of the model values
class StackedGrid < Grid
    
  protected
    def grid_range_y
      return parent.modelgroup.cumulative_sweep_round_range_y0
    end
end

end
