require File.dirname(__FILE__) + '/test_helper.rb'

class TestModels < Test::Unit::TestCase

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
  
  # Test model simple
  def test_model_simple
  	m = GerbilCharts::Models::GraphModel.new("TestModelName")
	assert m.name == "TestModelName"
  end


  # Test timeseries graph model
  def test_timeseries_1
  	p "--- Testing basic timeseries  model --- "
   
	# load this into a timeseries model
	mod = GerbilCharts::Models::TimeSeriesGraphModel.new("TestModel1")
	@tvector.each do |tpl|
		mod.add (tpl[0],tpl[1])
	end

	#dbg_print_model(mod)

	# crop over than 9:00 AM
	mod.crop_older(Time.local(1973,"Apr",2,9,00,00))

	#dbg_print_model(mod)
  end

  def dbg_print_model(mod)

	# test various things about the model
	rx,ry = mod.ranges
	p "range x = #{rx} y = #{ry}"

    # round ranges
	rx,ry = mod.round_ranges
	p "round range x = #{rx} y = #{ry}"

	# labels
	p "Labels are :"
	p "First = #{rx.format_min_value}"
	rx.each_label do |v,s|
		p "v = #{v} s=#{s}"
	end
  end

  # testing the bucketized timeseries 
  # with bucket size 5 mins 
  def test_bucketized_1
  	p "--- Testing bucketized model --- "

 	# bucketized with  sec buckets
	mod = GerbilCharts::Models::BucketizedTimeSeriesGraphModel.new("TestModel2",5 * 60)
	@tvector.each do |tpl|
		mod.add (tpl[0],tpl[1])
	end

	dbg_print_model(mod)

	# print data points
	mod.each_tuple do |x,y|
		p "bkt #{Time.at(x)} = #{y}"
	end
  end

  # test simple timeseries
  def test_simple_group_1

	p "Testing simple timeseries model group helper"

    modelgroup = GerbilCharts::Models::SimpleTimeSeriesModelGroup.new( :title => "Sales figures",
				   :timeseries  =>  (1..6).collect { |month| Time.local(2008,month) },
				   :models =>       [ ["Bruce", 1, 10, 18, 28, 80,  122],
									  ["Rex"  , 12,22, 45, 70, 218, 109], 
									  ["Buzo" , 0, 23, 25, 40, 18,  59] 
									]
				 )
	modelgroup.each_model { |mod| dbg_print_model(mod) }

  end


end
