    xml.DatasetURI(@dataset.dataseturi)
    content=@dataset.send "organization#{@lang_extension}"
      xml.tag!("Organization", "#{content}")
    content=@dataset.send "title#{@lang_extension}"
      xml.tag!("Title", "#{content}")
    content=@dataset.send "abstract#{@lang_extension}"
      xml.tag!("Abstract", "#{content}")
		if @dataset.startdate == "" then
			xml.ReferenceDate(@dataset.referencedate)
		else
			xml.tag!("ReferenceDate", "#{@dataset.referencedate}", "startDate".to_sym => "#{@dataset.startdate}")
		end
    xml.Version(@dataset.version)
    content=@dataset.send "documentation#{@lang_extension}"
      xml.tag!("Documentation", "#{content}")
		xml.DescribeDataRequest("xlink:href".to_sym => (@rootURL  +"?Service=TJS&Version=1.0&Request=DescribeData&FrameworkURI=" + CGI.escape(@framework.frameworkuri) + "&DatasetURI=" + CGI.escape(@dataset.dataseturi) ) )