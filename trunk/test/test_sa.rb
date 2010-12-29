require File.dirname(__FILE__) + '/test_helper.rb'

require './trafgen'

# tests some easy to use mods
# 	newbies enter here
class TestChartsNoob < Test::Unit::TestCase

  def setup

     @test_vectors = { 
	 			"eth0"=>  [100, 200, 4000,4001, 2001, 2999,8000, 19000,38000,3173000, 78000,1200,1000010] ,
	 			"wlan0"=> [600,1200,84000,14001,22001,2209,48000,1900, 3800,  873000,478000,1121200,4000010] ,
				}

	 @tbegin = Time.local( 1978, "jun", 5, 9, 10, 0, 0)
     @tend = @tbegin + 10000     # for more than 1 hour 
     #@tend = @tbegin + 4000     # for more than 1 hour 
     #@tend = @tbegin + 22*86400     # for more than 1 hour 
  end

  def mk_models1
	modelarr = []
	 @test_vectors.each_pair do |k,v|
			tb = @tbegin.clone
			mod  = GerbilCharts::Models::BucketizedTimeSeriesGraphModel.new( k, 300 )
			v.each do | val |
				mod.add(tb,val)
				tb = tb + 300
			end
			modelarr << mod 
	end
	modelarr 
  end

  def mk_models2

	# between 200K and 6M
	%w(eth0 eth1 eth2 wlan0 wlan1 br0:1 bridge0:2).collect do |n|
			mk_mod(n,200000,6000000)
	end

  end

  def mk_mod(name,min,max)
	model1 = GerbilCharts::Models::BucketizedTimeSeriesGraphModel.new(name, 300 )
	TimeSeriesDataGenerator.new(@tbegin,@tend,300,min, max).each_tuple do |t,v|
		model1.add(t,v)
	end
	return model1
  end



  # test  daily traffic
  def test_daily_traf_1
 

	modelarr = []
	#modelarr = mk_models2
	modelarr << mk_mod("fixed-11",11000000,11000000)
	modelarr << mk_mod("fixed-3",  3000000, 3000000)

	refmod = mk_mod("ref", 60000000, 75000000)

	# modelgroup 
    modelgroup = GerbilCharts::Models::GraphModelGroup.new( "External Traffic")
	modelarr.each { |m| modelgroup.add(m) }
	#modelgroup.ref_model=refmod

	# stacked area
    mysachart = GerbilCharts::Charts::StackedAreaChart.new( :width => 750, :height => 400, 
								:style => 'inline:brushmetal.css',
 		                	    :javascripts => ['/tmp/gerbil.js' , '/tmp/prototype.js' ],
								:toolhrefs => [ ["View Trends", "/trends"], 
												["Retro analysis", "/retro"],
												]  )
	mysachart.modelgroup=modelgroup
    mysachart.render('/tmp/n_daily_traffic_sa.svg')


  end   

 
   
end


