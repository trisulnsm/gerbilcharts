module GerbilCharts::Models

class MatrixModel 

attr_reader :aend, :zend, :aenduniq, :zenduniq
attr_accessor :name 
attr_reader :aendlen , :zendlen
attr_reader :hash , :sort,:multiply_factor,:name

  # Create the model group for matrix chart
  # Input = {"a","b",1000}
  #         {"a","c",1030}
  #         {"b","v",2345}
  #
  # Output = {"a"=>[1000,1030,0],"b"=>[0,0,2345]}
  
  def initialize(opts)
        @name=opts
        @aend = []
	@zend = []
	@input_values = []
	@arr = []
	@hash = {}
        @sort = []	
        @unsort_value = []
        @multiply_factor = 1.0
        @flag = 1
  end

# Construct the input values
# Eg : @input_values = [["a","b",3000],["a","c",4000],["d","r",4500]] 
  def add(item1,item2,item3) 
      @aend << item1
      @zend << item2         
      for i in 0...@input_values.count
           if ((@input_values[i][0] == item1) and (@input_values[i][1] == item2))
              @input_values[i][2] = @input_values[i][2] + item3
              @flag = 0 
           end         
      end
      if(@flag==1)
         @input_values << [item1,item2,item3]
      end
      @flag=1    
end
  
# calculates the conversation matrix based on the raw arrays a/zend 
  def calc_matrix           
      @aenduniq = @aend.uniq
      @zenduniq = @zend.uniq
      @aendlen = @aenduniq.length
      @zendlen = @zenduniq.length

      @input_values.each do |item|
            @unsort_value << item[2]
      end
      @sort = @unsort_value.sort.reverse
      
      @aenduniq.each do |aitem|          
          @zenduniq.each_with_index do |zitem,i|
               @input_values.each do |vitem|
                     if ((vitem[0] == aitem) and (vitem[1] == zitem))
                        @arr << vitem[2]                       
                     end                       
               end
              if @arr[i].nil?
                 @arr << 0
              end
          end             
      @hash.store(aitem,@arr)
      @arr = []
      end  
  end

 def hasHref?
	return false
 end

 def empty?
	return false
 end

end
end

