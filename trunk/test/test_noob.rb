require File.dirname(__FILE__) + '/test_helper.rb'

require './trafgen'

# tests some easy to use mods
# 	newbies enter here
class TestChartsNoob < Test::Unit::TestCase


  # test  sales figures of 3 sales people
  # use a simple timeseries model 
  def test_monthly_sales
 
    mychart = GerbilCharts::Charts::SquareLineChart.new( :width => 350, :height => 200, :style => 'inline:brushmetal.css',
						   :circle_data_points => true, :scaling_y => :auto,
						   :javascripts => ['/tmp/gerbil.js','/tmp/prototype.js'] )

    modelgroup = GerbilCharts::Models::SimpleTimeSeriesModelGroup.new( 
				   :title => "Sales figures",
				   :timeseries  =>  (1..6).collect { |month| Time.local(2008,month) },
				   :models =>       [ ["Bruce", 1,  10, 18, 28, 80,  122],
						      ["Rex"  , 112,22, 45, 70, 218, 309], 
						      ["Buzo" , 0,  23, 25, 40, 18,  59] 
									]
				 )

	mychart.modelgroup=modelgroup

    mychart.render('/tmp/n_monthly_sales.svg')
    
  end   
   
  # test  daily traffic
  def test_daily_traf_1
 
    mychart = GerbilCharts::Charts::ImpulseChart.new( :width => 450, :height => 200, :style => 'brushmetal.css')

	tend = Time.now
	tbegin = tend - 3600*24

	model1 = GerbilCharts::Models::BucketizedTimeSeriesGraphModel.new( "eth0", 3600 )
	TimeSeriesDataGenerator.new(tbegin,tend,300,200000, 6000000).each_tuple do |t,v|
		model1.add(t,v)
	end

	model2 = GerbilCharts::Models::BucketizedTimeSeriesGraphModel.new( "wan1", 3600 )
	TimeSeriesDataGenerator.new(tbegin,tend,300,200000, 6000000).each_tuple do |t,v|
		model2.add(t,v)
	end

    modelgroup = GerbilCharts::Models::GraphModelGroup.new( "External Traffic")
	modelgroup.add model2
#	modelgroup.add model1

	mychart.modelgroup=modelgroup
    mychart.render('/tmp/n_daily_traffic.svg')
    
	# demo resuses the model in a different view (an area chart this time)
    myareachart = GerbilCharts::Charts::AreaChart.new( :width => 450, :height => 200, :style => 'inline:brushmetal.css',
						       :scaling_y => :auto, :auto_tooltips => true ,
		                		       :javascripts => ['/tmp/gerbil.js' , '/tmp/prototype.js' ],
		                   		       :filter => 'LikeButton'  )
	myareachart.modelgroup=modelgroup
    myareachart.render('/tmp/n_daily_traffic_area.svg')

	# demo to reuse the model ina bar
    mybarchart = GerbilCharts::Charts::BarChart.new( :width => 450, :height => 200, :style => 'brushmetal.css', :auto_tooltips => true)
	mybarchart.modelgroup=modelgroup
    mybarchart.render('/tmp/n_daily_traffic_bar.svg')


	# demo stacked area
    mysachart = GerbilCharts::Charts::StackedAreaChart.new( :width => 450, :height => 200, :style => 'inline:brushmetal.css',
							    :scaling_y => :auto, :auto_tooltips => true ,
 		                		         :javascripts => ['/tmp/gerbil.js' , '/tmp/prototype.js' ])
	mysachart.modelgroup=modelgroup
    mysachart.render('/tmp/n_daily_traffic_sa.svg')


  end   

 
   
end


