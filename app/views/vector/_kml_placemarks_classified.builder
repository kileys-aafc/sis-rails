xml.tag!("Placemark", "id".to_sym=>"ID_00000") do
	xml.tag!("name", "#{params[:framework].singularize} #{@poly_id}")
	xml.tag!("Snippet", "")
	xml.tag!("description") do
		if @polygonsHash[@poly_id] then
			xml.cdata!("<b>#{@legendHash[@polygonsHash[@poly_id][:rating]]}</b><br/><br/>")
			xml.cdata!("<b>Framework:</b> #{@framework.title_en}<br/>")
			xml.cdata!("<b>Dataset:</b> #{@dataset.title_en}<br/>")
			xml.cdata!("<b>Attribute:</b> #{@attribute.attributedescription.title_en} <br/>")
			if @attribute.attributedescription.shortuom_en == "n/a" then
				xml.cdata!("<b>Value:</b> #{@polygonsHash[@poly_id][:value]}<br/>")
			else
				xml.cdata!("<b>Value:</b> #{@polygonsHash[@poly_id][:value]} #{@attribute.attributedescription.shortuom_en}<br/>")
			end
			if @polygonsHash[@poly_id][:percent]
				xml.cdata!("<b>Percent:</b> #{@polygonsHash[@poly_id][:percent]}<br/>")
			end
			xml.cdata!("<a href=\"http://#{request.host}/#{params[:rootdir]}/services/vector/#{params[:framework]}/#{params[:version]}/#{params[:region]}/#{params[:dataset]}/#{@poly_id}.html\">View data</a>")
		else
			xml.cdata!("No rating information")
		end
	end
	if @polygonsHash[@poly_id] then
		xml.styleUrl("#PolyStyle#{@polygonsHash[@poly_id][:rating]}")
	else
		xml.styleUrl("#PolyStyle00")
	end
	xml << @polygon
end #Placemark
