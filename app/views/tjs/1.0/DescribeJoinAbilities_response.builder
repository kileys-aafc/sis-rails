xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8", :standalone=>"no"
xml.instruct! 'xml-stylesheet', :type=>"text/xsl", :href=>"#{@xsl}" if @xsl != ""
xml.tag!("JoinAbilities", 
"service".to_sym => "TJS", 
"version".to_sym => "1.0", 
"updateSupported".to_sym => "false", 
"xml:lang".to_sym => "#{@lang}", 
"xmlns".to_sym => "http://www.opengis.net/tjs/1.0", 
"xmlns:ows".to_sym => "http://www.opengis.net/ows/1.1", 
"xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance", 
"xmlns:xlink".to_sym => "http://www.w3.org/1999/xlink", 
"xsi:schemaLocation".to_sym => "http://www.opengis.net/tjs/1.0  /schemas/tjs/1.0/tjsDescribeJoinAbilities_response.xsd") do
  xml.SpatialFrameworks do
    for @framework in @frameworksArray
      xml.Framework do
        xml << render(:partial => 'tjs/1.0/gdas_write_framework')
      end # Framework
    end # for framework
  end # SpatialFrameworks
  xml.tag!("AttributeLimit", "#{@capabilitiesHash['OperationsMetadata']['JoinData']['AttributeLimit']}")
  xml.OutputMechanisms do
    for mechanism in @capabilitiesHash['OutputMechanisms'].keys
      xml.Mechanism do
        xml.tag!("Identifier", "#{mechanism}")
        xml.tag!("Title", "#{@capabilitiesHash['OutputMechanisms'][mechanism]['Title'][@lang]}")
        xml.tag!("Abstract", "#{@capabilitiesHash['OutputMechanisms'][mechanism]['Abstract'][@lang]}")
        xml.tag!("Reference", "#{@capabilitiesHash['OutputMechanisms'][mechanism]['Reference']}")
      end # Mechanism
    end # for mechanism
  end # OutputMechanisms
  xml.OutputStylings do
    for styling in @capabilitiesHash['OutputStylings'].keys
      xml.Styling do
        xml.tag!("Identifier", "#{styling}")
        xml.tag!("Title", "#{@capabilitiesHash['OutputStylings'][styling]['Title'][@lang]}")
        xml.tag!("Abstract", "#{@capabilitiesHash['OutputStylings'][styling]['Abstract'][@lang]}")
        xml.tag!("Reference", "#{@capabilitiesHash['OutputStylings'][styling]['Reference']}")
        xml.tag!("Schema", "#{@capabilitiesHash['OutputStylings'][styling]['Schema']}")
      end # Mechanism
    end # for mechanism
  end # OutputStylings
	xml.tag!("ClassificationSchemaURL",  "#{@capabilitiesHash['Classification']['Schema']}")
end # JoinAbilities



