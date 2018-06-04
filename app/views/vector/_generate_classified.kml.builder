# return results 
xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8", :standalone=>"no"
xml.tag!("kml",
"xmlns".to_sym => "http://www.opengis.net/kml/2.2", 
"xmlns:gx".to_sym => "http://www.google.com/kml/ext/2.2", 
"xsi:schemaLocation".to_sym => "http://www.opengis.net/kml/2.2 http://schemas.opengis.net/kml/2.2.0/ogckml22.xsd http://www.google.com/kml/ext/2.2 http://code.google.com/apis/kml/schema/kml22gx.xsd") do
  xml.Document("id".to_sym=>@framework.framework_name) do
		if params[:title].blank? then
			if @poly_ids.size > 1 then
				if params[:value] then
					if params[:value] == "dominant" then
						if @lang=="en" then
							name = "#{@framework.title_en}: Dominant #{@attribute.attributedescription.title_en}"
						else
							name = "#{@framework.title_fr}: Dominant #{@attribute.attributedescription.title_fr}"
						end
					else
						if @lang=="en" then
							name = "#{@framework.title_en}: #{@attribute.attributedescription.title_en} = #{params[:value]}"
						else
							name = "#{@framework.title_fr}: #{@attribute.attributedescription.title_fr} = #{params[:value]}"
						end
					end
				elsif @attributesHash then
					name = "#{@framework.framework_name}: #{@attributesHash[@attributesHash.keys[0]][:Description].attributedescription.title_en}"
				else
					name = "#{@framework.framework_name} #{params[:version]} polygons: #{params[:polygonset]}"
				end
			else
				name = "#{@framework.framework_name} #{params[:version]} polygon: #{params[:poly_id]}"
			end
		else
			name = params[:title]
		end
		xml.name(name)
    xml.Snippet(:maxlines=>0)
		xml.ScreenOverlay do
			xml.name("Legend")
			xml.color("b0ffffff")
			xml.Icon do
				xml.href(@legendname)
			end
			xml.overlayXY(:x=>"0",:y=>"1",:xunits=>"fraction",:yunits=>"fraction")
			xml.screenXY(:x=>"0",:y=>"1",:xunits=>"fraction",:yunits=>"fraction")
		end # ScreenOverlay
    xml.Folder("id".to_sym=>"FeatureLayer0") do
			xml.name("Map")
			xml.Snippet("")
			for @poly_id in @poly_ids do
				coordinatesArray = File.open("/production/geodata/#{params[:framework]}/#{params[:version]}/#{params[:region]}/kml/#{@poly_id}","r").readlines
				for @polygon in coordinatesArray do
					xml << render("kml_placemarks_classified")
				end #for polygon
			end #for poly_id
		end #Folder
		xml << render("kml_style_classified")
  end #Document
end #kml
