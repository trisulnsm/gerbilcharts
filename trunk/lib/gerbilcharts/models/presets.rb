module GerbilCharts::Models

# Presets base class for all ranges
#
# Preset values for ranges. So we do not scale charts arbitrarily
# and the label values are neat and clean
#
class Presets

public
    PRESETS = [ 
              [0,0],  [1,0.2], [5,1],  [10,1],[20,5],
              [50,10],[100,25],[200,50], [500,100], [1000,200], 
              [2000,500],   [5000,1000], [8000,2000], [10000,2000],
              [20000,5000],  [50000,10000], [100000,25000], [200000,50000],
              [500000,100000],[800000,200000],
              [1000000,200000],[2000000,500000], [3000000,500000], [4000000,1000000],
              [5000000,1000000],[6000000, 1000000], 
	          [8000000,2000000], [10000000,2000000], [20000000,5000000], [50000000, 10000000],
              [100000000,25000000], [200000000,50000000], [500000000,100000000], 
			  [1000000000, 250000000] , [3000000000, 1000000000] , [5000000000, 1000000000] ,
              [10000000000,2000000000] ,
            ]
            
    TIMEPRESETS = [ 
              [0,0],  [1,0.2], [5,1],  [10,1],[20,5],
              [30,10],[60,10],[120,15], [300,60], [600,120], 
              [900,300], [1800,300], 
              [3600,900], [7200,1800],[10800,3600], [14400,3600], [21600,7200],
              [43200, 10800],   [86400,21600],
              [172800, 43200],  [259200,86400],
              [604800,  86400], [1209600,172800], 
              [2419200, 604800],
              [4848400, 604800],
              [7257600, 2419200],
              [14515200,7257600],
              [29030400,7257600],
            ]  
            
    UNITPRESETS = [
              [1e+12, "T"],
              [1e+09, "G"],
              [1e+06, "M"],
              [1e+03, "K"],
              [1,     ""],
              [1e-03, "m"],
              [1e-06, "u"],
              [1e-09, "n"],
              [1e-12, "p"],
            ]
            
   PRESET_VAL_POS=0
   PRESET_LABEL_POS=1
             
             
  # Formats a number with a units suffix
  #    So a number like 11899833 = 11.90 M 
  def format_suffix raw_value
    return "0" if raw_value == 0
    UNITPRESETS.each do |unit|
          if raw_value.abs  >= unit[0]
            retval = raw_value  / unit[0]
            sout=format("%.1f%s", retval, unit[1])
            sout.gsub! "\.0",""
            return sout
          end
    end
    return raw_value.to_s
  end
     
  # Formats a time value : based on available interval
  #    tvsec = seconds since Jan 1 1970
  #    interval = desired window in seconds
  def format_timeval ( tvsec, interval)   
    t = Time.at(tvsec).getlocal

    if t.hour + t.min == 0 
	return t.strftime("%b-%d") 
    end

    if interval < 60 
      return t.strftime("%M:%S")
    elsif interval < 300
      return t.strftime("%M:%S")
    elsif interval < 3600
      return t.strftime("%H:%M")
    elsif interval < 86400
      return t.strftime("%H:%M")
    elsif interval < 259200
      return t.strftime("%H:%M")
    elsif interval < 604800
      return t.strftime("%b-%d")
    elsif interval < 2419200
      return t.strftime("%b-%d")
    else
      return t.strftime("%b")
    end
  end
end

end
