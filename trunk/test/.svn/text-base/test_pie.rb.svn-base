require File.dirname(__FILE__) + '/test_helper.rb'

require 'trafgen'

# 	test pie chart 
class TestPie < Test::Unit::TestCase


  # test  sales figures of 3 sales people
  # show in a pie chart 
  def test_monthly_sales
 

    modelgroup = GerbilCharts::Models::SimpleTimeSeriesModelGroup.new( 
				   :title => "Sales figures",
				   :timeseries  =>  (1..6).collect { |month| Time.local(2008,month) },
				   :models =>       [ ["Bruce", 1,  10, 18, 28, 80,  1340.7890]
						      #["Rex"  , 112,22, 45, 70, 218, 3098.98]
						     # ["Sharmila", 112,22, 45, 70, 218, 245] 
						      #["Wasim", 112,22, 45, 70, 218, 145], 
						     # ["Buzo" , 0,  23, 25, 40, 18,  59], 
						      #["Vipin", 145,112, 22, 45, 18, 70],
						     # ["label", 145,112, 22, 45, 18, 240],
						     # ["9th item ", 145,112, 22, 45, 18, 45],
						     # ["Others ", 145,112, 22, 45, 18, 15],
						     # ["VIVEK", 145,112, 22, 45, 18, 170]
									]
				 )

    mychart = GerbilCharts::Charts::PieChart.new( :width => 350, :height => 200, 
				:style => 'inline:brushmetal.css', :auto_tooltips => true ,
				:javascripts => ['/tmp/gerbil.js' , '/tmp/prototype.js' ],
				:filter => 'LikeButton' 
				)
    mychart.modelgroup=modelgroup
    mychart.render("/tmp/pie_monthly_sales.svg")
  end   
   
 
   
end


