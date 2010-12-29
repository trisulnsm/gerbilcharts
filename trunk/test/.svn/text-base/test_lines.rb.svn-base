require File.dirname(__FILE__) + '/test_helper.rb'

class TestLines  < Test::Unit::TestCase

   attr_reader  :test_vector_tm1
   attr_reader  :test_vector_tm2
   attr_reader  :mod1, :mod2, :modbucket1
  
   def setup
     @test_vector_tm1 = []
     @test_vector_tm3 = []
     tbeg = Time.local( 1978, "jun", 5, 9, 10, 0, 0)
     sbeg = tbeg
     sec_inc = 50
     
     for i in (0..20)
      @test_vector_tm1 << [sbeg + i*sec_inc, i*sec_inc*250*rand() ]
      @test_vector_tm3 << [sbeg + i*sec_inc, i*sec_inc*1000*rand() ]
    end

    @mod1 = GerbilCharts::Models::TimeSeriesGraphModel.new("External Gateway")
    @mod1.add_tuples @test_vector_tm1
  
    @mod3 = GerbilCharts::Models::TimeSeriesGraphModel.new("udldev Print Server")
    @mod3.add_tuples @test_vector_tm3
  
    @modgroup = GerbilCharts::Models::GraphModelGroup.new("Hosts")
    @modgroup.add(@mod3)
    @modgroup.add(@mod1)
    

   end
  

  # test a line chart
  def test_line_1
 
    mychart = GerbilCharts::Charts::AreaChart.new( :width => 750, :height => 250, 
				:javascripts => ['inline:gerbil.js' ],
				:auto_tooltips => false, :style => 'inline:brushmetal.css' )
    mychart.setmodelgroup(@modgroup)
    mychart.render('/tmp/sq_linechart1.svg')
    
  end   
   
end
