# encoding: iso-8859-1
# return results 
xml.instruct!(:xml, :version=>"1.0", :encoding=>"UTF-8", :standalone=>"no")
xml.instruct!("xml-stylesheet".to_sym, :type=>"text/xsl", :href=>"/schemas/legend/2.0/stylesheets/legend2html.xsl")
exceptionClasses = false
xml.tag!("Legend",
:version => "2.0", 
"xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance", 
"xsi:noNamespaceSchemaLocation".to_sym => "/schemas/legend/2.0/legend.xsd") do
	xml.Title("Legend for " + @attribute.titleprefix_en + @attributedescription.title_en + @attribute.titlesuffix_en)
	xml.Abstract(@attributedescription.abstract_en)
	xml.Classes(
		:type=>@attributedescription.kind, 
		:title_en=> @attribute.titleprefix_en + @attributedescription.title_en + @attribute.titlesuffix_en,
		:title_fr=> @attribute.titleprefix_fr + @attributedescription.title_fr + @attribute.titlesuffix_fr) do

		for valuegroup in @valuegroups do
			for value in @values do
				if value.nullvalue =="false" then
					xml.Class(:rank=>value.rank, :identifier=>value.identifier, :color=>value.color, :title_en=>value.title_en, :title_fr=>value.title_fr)
				else 
					exceptionClasses = true
				end
			end # for value
		end # for valuegroup
	end # Classes
	if exceptionClasses == true then
		xml.Exceptions do
			for value in @values do
				if value.nullvalue =="true" then
					xml.Class(:identifier=>value.identifier, :color=>value.color, :title_en=>value.title_en, :title_fr=>value.title_fr)
				end
			end # for value
		end # Exceptions
	end
end #Legend
