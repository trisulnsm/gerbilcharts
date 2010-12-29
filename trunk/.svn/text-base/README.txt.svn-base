= gerbilcharts

* http://gerbilcharts.rubyforge.com

== DESCRIPTION:

SVG based charting library especially suited for timeseries data.

== FEATURES/PROBLEMS:

* Many predefined models
* Many chart types
* Customize via stylesheets instead of calls to setFont, setLineStyle, setColor etc
* Interactive show tooltips, handle clicks on chart objects
* Ajax enabled. gerbil.js allows each chart to autoupdate itself with new SVG elements.

Known issues :
* Requires a browser that can handle SVG such as Firefox/Opera.
* IE + Adobe SVG Viewer works but has some problems w/ Ajax
* Still needs some work on negative numbers
* Needs better min/max/avg plotting on bucketized data

===Note on stylesheets
GerbilCharts uses stylesheets to customize appearances of almost all visual
elements (colors, fonts, line strokes, fills). You can use the supplied
stylesheet (eg, brushmetal.css) or derive your own from it. GerbilCharts
searches for stylesheets in the working directory and the public directory of
the gerbilcharts gem.

== SYNOPSIS:

===Simple timeseries example
Assumes all models (data series) have values at discrete time points.

  require 'rubygems'
  gem 'gerbilcharts'
  require 'gerbilcharts'

  # test  sales figures of 3 sales people
  # use a simple timeseries model 
  mychart = GerbilCharts::Charts::LineChart.new( :width => 350, :height => 200, :style => 'brushmetal.css',
                                                 :circle_data_points => true )

  modelgroup = GerbilCharts::Models::SimpleTimeSeriesModelGroup.new(
                   :title => "Sales figures",
                   :timeseries  =>  (1..6).collect { |month| Time.local(2008,month) },
                   :models =>       [ ["Bruce", 1,  10, 18, 28, 80,  122],
                                      ["Rex"  , 112,22, 45, 70, 218, 309],
                                      ["Buzo" , 0,  23, 25, 40, 18,  59]
                                    ]
                 )
  mychart.modelgroup=modelgroup
  mychart.render('/tmp/monthly_sales.svg')

To view the chart:
* firefox /tmp/monthly_sales.svg

===Rails example
The most common use of gerbilcharts will be in a Rails application. Here is a guide to quickly get you on board. You can skip the first three steps if you already have a rails app up and running.

First install gerbilcharts
	sudo gem install gerbilcharts

Generate a test app called gtest
	rails generate gtest

Create a controller
	cd gtest
	ruby script/generate controller tgerbil

Copy the following code into app/controllers/tgerbil_controller.rb


		require 'gerbilcharts'

		class GerbtController < ApplicationController

				# render inline to browser without using a temp file
				def tgerb

				  # test  sales figures of 3 sales people
				  # use a simple timeseries model 
				  # output to string finally
					mychart = GerbilCharts::Charts::LineChart.new( :width => 350, :height => 200, :style => 'brushmetal.css',
															   :circle_data_points => true )

					mychart.modelgroup = GerbilCharts::Models::SimpleTimeSeriesModelGroup.new( 
								   :title => "Sales figures",
								   :timeseries  =>  (1..6).collect { |month| Time.local(2008,month) },
								   :models =>       [ ["Bruce", 1,  10, 18, 28, 80,  122],
													  ["Rex"  , 112,22, 45, 70, 218, 309], 
													  ["Buzo" , 0,  23, 25, 40, 18,  59] 
													]
								 )

					send_data mychart.render_string, :disposition => 'inline', :type => 'image/svg+xml'


				  end   
		end


Start the web server
	ruby script/server


Point to website and test out the chart at http://localhost:3000/tgerbil/tgerb


===Bucketizer example
This is a typical use of gerbilcharts. A number of timeseries data sources of various resolutions are bucketized uniformly and shown on a variety of charts. In this example, data points at varying intervals of approx 5 mins are collated into 15 min buckets using the BucketizedTimeSeriesGraphModel. This sample also shows the seperation of the data from the view. In the sample below, we switch the view from an ImpulseChart to a StackedAreaChart without touching the model.

	require 'rubygems'
	gem 'gerbilcharts'
	require 'gerbilcharts'

	# Helper class to generate time series data for test purposes
	class TimeSeriesDataGenerator
	
		attr_reader	:tuples_array
	
		# allows you to generate controlled random data
		# tm_from, tm_to = start,end  time (a Time object)
		# avg_resolution_secs = generate a sample approx this many seconds. Varies randomly +/-25%
		# max,min = max and min value
		def initialize(tm_from, tm_to, avg_resolution_secs, min_val, max_val)
			@tuples_array=[]
			tm_tmp = tm_from
			
			while tm_tmp < tm_to
				@tuples_array << [ tm_tmp, min_val + (max_val - min_val)*rand ]
				tm_tmp = tm_tmp + avg_resolution_secs *( 1 + (rand-0.5)/4)
			end
		end
	
		# iterator
		def each_tuple
			@tuples_array.each do |t,v|
				yield t,v
			end
		end
	end


	# create an impulse chart 450x200 using the supplied brushmetal theme
	mychart = GerbilCharts::Charts::ImpulseChart.new( :width => 450, :height => 200, :style => 'brushmetal.css')
	
	# generate traffic sample 1 (eth0) at approx 5 min intervals and feed into a bucketizer model of 15 min
	tend = Time.now
	tbegin = tend - 3600*24
	model1 = GerbilCharts::Models::BucketizedTimeSeriesGraphModel.new( "eth0", 900 )
	TimeSeriesDataGenerator.new(tbegin,tend,300,200000, 6000000).each_tuple do |t,v|
	model1.add(t,v)
	end
	
	# generate traffic sample 2(wan1) at approx 5 min intervals and feed into a bucketizer model of 15 min
	model2 = GerbilCharts::Models::BucketizedTimeSeriesGraphModel.new( "wan1", 900 )
	TimeSeriesDataGenerator.new(tbegin,tend,300,500000, 2000000).each_tuple do |t,v|
	model2.add(t,v)
	end
	
	# add these models to a modelgroup and render it
	modelgroup = GerbilCharts::Models::GraphModelGroup.new( "External Traffic")
	modelgroup.add model1
	modelgroup.add model2
	mychart.modelgroup=modelgroup
	mychart.render('/tmp/daily_traffic.svg')

	# attach the same model to a stacked area chart and show it 
	# this demonstrates how the views can be changed dynamically

	mysachart = GerbilCharts::Charts::StackedAreaChart.new( :width => 450, :height => 200, :style => 'brushmetal.css')
	mysachart.modelgroup=modelgroup
	mysachart.render('/tmp/daily_traffic_stacked_area.svg')	

To view the charts:
* firefox /tmp/daily_traffic.svg 
* firefox /tmp/daily_traffic_stacked_area.svg
 
== Bucketizer rails example
Use the bucketizer if you want to present timeseries data at a lower resolution that that of the incoming stream. The sample code is shown below. Copy paste this code into a controller to test the bucketizer


		require 'gerbilcharts'

		class GerbtController < ApplicationController

		  # use the bucketized model only if we want the output to have a lower resolution 
		  # than the incoming data
		  def tbucket

			 # create a model group, this houses the individual models
			 modelgroup  = GerbilCharts::Models::GraphModelGroup.new("Price trends")

			 # bucketized models, we create one and add it to the group
			 bucket1  = GerbilCharts::Models::BucketizedTimeSeriesGraphModel.new("Selling Price",60)
			 tbeg = Time.local( 1978, "jun", 5, 9, 10, 0, 0)
			 
			 # generate some random values at random resolution between 5 and 30 seconds
			 # the timestamps of incoming data start from jun 5 9:10 AM :w
			 100.times do |c|
				 tbeg  =  tbeg + 5 + rand*30
				 bucket1.add tbeg, rand*1000
			 end

			 # add all models to the group , we will chart the group
			 modelgroup.add(bucket1)

			 # create a area chart
			 mychart = GerbilCharts::Charts::AreaChart.new( :width => 350, :height => 200, 
															:style => 'brushmetal.css')

			 # connect the model group to the chart
			 mychart.setmodelgroup(modelgroup)

			 send_data mychart.render_string, :disposition => 'inline', :type => 'image/svg+xml'

		   end

			
		end

===Tooltips example
GerbilCharts can be interactive just like Flash charts. This is accomplished by a combination of SVG and
Javascript. The Javascript is packaged in the file gerbil.js (requires prototype.js)

Todo: A sample please (extract from Web Trisul)

===Time selector example
You can even select time intervals from the SVG using gerbil.js.

Todo: A sample please (extract from Web Trisul)


== REQUIREMENTS:

* builder gem


== INSTALL:

* sudo gem install gerbilcharts

== LICENSE:

(The MIT License)

Copyright (c) 2008 Vivek Rajagopalan (vivek at unleashnetworks )

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
