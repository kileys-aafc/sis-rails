xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8", :standalone=>"no"
xml.tag!("tjs:Capabilities", 
"service".to_sym => "TJS", 
"version".to_sym => "1.0", 
"xml:lang".to_sym => "#{@lang}", 
"xmlns:tjs".to_sym => "http://www.opengis.net/tjs/1.0", 
"xmlns:ows".to_sym => "http://www.opengis.net/ows/1.1", 
"xmlns:xlink".to_sym => "http://www.w3.org/1999/xlink",
"xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance", 
"xsi:schemaLocation".to_sym => "http://www.opengis.net/tjs/1.0 /schemas/tjs/1.0/tjsGetCapabilities_response.xsd") do
  xml.ows:ServiceIdentification do
    xml.tag!("ows:Title", "#{@capabilitiesHash['Languages'][@lang]['ServiceIdentification']['Title']}")
    xml.tag!("ows:Abstract", "#{@capabilitiesHash['Languages'][@lang]['ServiceIdentification']['Abstract']}")
    xml.ows:Keywords do
      for keyword in @capabilitiesHash['Languages'][@lang]['ServiceIdentification']['Keywords']
        xml.tag!("ows:Keyword", "#{keyword}")
      end
    end
    xml.tag!("ows:ServiceType", "TJS")
    xml.tag!("ows:ServiceTypeVersion", "1.0.0")
    xml.tag!("ows:Fees", "#{@capabilitiesHash['Languages'][@lang]['ServiceIdentification']['Fees']}")
    xml.tag!("ows:AccessConstraints", "#{@capabilitiesHash['Languages'][@lang]['ServiceIdentification']['AccessConstraints']}")
  end

  xml.ows:ServiceProvider do
    xml.tag!("ows:ProviderName", "#{@capabilitiesHash['Languages'][@lang]['ServiceProvider']['ProviderName']}")
    xml.tag!("ows:ProviderSite", "xlink:href".to_sym => "#{@capabilitiesHash['Languages'][@lang]['ServiceProvider']['ProviderSite']}")
    xml.ows:ServiceContact do
      xml.tag!("ows:IndividualName", "#{@capabilitiesHash['Languages'][@lang]['ServiceProvider']['ServiceContact']['IndividualName']}")
      xml.tag!("ows:PositionName", "#{@capabilitiesHash['Languages'][@lang]['ServiceProvider']['ServiceContact']['PositionName']}")
      xml.ows:ContactInfo do
        xml.ows:Phone do
          xml.tag!("ows:Voice", "#{@capabilitiesHash['Languages'][@lang]['ServiceProvider']['ServiceContact']['ContactInfo']['Phone']['Voice']}")
          xml.tag!("ows:Facsimile", "#{@capabilitiesHash['Languages'][@lang]['ServiceProvider']['ServiceContact']['ContactInfo']['Phone']['Facsimile']}")
        end   # Phone
        xml.tag!("ows:Address") do
          xml.tag!("ows:DeliveryPoint", "#{@capabilitiesHash['Languages'][@lang]['ServiceProvider']['ServiceContact']['ContactInfo']['Address']['DeliveryPoint']}")
          xml.tag!("ows:City", "#{@capabilitiesHash['Languages'][@lang]['ServiceProvider']['ServiceContact']['ContactInfo']['Address']['City']}")
          xml.tag!("ows:AdministrativeArea", "#{@capabilitiesHash['Languages'][@lang]['ServiceProvider']['ServiceContact']['ContactInfo']['Address']['AdministrativeArea']}")
          xml.tag!("ows:PostalCode", "#{@capabilitiesHash['Languages'][@lang]['ServiceProvider']['ServiceContact']['ContactInfo']['Address']['PostalCode']}")
          xml.tag!("ows:Country", "#{@capabilitiesHash['Languages'][@lang]['ServiceProvider']['ServiceContact']['ContactInfo']['Address']['Country']}")
          xml.tag!("ows:ElectronicMailAddress", "#{@capabilitiesHash['Languages'][@lang]['ServiceProvider']['ServiceContact']['ContactInfo']['Address']['ElectronicMailAddress']}")
        end   # Address
      end   # ContactInfo
    end   # ServiceContact
  end   # ServiceProvider

  xml.tag!("ows:OperationsMetadata") do
    xml.tag!("ows:Operation", "name".to_sym => "GetCapabilities") do
      xml.tag!("ows:DCP") do
        xml.tag!("ows:HTTP") do
          xml.tag!("ows:Get", "xlink:href".to_sym => @rootURL)
        end         # HTTP
      end         # DCP
    end         # Operation
    xml.tag!("ows:Operation", "name".to_sym => "DescribeFrameworks") do
      xml.tag!("ows:DCP") do
        xml.tag!("ows:HTTP") do
          xml.tag!("ows:Get", "xlink:href".to_sym => @rootURL)
        end         # HTTP
      end         # DCP
    end         # Operation
    xml.tag!("ows:Operation", "name".to_sym => "DescribeDatasets") do
      xml.tag!("ows:DCP") do
        xml.tag!("ows:HTTP") do
          xml.tag!("ows:Get", "xlink:href".to_sym => @rootURL)
        end         # HTTP
      end         # DCP
    end         # Operation
    xml.tag!("ows:Operation", "name".to_sym => "DescribeData") do
      xml.tag!("ows:DCP") do
        xml.tag!("ows:HTTP") do
          xml.tag!("ows:Get", "xlink:href".to_sym => @rootURL)
        end         # HTTP
      end         # DCP
    end         # Operation
    xml.tag!("ows:Operation", "name".to_sym => "GetData") do
      xml.tag!("ows:DCP") do
        xml.tag!("ows:HTTP") do
          xml.tag!("ows:Get", "xlink:href".to_sym => @rootURL)
        end         # HTTP
      end         # DCP
      xml.tag!("ows:Constraint", "name".to_sym => "GeolinkidsLimit") do
        xml.tag!("ows:AllowedValues") do
          xml.tag!("ows:Range") do
            xml.tag!("ows:MaximumValue", "#{@capabilitiesHash['OperationsMetadata']['GetData']['GeolinkidsLimit']}")
          end         # Range
        end         # AllowedValues
        xml.tag!("ows:Meaning", "The maximum number of Keys that can be included in the LinkageKeys element of a GetData request.")
      end         # Constraint
      xml.tag!("ows:Constraint", "name".to_sym => "AttributeLimit") do
        xml.tag!("ows:AllowedValues") do
          xml.tag!("ows:Range") do
            xml.tag!("ows:MaximumValue", "#{@capabilitiesHash['OperationsMetadata']['GetData']['AttributeLimit']}")
          end         # Range
        end         # AllowedValues
        xml.tag!("ows:Meaning", "The maximum number of Attributes that can be included as part of one GetData request.")
      end         # Constraint
    end         # Operation
    xml.tag!("ows:Operation", "name".to_sym => "DescribeJoinAbilities") do
      xml.tag!("ows:DCP") do
        xml.tag!("ows:HTTP") do
          xml.tag!("ows:Get", "xlink:href".to_sym => @rootURL)
        end         # HTTP
      end         # DCP
    end         # Operation
    xml.tag!("ows:Operation", "name".to_sym => "DescribeKey") do
      xml.tag!("ows:DCP") do
        xml.tag!("ows:HTTP") do
          xml.tag!("ows:Get", "xlink:href".to_sym => @rootURL)
        end         # HTTP
      end         # DCP
    end         # Operation
    xml.tag!("ows:Operation", "name".to_sym => "JoinData") do
      xml.tag!("ows:DCP") do
        xml.tag!("ows:HTTP") do
          xml.tag!("ows:Get", "xlink:href".to_sym => @rootURL)
        end         # HTTP
      end         # DCP
      xml.tag!("ows:Constraint", "name".to_sym => "AttributeLimit") do
        xml.tag!("ows:AllowedValues") do
          xml.tag!("ows:Range") do
            xml.tag!("ows:MaximumValue", "#{@capabilitiesHash['OperationsMetadata']['JoinData']['AttributeLimit']}")
          end         # Range
        end         # AllowedValues
        xml.tag!("ows:Meaning", "The maximum number of Attributes that can be included as part of one JoinData request.")
      end         # Constraint
    end         # Operation
  end        # OperationsMetadata

  xml.tag!("tjs:Languages") do
    for language in @capabilitiesHash['Languages'].keys
      xml.tag!("ows:Language", "#{language}")
    end
  end
end

