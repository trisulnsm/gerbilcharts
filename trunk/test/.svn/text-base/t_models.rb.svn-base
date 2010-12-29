require "test/unit"
require "ung_graph_model.rb"

class TModels < Test::Unit::TestCase
  
   attr_reader  :test_vector
   attr_reader  :test_vector_2
   attr_reader  :test_vector_3   
   attr_reader  :test_vector_tm
   attr_reader  :test_vector_tm2
   
  
   def setup
     
     @test_vector   = [ [10,10], [15,10], [20,17.51], [25, 16.8], [30,8.27], [35,13], [40,9], [55,3] ]
     @test_vector_2 = [ [13,100], [15,10], [20,1],  [31,13], [40,9], [65,23] ]
     @test_vector_3 = [ [6,4], [15,11], [25, 98], [35,73], [46,19], [58,13] ]
     @test_vector_5 = [ [6,4], [15,11], [25, 98], [135,73], [2046,19], [3158,13] ]     
     @test_vector_6 = [ [1610000,4], [1781000,11], [1800748, 98] ]
    
     @test_vector_tm = []
     tbeg = Time.local( 1978, "jun", 5, 9, 10, 0, 0)
     sbeg = tbeg.tv_sec
     sec_inc = 100
     
     for i in (0..10000)
      @test_vector_tm << [sbeg + i*sec_inc, i*sec_inc*1000 ]
     end

     #second with some gaps
     sbeg = tbeg.tv_sec
     @test_vector_tm2 = []
      @test_vector_tm2 << [sbeg + 60, 1000 ]
      @test_vector_tm2 << [sbeg + 120, 1000 ]
      @test_vector_tm2 << [sbeg + 170, 1000 ]
      @test_vector_tm2 << [sbeg + 239, 1000 ]
      @test_vector_tm2 << [sbeg + 295, 1000 ]
      @test_vector_tm2 << [sbeg + 296, 1000 ]
      @test_vector_tm2 << [sbeg + 297, 5000 ]
      @test_vector_tm2 << [sbeg + 298, 1000 ]
      @test_vector_tm2 << [sbeg + 800, 1000 ]
    
   end
  
   def test_monotonous
    
    begin
      m = UNGMonotonousGraphModel.new("External Gateway")
      
      m.add(10,10)
      m.add(15,10)
      m.add(1,10)
      m.add(2,13)
    rescue
      puts " Exception received as expected"
      assert true
    end
   
  end
  
  
   def test_range
    
      m = UNGMonotonousGraphModel.new("External Gateway")
      m.add_tuples @test_vector
      
      m.ranges do |rx,ry|
         assert rx.rmin==10
        assert rx.rmax==55
        assert ry.rmin==3
        assert ry.rmax==17.51
      end
  
  end

  
  def test_since
      m = UNGMonotonousGraphModel.new("External Gateway")
      m.add_tuples @test_vector

      m.tuples_since(20) do |tx,ty|
    #    puts "#{tx} #{ty}"
      end
      
      m.tuples_since(21) do |tx,ty|
    #    puts "#{tx} #{ty}"
      end 
      
      m.tuples_since(30) do |tx,ty|
    #    puts "#{tx} #{ty}"
      end  
  end

  def test_groups
      m1 = UNGMonotonousGraphModel.new("External Gateway")
      m1.add_tuples @test_vector
 
      m2 = UNGMonotonousGraphModel.new("192.168.1.192")
      m2.add_tuples @test_vector_2
 
      m3 = UNGMonotonousGraphModel.new("209.216.28.188")
      m3.add_tuples @test_vector_3
 
    
      g = UNGGraphModelGroup.new("Top Talkers")
      g.add m1
      g.add m2
      g.add m3
      g.models_digest
      
      assert g.count==3
  end
  
  
  def test_round_ranges
      m1 = UNGMonotonousGraphModel.new("External Gateway")
      m1.add_tuples @test_vector
 
      rx,ry=m1.round_ranges
      puts "rx= #{rx} ry=#{ry}"
 
  end

  
  def test_labels
      m1 = UNGMonotonousGraphModel.new("External Gateway")
      m1.add_tuples @test_vector_5
 
      rx,ry=m1.round_ranges
      rx.each_label do |v,l|
      #  p "v = #{v} l= #{l}"
      end
     
  end 
   
   
  def test_labels_2
      m1 = UNGMonotonousGraphModel.new("External Gateway")
      m1.add_tuples @test_vector_6
 
      rx,ry=m1.round_ranges
      rx.each_label do |v,l|
      #  p "v = #{v} l= #{l}"
      end
      
      rx.each_tick(5) do |t|
      #  p "t = #{t}"
      end
     
  end   
   
  def test_round_ranges
      m1 = UNGTimeSeriesGraphModel.new("External Gateway")
      m1.add_tuples @test_vector_tm
 
      rx,ry=m1.round_ranges
      puts "rx= #{rx} ry=#{ry}"
 
  end

  def test_labels_tm
      m1 = UNGTimeSeriesGraphModel.new("External Gateway")
      m1.add_tuples @test_vector_tm
 
      rx,ry=m1.round_ranges
      rx.each_label do |v,l|
        p "v = #{v} l= #{l}"
      end
      
  end   
   
  def test_labels_tm_full
      m1 = UNGTimeSeriesGraphModel.new("Total Bandwidth")
      m1.add_tuples @test_vector_tm
 
      m1.clear
      
      rx,ry=m1.round_ranges
      rx.each_label do |v,l|
        p "v = #{v} l= #{l}"
      end
      
  end   

  def test_bucket_model
      m1 = UNGBucketizedTimeSeriesGraphModel.new("Total Bandwidth",60)
      m1.add_tuples @test_vector_tm2

      p "Test bucketized tuples"
    
      m1.each_tuple do |x,y|
        p "x=#{x}   y=#{y}"
      end
      p "Done - Test bucketized tuples"
  
      rx,ry=m1.round_ranges
      rx.each_label do |v,l|
        p "v = #{v} l= #{l}"
      end

  end   
   
  def test_bucket_sweep
      m1 = UNGBucketizedTimeSeriesGraphModel.new("Out Bw",60)
      m1.add_tuples @test_vector_tm2

      p "Test sweep logic "
    
      rx,ry=m1.round_ranges
      

      startx = rx.rmin - 900
      endx = rx.rmax + 300
      m1.begin_sweep
      
      while (startx<endx)  
            p " x = #{startx}   sweep_y = #{m1.sweep(startx)}"
            startx += 60
      end
    
      p "Done - Test bucketized tuples"
  
  end   
   

end