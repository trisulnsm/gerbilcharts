module GerbilCharts::SVGDC


# =Filters
# Various SVG filters (eg, gradients, light). You can attach
# this to any SVG element
#
class Filter

  attr_reader :filterid
  def initialize(id,opts={})
    @filterid=id
  end
  def render(xfrag)
  end
end

# == LinearGraidentVertical
# A preset filter
class LinearGradientVertical < Filter
  def initialize(id,fromclr, toclr, opts={})
    super(id,opts)
    @from_color=fromclr
    @to_color=toclr
  end
  
  def render(xfrag)
      xfrag.linearGradient(:id => @filterid, :x1=>"0%", :y1=>"0%",:x2=>"0%",:y2=>"100%") {
          xfrag.stop(:offset=>"0%", :style=>"stop-color:#{@from_color}")
          xfrag.stop(:offset=>"100%", :style=>"stop-color:#{@to_color}")
     }
  end
  
end

# == LikeButton
# uses lighting effect to create a button like effect
# * Inspired by the example in the ZVON 

class LikeButton < Filter

	def initialize(id,opts={})
		super(id,opts)
	end

	def render(xfrag)
		xfrag.filter(:id => 'LikeButton', :filterUnits=>'userSpaceOnUse') {
			xfrag.feGaussianBlur( :in => 'SourceAlpha', :stdDeviation=> '4', :result => 'blur' )
			xfrag.feSpecularLighting( :in=>"blur", :surfaceScale=>"5" , :specularConstant=>".75" , 
									  :specularExponent=>"20", 'lighting-color'=>"#bbbbbb", :result=>"specOut") {
					xfrag.fePointLight( :x=>"-5000", :y=>"-10000",  :z=>"9000")
			}
			xfrag.feComposite( :in=>"specOut",:in2=>"SourceAlpha",:operator=>"in",:result=>"specOut")
		    xfrag.feComposite( :in=>"SourceGraphic",:in2=>"specOut",:operator=>"arithmetic",
								:k1=>"0",:k2=>"1",:k3=>"1", :k4=>"0", :result=>"litPaint")

			xfrag.feMerge {
				xfrag.feMergeNode(:in=>'litPaint')
			}
		}
	end


end



end
