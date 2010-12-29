require File.dirname(__FILE__) + '/test_helper.rb'

require 'trafgen'

# test if render to string works correctly
class TestRenderString  < Test::Unit::TestCase


  # test  sales figures of 3 sales people
  # use a simple timeseries model 
  # output to string finally
  def test_string_render
 
    mychart = GerbilCharts::Charts::LineChart.new( :width => 350, :height => 200, :style => 'brushmetal.css',
												   :circle_data_points => true )

    modelgroup = GerbilCharts::Models::SimpleTimeSeriesModelGroup.new( 
				   :title => "Sales figures",
				   :timeseries  =>  (1..6).collect { |month| Time.local(2008,month) },
				   :models =>       [ ["Bruce", 1,  10, 18, 28, 80,  122],
									  ["Rex"  , 112,22, 45, 70, 218, 309], 
									  ["Buzo" , 0,  23, 25, 40, 18,  59] 
									]
				 )

	mychart.modelgroup=modelgroup

	strout =  mychart.render_string

	# a large enough string (basic test a large enough string generated)
	assert strout.size > 1000 

	# the string SVG is present in the out (very basic test)
	assert strout.match("SVG")
  end   

end

