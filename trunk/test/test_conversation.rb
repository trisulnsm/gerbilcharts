require File.dirname(__FILE__) + '/test_helper.rb'

require 'trafgen'

# test conversation bar chart 
class TestConversation < Test::Unit::TestCase

  def test_monthly_sales
    modelgroup = GerbilCharts::Models::MatrixModel.new("Conversation Ring Chart")
   
    modelgroup.add("192.168.1.25","192.168.1.20",500)
    modelgroup.add("192.168.1.25","192.168.1.21",7500)
    modelgroup.add("192.168.1.25","192.168.1.22",6500)
    modelgroup.add("192.168.1.25","192.168.1.23",5500)
    modelgroup.add("192.168.1.25","192.168.1.24",4500)
    modelgroup.add("192.168.1.25","192.168.1.26",10500)
    modelgroup.add("192.168.1.25","192.168.1.27",500)
    modelgroup.add("192.168.1.25","192.168.1.28",2500)
    modelgroup.add("192.168.1.25","192.168.1.29",3500)
    modelgroup.add("192.168.1.25","192.168.1.30",500) 

    modelgroup.calc_matrix   

    mychart = GerbilCharts::Charts::ConversationRing.new( :width => 450, :height => 250,
                                                     :style => 'inline:brushmetal.css', :auto_tooltips => true ,
                                                     :javascripts => ['/tmp/gerbil.js', '/tmp/prototype.js'],
                                                     :filter => 'LikeButton'
                                                   )
 
    mychart.modelgroup = modelgroup
    mychart.render('/tmp/con_monthly_sales.svg')

  end   
end
