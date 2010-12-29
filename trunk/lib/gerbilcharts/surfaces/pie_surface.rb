module GerbilCharts::Surfaces

# = Pie Surface
class PieSurface < Surface

	MIN_INSIDE_LABEL_ANGLE = 8 				# do not draw outer label for small angles
	MIN_OUTSIDE_LABEL_ANGLE = 3				# do not draw inner percentages (pie slice) for small angles
  OUTER_OFFSET_X = 10					# x - distance  offset from pie boundary
	OUTER_OFFSET_Y = 10   					# y - y offset from pie boundary
	LEFT_LABEL_OFFSET = 30 					# labels on the left of the PIE offset by this (90-270 deg)
	PERCENT_OFFSET_X = -4					# pull slice label this much (tweak)

  def initialize(opts={})
      super(opts)
    end
    
  def int_render(g)
      g.rectangle_r(@bounds, {:class => @class})
    end

    
  def int_render(g)

    # bail out of empty models quickly
    if parent.modelgroup.empty?
      g.textout(@bounds.left + @bounds.width/2, @bounds.height/2,
        parent.modelgroup.empty_caption,{"text-anchor" => "middle"})
      return
    end

    # any filters ?
    if parent.get_global_option(:filter,false)
      g.curr_win.add_options({:filter => "url(##{parent.get_global_option(:filter,false)})" })
    end
    
    # compute totals
    y_total = 0
    parent.modelgroup.each_model_with_index do | mod, i|
      y_total = y_total + mod.latest_val
    end

    radius  = @bounds.height * 0.35
    radius_label = radius + 10
    cx = @bounds.width/2
    cy = @bounds.height/2
    current_pos_x = cx + radius
    current_pos_y = cy

    # draw each slice
    tot_angle =0
    last_label_pos_y=0
    parent.modelgroup.each_model_with_index do | mod, i|
      mod_angle = ((mod.latest_val*360).to_f)/(y_total.to_f)
      half_angle = tot_angle + mod_angle/2
      tot_angle = tot_angle + mod_angle

      new_pos_x = cx + (Math.cos((Math::PI/180)*tot_angle)*radius)
      new_pos_y = cy + (Math.sin((Math::PI/180)*tot_angle)*radius)
      label_pos_x = cx + (Math.cos((Math::PI/180)*half_angle)*radius_label)
      label_pos_y = cy + (Math.sin((Math::PI/180)*half_angle)*radius_label)

      percent_mod = ((mod.latest_val*360).to_i/y_total.to_i)
      percent = (percent_mod*100/360)
      percent_pos_x = cx + ((Math.cos((Math::PI/180)*half_angle)*radius_label)*0.6) + PERCENT_OFFSET_X
      percent_pos_y = cy + ((Math.sin((Math::PI/180)*half_angle)*radius_label)*0.6)


      # if tooltips enabled, user can position on pie slice
      opts = {:id => "item#{i}"}
      if parent.get_global_option(:auto_tooltips,false)
        opts.merge!(:onmouseover => "OpacityDown(evt)", :onmouseout => "OpacityUp(evt)")
        opts.store(:gerbiltooltip1, mod.name)
        opts.store(:gerbiltooltip2, "#{mod.latest_formatted_val}")
      end
      opts.merge!(:href => mod.href) if mod.hasHref?

      # draw a circle if there is only one data
      if (mod_angle >= 360)
        g.addshape(GerbilCharts::SVGDC::SVGCircle.new(cx,cy,radius),opts)
      else
        # draw the slice
        g.addshape(GerbilCharts::SVGDC::SVGArc.new(cx,cy,radius,radius,
                                                  current_pos_x,current_pos_y,
                                                  new_pos_x,new_pos_y,mod_angle),
                  opts)
      end
      
	  elementlabel_clsn = [ [30,'elementlabel_large'], [60, 'elementlabel_huge'] ].inject('elementlabel')  do  |mem,it|
			  percent > it[0] ? it[1]:mem
      end

      if(percent >= MIN_OUTSIDE_LABEL_ANGLE)
        if(tot_angle > 270)
          if(label_pos_x > cx ) && (label_pos_y > cy )
            g.textout(label_pos_x,label_pos_y+OUTER_OFFSET_Y, "#{mod.name}", :class => elementlabel_clsn )
          else
            label_pos_y_off = (last_label_pos_y-label_pos_y) < 5 ? 5:0
            g.textout( label_pos_x+OUTER_OFFSET_X, label_pos_y+OUTER_OFFSET_Y+label_pos_y_off, "#{mod.name}", :class => elementlabel_clsn )
          end
        elsif(label_pos_x > cx ) && (label_pos_y > cy)
          g.textout( label_pos_x, label_pos_y+OUTER_OFFSET_Y, "#{mod.name}", :class => elementlabel_clsn )
        else
          g.textout( label_pos_x-LEFT_LABEL_OFFSET, label_pos_y+OUTER_OFFSET_Y, "  #{mod.name}", :class => elementlabel_clsn )
        end
      end


      if(percent > MIN_INSIDE_LABEL_ANGLE)
		elementvalue_clsn = [ [30,'elementvalue_large'], [60, 'elementvalue_huge'] ].inject('elementvalue')  do  |mem,it|
			  percent > it[0] ? it[1]:mem
	    end
	    if (label_pos_y-percent_pos_y).abs < 10
			percent_pos_y -= 10 if percent_pos_y < label_pos_y
			percent_pos_y += 10 if percent_pos_y > label_pos_y
		end
        if(tot_angle > 270)
          g.textout(percent_pos_x,percent_pos_y+5, "#{percent}%", :class => elementvalue_clsn)
          g.textout(percent_pos_x,percent_pos_y+15, "#{mod.latest_formatted_val}", :class => 'elementlabel' )
        else
          g.textout(percent_pos_x,percent_pos_y, "#{percent}%", :class => elementvalue_clsn)
          g.textout(percent_pos_x,percent_pos_y+10, "#{mod.latest_formatted_val}", :class => 'elementlabel' )
        end
      end

      current_pos_x = new_pos_x
      current_pos_y = new_pos_y

      last_label_pos_y = label_pos_y
    end
  end

end
end
