require 'rexml/document'

module GerbilCharts::SVGDC

# = CssInliner - dead simple css inliner
#
class CssInliner 
  
  attr_reader		:class_table
  attr_reader		:selector_table

  # need a css string
  def initialize(css_string)

	css_string.tr!("\r\n\t","")
	@class_table = {}
	@selector_table  = {}

	css_string.split('}').each do |rec|

			parts = rec.split('{')
			parts.each { |p| p.strip!; p.squeeze!(' ');}

			case  parts[0][0]
				when '#'; @selector_table.store(parts[0][1..-1],parts[1])
				when '.'; @class_table.store(parts[0][1..-1],parts[1])
			end
	end
  end


  # inline_doc
  # 	inline the incoming svg string using the css
  # return
  # 	the transformed svg string with inlined styles
 def inline_doc(doc_string)
	rxdoc = REXML::Document.new doc_string 
	proc_ele(rxdoc.root)
	return rxdoc.to_s
 end


private


	def proc_ele(ele)
		ele.each_element_with_attribute('id') { |e| inline_style(e,e.attributes['id'],@selector_table) }
		ele.each_element_with_attribute('class') { |e| inline_style(e,e.attributes['class'],@class_table) }
		ele.each_element { |e| proc_ele(e)}
	end

	def inline_style(ele, key, tbl)
		stylestr  = tbl[key]
		ele.add_attribute('style',stylestr) if stylestr
	end
  
end

end
