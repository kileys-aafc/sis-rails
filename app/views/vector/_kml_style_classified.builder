for style in @classificationArray.concat(@exceptionsArray) do
	xml.Style("id".to_sym=>"PolyStyle#{style[:identifier]}") do
		xml.LabelStyle do
			xml.color("00000000")
			xml.scale("0.000000")
		end
		xml.LineStyle do
			xml.color("ff0000ff")
			xml.width("2.000000")
		end
		xml.PolyStyle do
			xml.color("99"+style[:color][4..5]+style[:color][2..3]+style[:color][0..1])
			xml.outline("1")
		end
	end #Style
end
