# generate time series data for test purposes
class TimeSeriesDataGenerator

	attr_reader		:tuples_array

	# allows you to generate controlled random data
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
