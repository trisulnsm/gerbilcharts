require "test/unit"
require "gerbilcharts"

class TCharts < Test::Unit::TestCase
  
   attr_reader  :test_vector_tm1
   attr_reader  :test_vector_tm2
   
   attr_reader  :mod1, :mod2, :modbucket1
  
   def setup
     @test_vector_tm1 = []
     @test_vector_tm2 = []
     @test_vector_tm3 = []
     tbeg = Time.local( 1978, "jun", 5, 9, 10, 0, 0)
     sbeg = tbeg.tv_sec
     sec_inc = 1000
     
     for i in (0..20)
      @test_vector_tm1 << [sbeg + i*sec_inc, i*sec_inc*1000 ]
      @test_vector_tm2 << [sbeg + i*sec_inc, i*sec_inc*1200 ]
      @test_vector_tm3 << [sbeg + i*sec_inc, i*sec_inc*1000*rand() ]
    end

    @mod1 = UNGTimeSeriesGraphModel.new("External Gateway")
    @mod1.add_tuples @test_vector_tm1
  
    @mod2 = UNGTimeSeriesGraphModel.new("209.216.22.239")
    @mod2.add_tuples @test_vector_tm2
  
    @mod3 = UNGTimeSeriesGraphModel.new("Others")
    @mod3.add_tuples @test_vector_tm3
  
    @modgroup = UNGGraphModelGroup.new("Hosts")
    @modgroup.add(@mod1)
    @modgroup.add(@mod2)
    @modgroup.add(@mod3)
    
    setup_bucketized_models()

   end
  
  def setup_bucketized_models
    # bucketized models
     modbucket1 = UNGBucketizedTimeSeriesGraphModel.new("Out Bw",60)
     tbeg = Time.local( 1978, "jun", 5, 9, 10, 0, 0)
     sbeg = tbeg.tv_sec
     
     #second with some gaps
    sbeg = tbeg.tv_sec
    test_vector_bucket_1 = []
    test_vector_bucket_1 << [sbeg + 60, 1000 ]
    test_vector_bucket_1 << [sbeg + 120, 1000 ]
    test_vector_bucket_1 << [sbeg + 180, 1000 ]
    test_vector_bucket_1 << [sbeg + 239, 1000 ]
    test_vector_bucket_1 << [sbeg + 295, 1000 ]
    test_vector_bucket_1 << [sbeg + 296, 1000 ]
    test_vector_bucket_1 << [sbeg + 297, 5000 ]
    test_vector_bucket_1 << [sbeg + 298, 1000 ]
    test_vector_bucket_1 << [sbeg + 360, 1000 ]
    test_vector_bucket_1 << [sbeg + 420, 1000 ]
    test_vector_bucket_1 << [sbeg + 480, 1000 ]
    test_vector_bucket_1 << [sbeg + 530, 1000 ]
    test_vector_bucket_1 << [sbeg + 604, 1000 ]
    test_vector_bucket_1 << [sbeg + 800, 1000 ]
    modbucket1.add_tuples(test_vector_bucket_1)
    
     #second with some gaps
    modbucket2 = UNGBucketizedTimeSeriesGraphModel.new("In Bw",60)
    sbeg = tbeg.tv_sec
    test_vector_bucket_2 = []
    test_vector_bucket_2 << [sbeg + 10, 1800 ]
    test_vector_bucket_2 << [sbeg + 20, 2600 ]
    test_vector_bucket_2 << [sbeg + 22, 1000 ]
    test_vector_bucket_2 << [sbeg + 60, 1000 ]
    test_vector_bucket_2 << [sbeg + 120, 1900 ]
    test_vector_bucket_2 << [sbeg + 180, 700 ]
    test_vector_bucket_2 << [sbeg + 240, 5000 ]
    test_vector_bucket_2 << [sbeg + 301, 1000 ]
    test_vector_bucket_2 << [sbeg + 350, 1000 ]
    test_vector_bucket_2 << [sbeg + 420, 100 ]
    test_vector_bucket_2 << [sbeg + 470, 500 ]
    test_vector_bucket_2 << [sbeg + 540, 1000 ]
    modbucket2.add_tuples(test_vector_bucket_2)

     #second with some gaps
    modbucket2 = UNGBucketizedTimeSeriesGraphModel.new("In Bw",60)
    sbeg = tbeg.tv_sec
    test_vector_bucket_2 = []
    test_vector_bucket_2 << [sbeg + 10, 1800 ]
    test_vector_bucket_2 << [sbeg + 20, 2600 ]
    test_vector_bucket_2 << [sbeg + 22, 1000 ]
    test_vector_bucket_2 << [sbeg + 60, 1000 ]
    test_vector_bucket_2 << [sbeg + 120, 1900 ]
    test_vector_bucket_2 << [sbeg + 180, 700 ]
    test_vector_bucket_2 << [sbeg + 240, 5000 ]
    test_vector_bucket_2 << [sbeg + 301, 1000 ]
    test_vector_bucket_2 << [sbeg + 350, 1000 ]
    test_vector_bucket_2 << [sbeg + 420, 100 ]
    test_vector_bucket_2 << [sbeg + 470, 500 ]
    test_vector_bucket_2 << [sbeg + 540, 1000 ]
    modbucket2.add_tuples(test_vector_bucket_2)

    @modgroupbucketized = UNGGraphModelGroup.new("Bandwidth")
    @modgroupbucketized .add(modbucket1)
    @modgroupbucketized .add(modbucket2)
    
  end
  

  # test a line chart
  def test_line_1
 
    mychart = GerbilLineChart.new( :width => 350, :height => 200, :style => 'brushmetal.css')
    mychart.setmodelgroup(@modgroup)
    mychart.render('svgt1.svg')
    
  end   
   
  # test a bar chart
  def test_bar_1
 
    mychart = GerbilBarChart.new( :width => 300, :height => 150, :style => 'brushmetal.css')
    mychart.setmodelgroup(@modgroup)
    mychart.render('svgt2.svg')
    
  end   
   
  # test a area chart
  def test_area_1
 
    mychart = GerbilAreaChart.new( :width => 300, :height => 150, :style => 'brushmetal.css')
    mychart.setmodelgroup(@modgroup)
    mychart.render('svgt3.svg')
    
  end   
   
  # test a area chart
  def test_stacked_area_1
 
    mychart = GerbilStackedAreaChart.new( :width => 350, :height => 200, :style => 'brushmetal.css')
    mychart.setmodelgroup(@modgroupbucketized)
    mychart.render('svgt4.svg')
    
  end   
   
   
end
