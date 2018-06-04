# return results 
xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8", :standalone=>"no"
xml.tag!("kml",
"xmlns".to_sym => "http://www.opengis.net/kml/2.2", 
"xmlns:gx".to_sym => "http://www.google.com/kml/ext/2.2", 
"xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance", 
"xsi:schemaLocation".to_sym => "http://www.opengis.net/kml/2.2 http://schemas.opengis.net/kml/2.2.0/ogckml22.xsd http://www.google.com/kml/ext/2.2 http://code.google.com/apis/kml/schema/kml22gx.xsd") do
  xml.tag!("Document", "id".to_sym=>"SLC_Boundaries") do
		if params[:title].blank? then
			if @poly_ids.size > 1 then
				if @attributesHash then
					name = "#{@framework.framework_name}: #{@attributesHash[@attributesHash.keys[0]][:Description].gattributedescription.Title}"
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
    xml.Snippet("")
    xml.tag!("Folder", "id".to_sym=>"FeatureLayer0") do
			xml.name("#{@framework.framework_name}")
			xml.Snippet("")
			for @poly_id in @poly_ids do
				coordinatesArray = File.open("/production/geodata/#{params[:framework]}/#{params[:version]}/#{params[:region]}/kml/#{@poly_id}","r").readlines
				for @polygon in coordinatesArray do
					xml << render("kml_placemarks_plain")
				end #for polygon
			end #for poly_id
		end #Folder
		xml << render("kml_style_plain")
  end #Document
end #kml
