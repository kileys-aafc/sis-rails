xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8", :standalone=>"no"
xml.instruct! 'xml-stylesheet', :type=>"text/xsl", :href=>"#{@xsl}" if @xsl != ""
xml.tag!("FrameworkKeyDescription", 
"service".to_sym => "TJS", 
"version".to_sym => "1.0", 
"xml:lang".to_sym => "#{@lang}", 
"xmlns".to_sym => "http://www.opengis.net/tjs/1.0", 
"xmlns:ows".to_sym => "http://www.opengis.net/ows/1.1", 
"xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance", 
"xmlns:xlink".to_sym => "http://www.w3.org/1999/xlink", 
"xsi:schemaLocation".to_sym => "http://www.opengis.net/tjs/1.0  /schemas/tjs/1.0/tjsDescribeKey_response.xsd") do
  for @framework in @frameworksArray
    xml.Framework do
      xml << render(:partial => 'tjs/1.0/gdas_write_framework')
      xml.Rowset do 
        if (@datasetsArray.size == 0)
          for row in @dataArray
            xml.Row do
              k=row.send "#{framework.FrameworkKey}" ;   xml.tag!("K", "#{k}")
            end # Row  
          end # for row
        end # if
        if (@datasetsArray.size == 1)
          keyTitleFieldName=@datasetsArray[0].send "KeyTitle#{@lang_extension}"
          for row in @dataArray
            xml.Row do
              k=row.send "#{@datasetsArray[0].DatasetKey}" ;   xml.tag!("K", "#{k}")
              title=row.send "#{keyTitleFieldName}" ;   xml.tag!("Title", "#{title}")
            end # Row  
          end # for row
        end # if 
      end # Rowset
    end # Framework
  end # for framework
end #GDAS
