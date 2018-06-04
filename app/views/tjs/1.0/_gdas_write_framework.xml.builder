    xml.FrameworkURI(@framework.frameworkuri)
    content=@framework.send "organization#{@lang_extension}"
      xml.tag!("Organization", "#{content}")
    content=@framework.send "title#{@lang_extension}"
      xml.tag!("Title", "#{content}")
    content=@framework.send "abstract#{@lang_extension}"
      xml.tag!("Abstract", "#{content}")
		if @framework.startdate == "" then
			xml.ReferenceDate(@framework.referencedate)
		else
			xml.tag!("ReferenceDate", "#{@framework.referencedate}", "startDate".to_sym => "#{@framework.startdate}")
		end
		xml.Version(@framework.version)
    content=@framework.send "documentation#{@lang_extension}"
      xml.tag!("Documentation", "#{content}")
    xml.FrameworkKey do
			xml.Column("name" => @framework.frameworkkey, "type".to_sym => "http://www.w3.org/TR/xmlschema-2/##{@framework.frameworkkeytype}", "length".to_sym => "#{@framework.frameworkkeylength}", "decimals".to_sym => "#{@framework.frameworkkeydecimals}")
		end
    xml.BoundingCoordinates do
			xml.North(@framework.maxlat)
			xml.South(@framework.minlat)
			xml.East(@framework.maxlong)
			xml.West(@framework.minlong)
    end
		xml.DescribeDatasetsRequest("xlink:href".to_sym => (@rootURL  +"?Service=TJS&Version=1.0&Request=DescribeDatasets&FrameworkURI=" + CGI.escape(@framework.frameworkuri) ) )