require File.dirname(__FILE__) + '/test_helper.rb'

class TestRanges < Test::Unit::TestCase

  def setup
	# test vector 
	@tvector = []
	@tvector << [ Time.local(1973,"Apr",2,8,30,0), 0 ]
	@tvector << [ Time.local(1973,"Apr",2,8,30,10), 0.5 ]
	@tvector << [ Time.local(1973,"Apr",2,8,30,11), 18 ]
	@tvector << [ Time.local(1973,"Apr",2,8,30,15), 911 ]
	@tvector << [ Time.local(1973,"Apr",2,8,30,18), 100 ]
	@tvector << [ Time.local(1973,"Apr",2,8,30,19), 80 ]
	@tvector << [ Time.local(1973,"Apr",2,8,30,20), 98 ]
	@tvector << [ Time.local(1973,"Apr",2,8,30,45), 1002 ]
	@tvector << [ Time.local(1973,"Apr",2,8,30,58), 3014 ]
	@tvector << [ Time.local(1973,"Apr",2,8,31,0), 1002 ]
	@tvector << [ Time.local(1973,"Apr",2,8,32,0), 88 ]
	@tvector << [ Time.local(1973,"Apr",2,8,32,20), 882]
	@tvector << [ Time.local(1973,"Apr",2,8,32,21), 3015 ]
	@tvector << [ Time.local(1973,"Apr",2,8,36,0), 10 ]
	@tvector << [ Time.local(1973,"Apr",2,8,46,0), 1 ]
	@tvector << [ Time.local(1973,"Apr",2,8,47,0), 2 ]
	@tvector << [ Time.local(1973,"Apr",2,8,47,1), 3 ]
	@tvector << [ Time.local(1973,"Apr",2,8,47,5), 4 ]
	@tvector << [ Time.local(1973,"Apr",2,8,50,0), 59 ]
	@tvector << [ Time.local(1973,"Apr",2,8,58,0), 188 ]
	@tvector << [ Time.local(1973,"Apr",2,9,00,17), 4017 ]
	@tvector << [ Time.local(1973,"Apr",2,9,20,18), 18 ]
	@tvector << [ Time.local(1973,"Apr",2,9,40,20), 10 ]
	@tvector << [ Time.local(1973,"Apr",2,10,13,7), 100 ]
	@tvector << [ Time.local(1973,"Apr",2,10,14,7), 100 ]
	@tvector << [ Time.local(1973,"Apr",2,10,15,7), 100 ]
	@tvector << [ Time.local(1973,"Apr",2,10,17,7), 100 ]

  end
  
  # test raw range - simple version
  def test_raw_range_1
    r = GerbilCharts::Models::RawRange.new

  	[10,20,10,0,0,1001,19920,882991.22].each do |v|
		r.update v
	end

	r.min_max do |mn,mx|
    	assert mn==0
		assert mx==882991.22
	end
  end

  # test - various methods
  def test_raw_range_2
    r = GerbilCharts::Models::RawRange.new
  	[10,20,10,0,0,1001,19920,20001].each do |v|
		r.update v
	end

	# update from another range
	r2 = GerbilCharts::Models::RawRange.new
	r2.update(-10)
	r2.update 20002
	r.update_r r2

	# check if updated correctly
	assert r.rmax == 20002
	assert r.rmin == -10 

	# check scaling 
	fv = r.scale_factor(20002)
	assert_in_delta(fv,1,0.001)
	fv = r.scale_factor(10000)
	assert_in_delta(fv,0.5,0.001)

	# check if reset works
	r.reset
	assert_nil(r.rmax)
	assert_nil(r.rmin)
  end

  # test round range
  def test_round_range_1
    r = GerbilCharts::Models::RawRange.new
  	[10,20,10,0,0,1001,19920,20001].each do |v|
		r.update v
	end

	rr = GerbilCharts::Models::RoundRange.new(r)
	assert_equal(rr.rmax,50000)
	assert_equal(rr.rmin,0)
	assert_equal(rr.lmax,10000,"checking ideal label interval")

	r.update(50001)
	rr = GerbilCharts::Models::RoundRange.new(r)
	assert_equal(rr.rmax,100000)
	assert_equal(rr.lmax,25000,"checking ideal label interval for a 100K interval")

  end

  # test time hours
  def test_round_time_range_1
    r = GerbilCharts::Models::RawRange.new
    tbase = Time.local(1973,"Apr",2,8,30,0)
	
	@tvector.each do |t|
		r.update t[0]
	end

	rr = GerbilCharts::Models::RoundTimeRange.new(r)
	rr.each_label do |v,s|
	#	p "v = #{v} s=#{s}"
	end
	assert_equal(rr.rdelta,7200)   # 3 hr range
	assert_equal(rr.ldelta,1800)   # label every 30 mins 

	# add a 4 hr gap  (9hr range + 2 hr labels)
	r.update( @tvector.last[0] + 4*3600)
	rr = GerbilCharts::Models::RoundTimeRange.new(r)
	rr.each_label do |v,s|
	#	p "v = #{v} s=#{s}"
	end
	assert_equal(rr.rdelta,6*3600)
	assert_equal(rr.ldelta,2*3600)

	# add a new 10hr gap
	r.update( @tvector.last[0] + 10*3600)
	rr = GerbilCharts::Models::RoundTimeRange.new(r)
	rr.each_label do |v,s|
	#	p "v = #{v} s=#{s}"
	end
	assert_equal(rr.rdelta,43200)
	assert_equal(rr.ldelta,10800)
  end

  def test_negative_range

    r = GerbilCharts::Models::RawRange.new
  	[-11000,19920,20001].each do |v|
		r.update v
	end

	rr = GerbilCharts::Models::RoundRange.new(r)
	assert_equal(rr.rmax,50000)
	assert_equal(rr.rmin,-20000)
	assert_equal(rr.lmax,25000,"checking ideal label interval")

	r.update(-18000)
	rr = GerbilCharts::Models::RoundRange.new(r)
	assert_equal(rr.lmax,25000,"checking ideal label interval for a 100K interval")

  end

  def test_long_time_range

    r = GerbilCharts::Models::RawRange.new
    tbase = Time.local(1973,"Apr",2,8,30,0)
	r.update tbase
	r.update(tbase+100000)

	rr = GerbilCharts::Models::RoundTimeRange.new(r)

	rr.each_label do |v,s|
		p "v = #{v} s=#{s}"
	end

  end


end
