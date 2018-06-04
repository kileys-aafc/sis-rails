xml.Placemark("id".to_sym=>"ID_00000") do
	xml.name("#{params[:framework].upcase} #{params[:version]} #{@poly_id}")
	xml.Snippet("")
	xml.description do
		xml.cdata!("<a href=\"http://#{request.host}/#{params[:rootdir]}/services/vector/#{params[:framework]}/#{params[:version]}/#{params[:region]}/cmp/#{@poly_id}.html\">Component data</a>")
	end
	xml.styleUrl("#PolyStyle00")
	xml << @polygon
end #Placemark
