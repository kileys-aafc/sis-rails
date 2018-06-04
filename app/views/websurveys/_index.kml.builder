# encoding: iso-8859-1
# set text strings
if @dir == "cansis" then
	viewReport = "View report"
	noReport = "Not available"
	legend = "Legend"
	map = "Map"
	popupName  = "Soil Surveys"
	report = "Report"
	date = "Date"
	scale = "Scale"
else
	viewReport = "Voir l'étude"
	noReport = "Pas disponible"
	legend = "Légende"
	map = "Carte"
	popupName  = "Études pédologique"
	report = "Étude"
	date = "Date"
	scale = "Échelle"
end
# return results 
xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8", :standalone=>"no"
xml.tag!("kml",
"xmlns".to_sym => "http://www.opengis.net/kml/2.2") do
	xml.tag!("Document", "id".to_sym=>"Mapset") do
		xml.name(@mapsetTitle)
		xml.Snippet("maxlines".to_sym=>"0")
		
		xml.Folder(:id=>"legend") do
			xml.ScreenOverlay(:id=>"legend") do
				if @dir == "cansis" then xml.name("Upper Left") else xml.name("En haut à gauche") end
				xml.color("b0ffffff")
				xml.Icon do
					xml.href(@legendname)
				end
				xml.overlayXY(:x=>"0.01", :y=>"0.99", :xunits=>"fraction", :yunits=>"fraction")
				xml.screenXY(:x=>"0.01", :y=>"0.99", :xunits=>"fraction", :yunits=>"fraction")
			end
		end

    xml.Folder("id".to_sym=>"FeatureLayer0") do
			xml.name(map)
			for @region in @surveys do
				coordinatesArray = File.open("/production/geodata/surveyindex/v2/canada/kml/#{@region.index_id}","r").readlines
				for polygon in coordinatesArray do
					xml.Placemark("id".to_sym=>"ID_00000") do
						xml.name(popupName)
						xml.Snippet(:maxLines=>"0")
						xml.description do
							xml << "<![CDATA["
							xml << "<table border=\"1\" cellpadding=\"5\" cellspacing=\"0\">"
							xml << "<tr><th>#{report}</th><th>#{date}</th><th>#{scale}</th></tr>"
							if @region.scan1 == true then
								xml << "<tr><td>#{@region.report_id1}</td><td>#{@region.vintage1}</td><td>#{@region.scale1}</td><td><a target=\"_blank\" href=\"http://sis.agr.gc.ca/#{@dir}/publications/surveys/#{@region.report_id1[0..1].downcase}/#{@region.report_id1.downcase}/index.html\">#{viewReport}</a></td></tr>"
							else
								if @region.report_id1 == "ABAG30" then
									xml << "<tr><td>#{@region.report_id1}</td><td>#{@region.vintage1}</td><td>#{@region.scale1}</td><td><a href=\"http://www1.agric.gov.ab.ca/$department/deptdocs.nsf/all/sag10372\">AGRASID</a></td></tr>"
								else
									xml << "<tr><td>#{@region.report_id1}</td><td>#{@region.vintage1}</td><td>#{@region.scale1}</td><td>#{noReport}</td></tr>"
								end
							end
							if @region.report_id2 != "" then
								if @region.scan2 == true then
									xml << "<tr><td>#{@region.report_id2}</td><td>#{@region.vintage2}</td><td>#{@region.scale2}</td><td><a target=\"_blank\" href=\"http://sis.agr.gc.ca/#{@dir}/publications/surveys/#{@region.report_id2[0..1].downcase}/#{@region.report_id2.downcase}/index.html\">#{viewReport}</a></td></tr>"
								else
									if @region.report_id3 == "ABAG30" then
										xml << "<tr><td>#{@region.report_id2}</td><td>#{@region.vintage2}</td><td>#{@region.scale2}</td><td><a href=\"http://www1.agric.gov.ab.ca/$department/deptdocs.nsf/all/sag10372\">AGRASID</a></td></tr>"
									else
										xml << "<tr><td>#{@region.report_id2}</td><td>#{@region.vintage2}</td><td>#{@region.scale2}</td><td>#{noReport}</td></tr>"
									end
								end
							end
							if @region.report_id3 != "" then
								if @region.scan3 == true then
									xml << "<tr><td>#{@region.report_id3}</td><td>#{@region.vintage3}</td><td>#{@region.scale3}</td><td><a target=\"_blank\" href=\"http://sis.agr.gc.ca/#{@dir}/publications/surveys/#{@region.report_id3[0..1].downcase}/#{@region.report_id3.downcase}/index.html\">#{viewReport}</a></td></tr>"
								else
									if @region.report_id3 == "ABAG30" then
										xml << "<tr><td>#{@region.report_id3}</td><td>#{@region.vintage3}</td><td>#{@region.scale3}</td><td><a href=\"http://www1.agric.gov.ab.ca/$department/deptdocs.nsf/all/sag10372\">AGRASID</a></td></tr>"
									else
										xml << "<tr><td>#{@region.report_id3}</td><td>#{@region.vintage3}</td><td>#{@region.scale3}</td><td>#{noReport}</td></tr>"
									end
								end
							end
							xml << "</table>"
							xml << "]]>"
						end
						case params[:map]
							when "scanned" then xml.styleUrl("##{@region.scanned}")
							when "scale" then xml.styleUrl("##{@region.scale}")
							when "vintage" then xml.styleUrl("##{@region.vintage}")
						end
						xml << polygon
					end #Placemark
				end # for polygon
			end #for region
		end #Folder
		
		classesXmlArray = @legend.search("//Legend/Classes/Class")
			for classx in classesXmlArray do
			xml.Style("id".to_sym=>classx.search("@identifier").first.value) do
				xml.LableStyle do
					xml.color("00000000")
					xml.scale("0.000000")
				end
				xml.LineStyle do
					xml.color("ff0000ff")
					xml.width("1.000000")
				end
				xml.PolyStyle do
					color = classx.search("@color").first.value
					xml.color("7f"+color[4..5]+color[2..3]+color[0..1])
					xml.outline("1")
				end
			end #Style
		end

	end #Document
end #kml
