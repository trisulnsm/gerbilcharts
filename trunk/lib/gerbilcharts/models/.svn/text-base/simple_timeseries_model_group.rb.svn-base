module GerbilCharts::Models

# = SimpleTimeSeriesModelGroup 
# A quick way to create a model group and models using a single statement.
# This works if all models have data points at fixed times.
#
# Example code :
#
#   my_modelgroup = GerbilCharts::Models::SimpleTimeSeriesModelGroup.new 
#                   (
#   					:title => "Sales figures",
#  						:timeseries  =>  (1..6).collect { |month| Time.local(2008,month) },
#  						:models =>       [  ["Bruce", 1, 10, 18, 28, 80,  122],
#  											["Rex"  , 12,22, 45, 70, 218, 109],
#  											["Buzo" , 0, 23, 25, 40, 18,  59]   
#                                        ]
#					)
#  
#
class SimpleTimeSeriesModelGroup < GraphModelGroup

  attr_reader		:discrete_range
  
  # Create the model group
  #
  # [+title+]      The name of the modelgroup, shows up as chart title (eg, "Sales Figures")
  # [+timeseries+] An array of Time objects representing each datapoint
  # [+models+]	   An array of models (array of name followed by values) eg, [ "Bruce", 0.1, 2.3, etc]
  #
  # All three are required parameters. If you want more flexibility then use a GraphModelGroup
  # object directly. See SimpleTimeseriesModelGroup documentation for an example.
  #
  def initialize(opts)

  	raise "Required parameter :title missing" unless opts[:title]
  	raise "Required array parameter :timeseries missing" unless opts[:timeseries]
  	raise "Required models missing" unless opts[:models]

	super(opts[:title])

	# user supplied 
	tvals = opts[:timeseries]
	modelitems = opts[:models]

	# create a timeseries graph model using user supplied data
	modelitems.each do |mitem|
		mod = TimeSeriesGraphModel.new( mitem.shift )	
		mitem.each_with_index do | datapt, idx |
			mod.add(tvals[idx], datapt)	if idx < tvals.size
		end
		add(mod)
	end

	# a discrete range object 
	@discrete_range = DiscreteTimeRange.new(tvals)

  end

  # return a discrete range for the X items (timeseries)
  def effective_round_range_x
  	return @discrete_range
  end

  
end

end

