# get text strings
if @dir == "cansis" then
	mapsetTitle = @mapSet.title_en
	viewMap = "View the map"
	viewKml = "View the map via KML"
	viewDescription = "View the description"
else
	mapsetTitle = @mapSet.title_fr
	viewMap = "Voir la carte"
	viewKml = "Voir la carte via KML"
	viewDescription = "Voir la description"
end
# return results 
xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8", :standalone=>"no"
xml.tag!("kml",
"xmlns".to_sym => "http://www.opengis.net/kml/2.2", 
"xmlns:gx".to_sym => "http://www.google.com/kml/ext/2.2", 
"xsi:schemaLocation".to_sym => "http://www.opengis.net/kml/2.2 http://schemas.opengis.net/kml/2.2.0/ogckml22.xsd http://www.google.com/kml/ext/2.2 http://code.google.com/apis/kml/schema/kml22gx.xsd") do
  xml.tag!("Document", "id".to_sym=>"Mapset") do
		xml.name(mapsetTitle)
    xml.Snippet("maxlines".to_sym=>"0")
		
		xml.Style("id".to_sym=>"Mapsheet") do
			xml.LableStyle do
				xml.color("00000000")
				xml.scale("0.000000")
			end
			xml.LineStyle do
				xml.color("ff0000ff")
				xml.width("1.000000")
			end
			xml.PolyStyle do
				xml.color("7fffaaaa")
				xml.outline("1")
			end
		end #Style

#    xml.Folder("id".to_sym=>"FeatureLayer0") do
#			xml.name(mapsetTitle)
			for @map in @mapSheets do
				if @dir == "cansis" then mapTitle = @map.title_en else mapTitle = @map.title_fr end
				xml.Placemark("id".to_sym=>"ID_00000") do
					xml.name("#{mapTitle} (#{@map.mapsheet})")
					xml.Snippet(:maxLines=>"0")
					xml.description do
						if @map.description == "Y" then
							xml.cdata!("
							<table border=\"1\" cellpadding=\"5\" cellspacing=\"0\">
							<tr><td><a target=\"_blank\" href=\"http://#{request.host}/cansis/publications/maps/#{params[:mapgroup]}/#{params[:mapscale]}/#{params[:mapset]}/#{params[:mapgroup]}_#{params[:mapscale]}_#{params[:mapset]}_#{@map.mapsheet}.#{@map.format}\">#{viewMap}</a></td></tr>
							<tr><td><a target=\"_blank\" href=\"http://#{request.host}/cansis/publications/maps/#{params[:mapgroup]}/#{params[:mapscale]}/#{params[:mapset]}/#{params[:mapgroup]}_#{params[:mapscale]}_#{params[:mapset]}_#{@map.mapsheet}.kml\">#{viewKml}</a></td></tr>
							<tr><td><a target=\"_blank\" href=\"http://#{request.host}/cansis/publications/maps/#{params[:mapgroup]}/#{params[:mapscale]}/#{params[:mapset]}/#{params[:mapgroup]}_#{params[:mapscale]}_#{params[:mapset]}_#{@map.mapsheet}.pdf\">#{viewDescription}</a></td></tr>
							</table>")
						else
							xml.cdata!("
							<table border=\"1\" cellpadding=\"5\" cellspacing=\"0\"><tr bgcolor=\"#9CBCE2\">
							<tr><td><a target=\"_blank\" href=\"http://#{request.host}/cansis/publications/maps/#{params[:mapgroup]}/#{params[:mapscale]}/#{params[:mapset]}/#{params[:mapgroup]}_#{params[:mapscale]}_#{params[:mapset]}_#{@map.mapsheet}.#{@map.format}\">#{viewMap}</a></td></tr>
							<tr><td><a target=\"_blank\" href=\"http://#{request.host}/cansis/publications/maps/#{params[:mapgroup]}/#{params[:mapscale]}/#{params[:mapset]}/#{params[:mapgroup]}_#{params[:mapscale]}_#{params[:mapset]}_#{@map.mapsheet}.kml\">#{viewKml}</a></td></tr>
							</table>")
						end
					end
					xml.styleUrl("#Mapsheet")
					xml.Polygon do
						xml.tessellate("1")
						xml.outerBoundaryIs do
							xml.LinearRing do
								xml.coordinates("#{@map.map_west},#{@map.map_north} #{@map.map_west},#{@map.map_south} #{@map.map_east},#{@map.map_south} #{@map.map_east},#{@map.map_north} #{@map.map_west},#{@map.map_north}")
							end #LinearRing
						end #outerBoundaryIs
					end #Polygon
				end #Placemark

			end #for poly_id
#		end #Folder
		
  end #Document
end #kml

