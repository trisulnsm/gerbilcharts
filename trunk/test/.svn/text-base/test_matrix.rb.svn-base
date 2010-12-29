require File.dirname(__FILE__) + '/test_helper.rb'

require 'trafgen'

# test conversation bar chart 
class TestMatrix < Test::Unit::TestCase

  def test_monthly_sales
    modelgroup = GerbilCharts::Models::MatrixModel.new("Traffic Matrix")

    modelgroup.add("192.168.1.25","192.168.1.20",12500)
    modelgroup.add("192.168.1.26","192.168.1.21",7500)
    modelgroup.add("192.168.1.25","192.168.1.22",6500)
    modelgroup.add("192.168.1.27","192.168.1.23",5500)
    modelgroup.add("192.168.1.28","192.168.1.24",4500)
    modelgroup.add("192.168.1.29","192.168.1.26",10500)
    modelgroup.add("192.168.1.25","192.168.1.27",500)
    modelgroup.add("192.168.1.25","192.168.1.28",2500)
    modelgroup.add("192.168.1.30","192.168.1.29",3500)
    modelgroup.add("192.168.1.52","192.168.1.30",500)

    modelgroup.calc_matrix   

    mychart = GerbilCharts::Charts::MatrixChart.new( :width => 1000, :height => 400,
                                                     :style => 'inline:brushmetal.css', :auto_tooltips => true ,
                                                     :javascripts => ['/tmp/gerbil.js', '/tmp/prototype.js'],
                                                     :filter => 'LikeButton'
                                                   )
 
    mychart.modelgroup = modelgroup
    mychart.render('/tmp/matrix_monthly_sales.svg')

  end   
end
