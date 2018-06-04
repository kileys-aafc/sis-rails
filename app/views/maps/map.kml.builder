xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8", :standalone=>"no"
xml.tag!("kml",
"xmlns".to_sym => "http://www.opengis.net/kml/2.2", 
"xmlns:gx".to_sym => "http://www.google.com/kml/ext/2.2", 
"xsi:schemaLocation".to_sym => "http://www.opengis.net/kml/2.2 http://schemas.opengis.net/kml/2.2.0/ogckml22.xsd http://www.google.com/kml/ext/2.2 http://code.google.com/apis/kml/schema/kml22gx.xsd") do
	xml.GroundOverlay do
		xml.name("#{@map.title_en}_pic.kml")
		xml.Icon do
			xml.href("http://#{request.host}/cansis/publications/maps/#{@dir}/#{@dir.gsub("/","_")}_#{@map.mapsheet}.#{@map.format}")
			xml.viewBoundScale("0.75")
		end
		xml.LatLonBox do
			xml.north(@map.image_north)
			xml.south(@map.image_south)
			xml.east(@map.image_east)
			xml.west(@map.image_west)
		end
	end
end
