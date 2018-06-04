xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8", :standalone=>"no"
xml.instruct! 'xml-stylesheet', :type=>"text/xsl", :href=>"#{@xsl}" if @xsl != ""
xml.tag!("DataDescriptions", 
"service".to_sym => "TJS", 
"version".to_sym => "1.0", 
"capabilities".to_sym => (@rootURL  +"?Service=TJS&Version=1.0&Request=GetCapabilities") ,
"xml:lang".to_sym => "#{@lang}", 
"xmlns".to_sym => "http://www.opengis.net/tjs/1.0", 
"xmlns:ows".to_sym => "http://www.opengis.net/ows/1.1", 
"xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance", 
"xmlns:xlink".to_sym => "http://www.w3.org/1999/xlink", 
"xsi:schemaLocation".to_sym => "http://www.opengis.net/tjs/1.0  /schemas/tjs/1.0/tjsDescribeData_response.xsd") do
  for @framework in @frameworksArray
    xml.Framework do
      xml << render(:partial => 'tjs/1.0/gdas_write_framework')
      for @dataset in @datasetsArray 
        xml.Dataset do
          xml << render(:partial => 'tjs/1.0/gdas_write_dataset')
					xml.Columnset do
						xml << render(:partial => 'tjs/1.0/gdas_write_columnset')
					end # Columnset
				end # Dataset
      end # for dataset
    end # Framework
  end # for framework
end # DataDescriptions
