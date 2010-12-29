module GerbilCharts::Surfaces


# = Tracker (allows mouse selection of timearea)
# This sets up the hooks to interact with the gerbil.js Javascript file
# 
class Tracker < GraphElement
    
    
    def initialize(opts={})
      super
    end
    
    def int_render(dc)
      
      dc.addshape(GerbilCharts::SVGDC::SVGCustomWin.new("GerbilTracker",self))
      
    end
    
    # render the elements directly
    def render_direct(xfrag)
    

      # calculate scaling factors
      range_options_x = parent.get_global_option(:scaling_x,:auto)
      rx = parent.modelgroup.effective_range_x(range_options_x)

      return unless rx.rmin.is_a? Time
      
      xfrag.g(:id=> 'gtrackerrect', :visibility=>'hidden') {
             xfrag.rect(:id=>"trackerrect", :class=>"trackerrect", 
                       :height=>parent.anchor.bounds.height, :width=>30, :x=>100, :y=>parent.anchor.bounds.top)     
      }

      # output the SVG fragment directly
      xfrag.g(:id => 'gtrackerpanel') {
            xfrag.rect(:id=>"trackerpanel", :class=>"trackerpanel", 
                       :height=>@bounds.height, :width=>@bounds.width, :x=>@bounds.left, :y=>@bounds.top, 
                       :onmousedown=>"TrackerMouseDown(evt)", 
                       :onmousemove=>"TrackerMouseMove(evt)", 
                       :onmouseup=>"TrackerMouseUp(evt)")
      }
      
      
      ty = parent.anchor.bounds.height/2
      xfrag.g(:id=> 'gtrackertext', :visibility=>'hidden', :transform => "translate(200 50)") {
        xfrag.text( :class => 'trackertextinterval', :id=>'trackertextbox', "text-anchor" => 'middle' ) {
            xfrag.tspan( :id => 'trackertextinterval', :x=>0, :y=>ty) {
                "15 Minutes"
            }
            xfrag.tspan( :class => 'trackertextfromts', :id => 'trackertextfromts', :x=>0, :dy=>15) {
                "Starting: Apr 2 1973, 05:00:00 PM"
            }
        }
      }
      

     xfrag.g(:id=>"gtrackerdata",   :visibility=>'hidden',
              :gerb_fromts=>rx.rmin.tv_sec,  
              :gerb_seconds=>rx.rmax.tv_sec-rx.rmin.tv_sec,  
              :gerb_scale =>(rx.delta)/parent.anchor.bounds.width,
	      :gerb_tzoffset => Time.new.utc_offset,
	      :gerb_tzname => Time.new.zone,
              :gerb_selts=>1,
              :gerb_selsecs=>1)
      
    end
    
  end  

end
