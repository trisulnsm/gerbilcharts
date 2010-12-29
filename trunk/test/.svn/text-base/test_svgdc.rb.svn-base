require File.dirname(__FILE__) + '/test_helper.rb'

class TestSVGDC < Test::Unit::TestCase

  def setup
  end

  def teardown
  end


  # basic test 
  #  a circle, rectangle, save 
  def test_basic
    
    g=GerbilCharts::SVGDC::SVGDC.new(300,200)
    g.circle(40,50,20)
    1.upto(10) do |w|
     g.rectangle(80+w*4,10+w*4,10*w,45)
    end
    g.render( :file => "/tmp/tbasic1.svg")

  end
  
  
  # with presentation
  #  select a pen and brush for this DC, all drawing will use it !
  def test_presentation
    
    g=GerbilCharts::SVGDC::SVGDC.new(350,200)
    
	# will show up clear black
    g.rectangle(0,0,50,40)

    g.select_presentation(:pen => GerbilCharts::SVGDC::PPen.new(:color=>"red", :width=>3) )
    g.select_presentation(:brush => GerbilCharts::SVGDC::PBrush.new(:color=>"blue") ) 

	# these will be stroked with new pen and brush selected above
    g.rectangle(10,10,300,100)
    g.line(200,0,100,200)
    g.render( :file => "/tmp/tbasic3.svg")

  end

  # test a polyline
  def test_polyline
    g=GerbilCharts::SVGDC::SVGDC.new(400,200)
    
	# will show up clear black
    g.rectangle(0,0,400,200)

	# points
	g.lineto(10,10)
	g.lineto(11,40)
	g.lineto(12,80)
	g.lineto(80,70)
	g.lineto(56,10)
	g.lineto(255,80)
	g.endline

	# thick and purple
	10.times do 
		g.lineto( rand * 400, 100 + rand * 100)
	end
	g.endline( "stroke"  => 'purple', 'stroke-width' => 5 )

    g.render( :file => "/tmp/tpolyline1.svg")
  end

  # test a polygon
  def test_polygon
    g=GerbilCharts::SVGDC::SVGDC.new(100,100)

  	[ [10,10], [16,19],  [45, 70], [80,75], [17,80] ].each do |c|
		g.polygon_point(c[0],c[1])
	end
	g.end_polygon( 'stroke-width' => 4 )
    g.render( :file => "/tmp/tpolygon1.svg")

  end

  
  # test with a stylesheet 
  def test_css1
    g=GerbilCharts::SVGDC::SVGDC.new(400,500)
    g.set_stylesheet "teststyle1.css"
    g.rectangle(10,10,100,300, {:class => "surface"})
    g.render( :file => "/tmp/tcss1.svg")
  end
  

  # test with stylesheet and a bunch of transformations
  def test_css2
    
    g=GerbilCharts::SVGDC::SVGDC.new(400,200)
    g.set_stylesheet "teststyle1.css"
    
	# this window is rotated  (2.4 radians)
    w=g.newwin("rot_1")
    w.add_transformation(GerbilCharts::SVGDC::TRotate.new(2.4))
    g.setactivewindow(w)
    g.rectangle(10,10,300,50, {:class => "surface"})
    g.setactivewindow

	# this window is rotated -15 and shifted 25 x  10 y
    w=g.newwin("rot_2")
    w.add_transformation(GerbilCharts::SVGDC::TRotate.new(-15.0))
    w.add_transformation(GerbilCharts::SVGDC::TTranslate.new(25,10))
    g.setactivewindow(w)
    g.rectangle(0,80,300,50, :fill => 'yellow' )
    g.setactivewindow

    
    g.render( :file => "/tmp/tcss2.svg")

  end
  
  
  # test subwindows , these show up as group (g) elements in the svg 
  def test_group2
    
    g=GerbilCharts::SVGDC::SVGDC.new(400,500)
    g.set_stylesheet "teststyle1.css"
    
    # group 1
    w1=g.newwin("xaxisgroup")
    w1.add_transformation(GerbilCharts::SVGDC::TRotate.new(1.4))
    g.setactivewindow(w1)
    g.rectangle(0,0,100,60, {:class => "surface"})
    g.setactivewindow
     
    # group 2
    w2=g.newwin("yaxisgroup")
    w2.add_transformation(GerbilCharts::SVGDC::TRotate.new(2.4))
    w2.add_transformation(GerbilCharts::SVGDC::TTranslate.new(50,10))
    g.setactivewindow(w2)
    g.rectangle(0,0,100,60, {:class => "surface"})
   
    g.line(10,10,30,10, {:id => "item1"})
    g.setactivewindow
    
    
    g.render( :file => "/tmp/tg2.svg")

    
  end

  

  # basic text output
  #  No stylesheet
  def test_text1
    g=GerbilCharts::SVGDC::SVGDC.new(800,200)
    
       
	# group wise  all textouts will inherit the font family
    w1=g.newwin("fixed_font_win", "stroke" => "none", "fill" => "black" ,  "font-family" => "monospace" )
	g.setactivewindow(w1)
	g.rectangle(0,0,800,60,'fill' => 'gray')
    g.textout(10,15,"Fixed font test 1 (font family = fixed)")
    g.textout(10,25,"second line of monospace ")
    g.textout(10,40,"third line of monospace font (larger size) ", "font-size" => "14" )
	g.setactivewindow(nil)


    # unknown font ?
    w1=g.newwin("lucida_win", "font-face" => "Lucida Console", "font-size" => 18 )
	g.setactivewindow(w1)
    g.textout(10,80,"Fixed font test 2 hollow (font face = lucida console)")
	g.setactivewindow(nil)


	# directly draw a font (no containing window)
    g.textout(10,100,"Directly textout with size 10, red monospace", "font-family" => "monospace", "stroke" => "none", "fill" =>'red' )

	# using the monospace helper
    g.textout_monospace(10,120,"Using the monospace helper with defaults" )
	
	# using the monospace helper (override color and size)
    g.textout_monospace(10,140,"Monospace helper blue size 14", "fill" => "blue", "font-size" => "14"  )

    g.render( :file => "/tmp/ttxt1.svg")


  end

  
  # text output with a rotation
  def test_text1rot
    
    g=GerbilCharts::SVGDC::SVGDC.new(200,250)
    g.set_stylesheet "teststyle1.css"
    
    # group 1
    w1=g.newwin("xaxisgroup")
    w1.add_transformation(GerbilCharts::SVGDC::TRotate.new(90.0))
    g.setactivewindow(w1)
    g.rectangle(0,0,100,60, {:class => "surface"})
    g.textout(40,40,"Text rotated +90 degrees ?", {:class => "axislabel"})
    g.setactivewindow
       
    g.render( :file => "/tmp/ttxt1rot.svg")
    
  end
  
  # text output with css
  def test_text2
    
    g=GerbilCharts::SVGDC::SVGDC.new(400,500)
    g.set_stylesheet "teststyle1.css"
    
    # group 1
    g.rectangle(0,0,100,60, {:class => "surface"})
    g.textout(40,40,"Om !", {:class => "axislabel"})
    g.textout(40,240,"Host: 192.168.1.1 (18%)", {:class => "axislabel"})
       
    g.render( :file => "/tmp/ttxtcss.svg")

    
  end
end
