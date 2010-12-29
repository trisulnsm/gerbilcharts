require File.dirname(__FILE__) + '/test_helper.rb'

require 'trafgen'

#  Test scaling options :auto, :auto_0, [min,max]

class TestChartsScaling < Test::Unit::TestCase


  # test scaling  
  def test_scale_1
 
	tend = Time.now
	tbegin = tend - 3600*24

	# random between 2M and 6M
	model1 = GerbilCharts::Models::BucketizedTimeSeriesGraphModel.new( "eth0", 3600 )
	TimeSeriesDataGenerator.new(tbegin,tend,300,2000000, 6000000).each_tuple do |t,v|
		model1.add(t,v)
	end

	# random between 4M and 10M
	model2 = GerbilCharts::Models::BucketizedTimeSeriesGraphModel.new( "wan1", 3600 )
	TimeSeriesDataGenerator.new(tbegin,tend,300,4000000, 10000000).each_tuple do |t,v|
		model2.add(t,v)
	end

    modelgroup = GerbilCharts::Models::GraphModelGroup.new( "External Traffic")
	modelgroup.add model2
	modelgroup.add model1

    
	#  area chart with auto scaling 
    myareachart = GerbilCharts::Charts::AreaChart.new( :width => 450, :height => 200, :style => 'brushmetal.css',
		:scaling_y => :auto )
	myareachart.modelgroup=modelgroup
    myareachart.render('/tmp/n_scale_auto.svg')

	#  line chart with auto_0 scaling 
    myareachart = GerbilCharts::Charts::LineChart.new( :width => 450, :height => 200, :style => 'brushmetal.css',
		:scaling_y => :auto_0 )
	myareachart.modelgroup=modelgroup
    myareachart.render('/tmp/n_scale_auto_0.svg')

	#  impulse chart with manual scaling 
     myareachart = GerbilCharts::Charts::ImpulseChart.new( :width => 450, :height => 200, :style => 'brushmetal.css',
	 	:scaling_y => [2000000,8000000]  )
	 myareachart.modelgroup=modelgroup
     myareachart.render('/tmp/n_scale_manual.svg')

  end   

 
   
end


