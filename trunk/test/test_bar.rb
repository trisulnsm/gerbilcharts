require File.dirname(__FILE__) + '/test_helper.rb'

require 'trafgen'

# 	test pie chart 
class TestBar < Test::Unit::TestCase


  # test  sales figures of 3 sales people
  # show in a pie chart 
  def test_monthly_sales
    modelgroup = GerbilCharts::Models::SimpleTimeSeriesModelGroup.new( 
				   :title => "Sales figures",
				   :timeseries  =>  (1..6).collect { |month| Time.local(2008,month) },
				   :models =>       [ ["Bruce", 1,  10, 18, 28, 80,  140],
						      ["Rex"  , 112,22, 45, 70, 218, 309], 
						      ["Sharmila", 112,22, 45, 70, 218, 245], 
						      ["Wasim", 112,22, 45, 70, 218, 145], 
						      ["Buzo" , 0,  23, 25, 40, 18,  59], 
						      ["Vipin", 145,112, 22, 45, 18, 70],
						      ["covad11.covad.nc.us", 145,112, 22, 45, 18, 240],
						      ["very very very long name 9th item ", 145,112, 22, 45, 18, 45],
						      ["192.168.201.200 ", 145,112, 22, 45, 18, 15],
						      ["192.168.201.200 ", 145,112, 22, 45, 18, 15],
						      ["Others ", 145,112, 22, 45, 18, 15],
						      ["VIVEK", 145,112, 22, 45, 18, 170]
									]
				 )
   mychart = GerbilCharts::Charts::BarChart.new( :width => 300, :height => 200, 
					:style => 'inline:brushmetal.css', :auto_tooltips => true ,
					:javascripts => ['/tmp/gerbil.js', '/tmp/prototype.js'],
					:filter => 'LikeButton' 
				       	        )
    mychart.modelgroup=modelgroup
    mychart.render('/tmp/bar_monthly_sales.svg')
  end   
end


