require File.dirname(__FILE__) + '/test_helper.rb'

class TestLines  < Test::Unit::TestCase

   attr_reader  :mod1, :mod2, :modbucket1
  
   def setup
     @test_vector_tm1 = []
     tbeg = Time.local( 1978, "jun", 5, 9, 10, 0, 0)
     sbeg = tbeg
     sec_inc = 50
     
     for i in (0..20)
      @test_vector_tm1 << [sbeg + i*sec_inc, i*sec_inc*250*rand() ]
    end

    @mod1 = GerbilCharts::Models::TimeSeriesGraphModel.new("External Gateway")
    @mod1.add_tuples @test_vector_tm1
  
    @modgroup = GerbilCharts::Models::GraphModelGroup.new("Hosts")
    @modgroup.add(@mod1)

   end
  

  # test a line chart
  def test_line_1
 
    mychart = GerbilCharts::Charts::AreaChart.new( :width => 450, :height => 250, :style => 'embed:brushmetal.css')
    mychart.setmodelgroup(@modgroup)
    mychart.render('/tmp/embed_style.svg')
    
  end   
   
end
