# return results 
xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8", :standalone=>"no"
xml.tag!("JoinDataResponse", 
  "service".to_sym => "TJS", 
  "version".to_sym => "1.0", 
  "xml:lang".to_sym => "en-CA", 
  "xmlns".to_sym => "http://www.opengis.net/tjs/1.0", 
  "xmlns:ows".to_sym => "http://www.opengis.net/ows/1.1", 
  "xmlns:xlink".to_sym => "http://www.w3.org/1999/xlink", 
  "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance", 
  "xsi:schemaLocation".to_sym => "http://www.opengis.net/tjs/1.0  /schemas/tjs/1.0/tjsJoinData_response.xsd") do
  xml.tag!("ServiceInstance", "http://foo.bar/foo")
  xml.tag!("StatusLocation", "http://foo.bar/foo")
  t=Time.now.gmtime.strftime("%Y-%m-%dT%H:%M:%SZ")
  xml.tag!("Status", "creationTime".to_sym => t) do
    xml.Completed
  end
  xml.DataSources do
    xml.Framework do
			@framework = @all_frameworks[0]
			xml << render (:partial => 'tjs/1.0/gdas_write_framework')
			xml.Dataset do
				@lang_extension = ""
				xml << render (:partial => 'tjs/1.0/gdas_write_dataset')
				xml.Columnset do
					xml << render(:partial => 'tjs/1.0/gdas_write_columnset')
				end #xml.Attributes
			end #xml.Dataset
    end # xml.Framework
  end #xml.DataSources
  xml.JoinedOutputs do
    for mechanism in @capabilitiesHash['OutputMechanisms'].keys 
      xml.Output do
        xml.Mechanism do
					xml.tag!("Identifier", "#{mechanism}")
					xml.tag!("Title", "#{@capabilitiesHash['OutputMechanisms'][mechanism]['Title'][@lang]}")
					xml.tag!("Abstract", "#{@capabilitiesHash['OutputMechanisms'][mechanism]['Abstract'][@lang]}")
					xml.tag!("Reference", "#{@capabilitiesHash['OutputMechanisms'][mechanism]['Reference']}")
				end # Mechanism
				xml.Resource do
					if mechanism == "WMS" then
						xml.tag!("URL",  "http://#{@domainName}/cgi-bin/tjs_tmp/#{@directory.tmpDirName}/wms")
							xml.tag!("Parameter",  @domainName, "name".to_sym => "domainName")
							xml.tag!("Parameter",  @framework['ShapeName'].downcase, "name".to_sym => "layerName")
							xml.tag!("Parameter",  @directory.tmpDirName, "name".to_sym => "tmpDirName")
					elsif mechanism == "shapefile" then
						xml.tag!("URL",  "http://#{@domainName}/theURLfortheShapefile")
					end
				end # xml.Resource
      end # Output
    end # for mechanism
  end # of xml.JoinedOutput
end # of xml.JoinDataResponse
