xml.FrameworkKey("complete".to_sym => @dataset.keycomplete, "relationship".to_sym => @dataset.keyrelationship) do
	xml.Column("name".to_sym => @dataset.frameworkkey, "type".to_sym => "http://www.w3.org/TR/xmlschema-2/##{@dataset.keytype}", "length".to_sym => @dataset.keylength, "decimals".to_sym => @dataset.keydecimals)
end
xml.Attributes do
	for @requestedAttribute in @attributeNamesArray do
		# subset classes and values arrays
		@attribute = @allAttributesHash[@requestedAttribute][:Description]
		@classHash = @allAttributesHash[@requestedAttribute][:Class]
		@valuesArray = @allAttributesHash[@requestedAttribute][:Values]
		@nullsArray = @allAttributesHash[@requestedAttribute][:Nulls]
	# write out XML
		xml.Column("name".to_sym=>eval("@attribute.attributename#{@lang_extension}"), "type".to_sym=>"http://www.w3.org/TR/xmlschema-2/##{@attribute.datatype}", "length".to_sym=>@attribute.length, "decimals".to_sym=>@attribute.decimals, "purpose".to_sym=>@attribute.purpose) do
			xml.Title(eval("@attribute.titleprefix#{@lang_extension}") + " " + eval("@attribute.attributedescription.title#{@lang_extension}") + " " + eval("@attribute.titlesuffix#{@lang_extension}"))
			xml.Abstract(eval("@attribute.attributedescription.abstract#{@lang_extension}"))
			xml.Documentation(eval("@attribute.attributedescription.documentation#{@lang_extension}"))
			xml.Values do
				if @attribute.attributedescription.kind == "Count"
					xml.Count() do
						xml.UOM do
							xml.ShortForm(eval("@attribute.attributedescription.shortuom#{@lang_extension}"))
							xml.LongForm(eval("@attribute.attributedescription.longuom#{@lang_extension}"))
						end
						if @nullsArray != [] # display the exception values
							xml.Exceptions do
								for null in @nullsArray
									xml.Null("color".to_sym => null.color) do
										xml.Identifier(null.Identifier)
										xml.Title(eval("null.title#{@lang_extension}"))
										xml.Abstract(eval("null.abstract#{@lang_extension}"))
										xml.Documentation(eval("null.documentation#{@lang_extension}"))
									end # Null
								end # for null
							end # Exceptions
						end # if @nullsArray
					end # Count
				elsif @attribute.attributedescription.kind == "Measure"
					xml.Measure do
						xml.UOM do
							xml.ShortForm(eval("@attribute.attributedescription.shortuom#{@lang_extension}"))
							xml.LongForm(eval("@attribute.attributedescription.longuom#{@lang_extension}"))
						end
						if @nullsArray != [] # display the exception values
							xml.Exceptions do
								for null in @nullsArray
									xml.Null("color".to_sym => null.color) do
										xml.Identifier(null.identifier)
										xml.Title(eval("null.title#{@lang_extension}"))
										xml.Abstract(eval("null.abstract#{@lang_extension}"))
										xml.Documentation(eval("null.documentation#{@lang_extension}"))
									end # Null
								end # for null
							end # Exceptions
						end # if @nullsArray
					end #Measure
				elsif @attribute.attributedescription.kind == "Nominal"
					xml.Nominal do
						exception="false" # assume no exception values exist
						if !(@attribute.attributedescription.classesuri == "n/a")
							xml.Classes do
								xml.Title(eval("@classHash.title#{@lang_extension}"))
								xml.Abstract(eval("@classHash.abstract#{@lang_extension}"))
								xml.Documentation(eval("@classHash.documentation#{@lang_extension}"))
								for value in @valuesArray
									xml.Value("color".to_sym => value.color) do
										xml.Identifier(value.identifier)
										xml.Title(eval("value.title#{@lang_extension}"))
										xml.Abstract(eval("value.abstract#{@lang_extension}"))
										xml.Documentation(eval("value.documentation#{@lang_extension}"))
									end # Value
								end # of for value
							end # of Classes element
						end # if 
						if @nullsArray != [] # display the exception values
							xml.Exceptions do
								for null in @nullsArray
									xml.Null("color".to_sym => null.color) do
										xml.Identifier(null.identifier)
										xml.Title(eval("null.title#{@lang_extension}"))
										xml.Abstract(eval("null.abstract#{@lang_extension}"))
										xml.Documentation(eval("null.documentation#{@lang_extension}"))
									end # Null
								end # for null
							end # Exceptions
						end # if @nullsArray
					end # Nominal
				elsif @attribute.attributedescription.kind == "Ordinal"
					xml.Ordinal do
						exception="false" # assume no exception values exist
						if @attribute.attributedescription.classesuri != "n/a"
							xml.Classes do
								xml.Title(eval("@classHash.title#{@lang_extension}"))
								xml.Abstract(eval("@classHash.abstract#{@lang_extension}"))
								xml.Documentation(eval("@classHash.documentation#{@lang_extension}"))
								for value in @valuesArray
									xml.Value("rank".to_sym => value.rank, "color".to_sym => value.color) do
										xml.Identifier(value.identifier)
										xml.Title(eval("value.title#{@lang_extension}"))
										xml.Abstract(eval("value.abstract#{@lang_extension}"))
										xml.Documentation(eval("value.documentation#{@lang_extension}"))
									end # of Value element 
								end # of for value
							end # of Classes element
						end # if
						if @nullsArray != [] # display the exception values
							xml.Exceptions do
								for null in @nullsArray
									xml.Null("color".to_sym => null.color) do
										xml.Identifier(null.identifier)
										xml.Title(eval("null.title#{@lang_extension}"))
										xml.Abstract(eval("null.abstract#{@lang_extension}"))
										xml.Documentation(eval("null.documentation#{@lang_extension}"))
									end # Null
								end # for null
							end # Exceptions
						end # if @nullsArray
					end # Ordinal element
				end # if @attribute.gattributedescription.Kind
			end # Values
			attributeName=@attribute.send "attributename#{@lang_extension}"
			xml.GetDataRequest("xlink:href".to_sym => (@rootURL  +"?Service=TJS&Version=1.0&Request=GetData&FrameworkURI=" + CGI.escape(@framework.frameworkuri) + "&DatasetURI=" + CGI.escape(@dataset.dataseturi) + "&Attributes=" + attributeName) )
		end # Column
	end
end
