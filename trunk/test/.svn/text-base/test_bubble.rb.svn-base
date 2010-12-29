require File.dirname(__FILE__) + '/test_helper.rb'

require 'trafgen'

# tests some easy to use mods
# 	newbies enter here
class TestChartsNoob < Test::Unit::TestCase


  # alerts 
  def test_alerts
 
    mychart = GerbilCharts::Charts::BubbleChart.new( :width => 650, :height => 200, 
														 :style => 'inline:brushmetal.css', 
						   							    :javascripts => ['inline:/tmp/gerbil.js','inline:/tmp/prototype.js'] )


	tend = Time.now
	tbegin = tend - 3600*24

	model1 = GerbilCharts::Models::BucketizedTimeSeriesGraphModel.new( "eth0", 3600 )
	TimeSeriesDataGenerator.new(tbegin,tend,300,1000, 5000 ).each_tuple do |t,v|
		model1.add(t,v)
	end

	model2 = GerbilCharts::Models::BucketizedTimeSeriesGraphModel.new( "wan1", 3600 )
	TimeSeriesDataGenerator.new(tbegin,tend,300,2, 20).each_tuple do |t,v|
		model2.add(t,v)
	end

	model3 = GerbilCharts::Models::BucketizedTimeSeriesGraphModel.new( "fiber0", 3600 )
	TimeSeriesDataGenerator.new(tbegin,tend,1800,0, 10).each_tuple do |t,v|
		model3.add(t,v)
	end

    modelgroup = GerbilCharts::Models::GraphModelGroup.new( "External Traffic")
	modelgroup.add model2
	modelgroup.add model1
	modelgroup.add model3


	mychart.modelgroup=modelgroup

    mychart.render('/tmp/n_bubble.svg')
    
  end   
   

   
end


