class Classify
	def test
classifyXML = Classify.read("http://services.gis.agr.gc.ca/schemas/classify/1.0/examples/temperature002.xml")
classificationArray = Classify.read_ordinal(classifyXML)
exceptionsArray = Classify.read_exceptions(classifyXML)
exceptionValuesArray = Array.new
exceptionsArray.each {|exceptionHash| exceptionValuesArray.push(exceptionHash[:identifier])}
exceptionsArray
Classify.numeric(20,classificationArray,exceptionsArray,exceptionValuesArray)
Classify.numeric(-32,classificationArray,exceptionsArray,exceptionValuesArray)
	end


# TODO:
# call Classify once, passing the url of GDAS and url of CLASSIFY documents - then internal calls.
# return GDAS components


	def self.read(url)
		require "#{Rails.root.to_s}/app/helpers/libxml-helper"
		require "open-uri"
		xml = open(url).read().to_libxml_doc.root
		return xml
	end

  def self.read_ordinal(classifyXML)
    # convert ordinal ranges in XML into an array (for legends) CAN THIS NOW REPLACE read_numeric
    classificationArray = Array.new
    #first range
		rangeXML = classifyXML.search("//NumericClassification/RankingScheme/HighestClass").first
    range = Hash.new
    range[:rank] = rangeXML.[]("rank")
		range[:minValue] = rangeXML.[]("minValue")
		range[:includeMinValue] = rangeXML.[]("includeMinValue")
    range[:identifier] = rangeXML.[]("identifier")
    range[:title] = rangeXML.[]("title")
    range[:color] = rangeXML.[]("color")
    classificationArray.push range
		# mid ranges
    midRangesXMLArray = classifyXML.search("//NumericClassification/RankingScheme/MidClass")
    for rangeXML in midRangesXMLArray
      range = Hash.new
			range[:rank] = rangeXML.[]("rank")
			range[:minValue] = rangeXML.[]("minValue")
			range[:includeMinValue] = rangeXML.[]("includeMinValue")
			range[:identifier] = rangeXML.[]("identifier")
			range[:title] = rangeXML.[]("title")
			range[:color] = rangeXML.[]("color")
			classificationArray.push range
    end
    #last range
		rangeXML = classifyXML.search("//NumericClassification/RankingScheme/LowestClass").first
    range = Hash.new
    range[:rank] = rangeXML.[]("rank")
    range[:identifier] = rangeXML.[]("identifier")
    range[:title] = rangeXML.[]("title")
    range[:color] = rangeXML.[]("color")
    classificationArray.push range
    return classificationArray
  end

	def self.resultant(classifyXML)
		ordinalXML = classifyXML.search("//NumericClassification/ResultantValues/Ordinal").first
		if ordinalXML.present? then
			resultant = Hash.new
			resultant[:title] = ordinalXML.search("//Ordinal/Classes/Title").first.content
			resultant[:abstract] = ordinalXML[0].search("//Ordinal/Classes/Abstract").first.content
			resultant[:documentation] = ordinalXML[0].search("//Ordinal/Classes/Documentation").first.content
		end
		return resultant
	end

    
  def self.read_exceptions(classifyXML)
    exceptionsArray = Array.new
    #missing values
		missingXML = classifyXML.search("//NumericClassification/RankingScheme/MissingClass").first
    missing = Hash.new
    missing[:rank] = 0
    missing[:identifier] = missingXML.[]("identifier")
		missing[:title] = missingXML.[]("title")
		missing[:color] = missingXML.[]("color")
    exceptionsArray.push missing
    #exception values
    exceptionXMLArray = classifyXML.search("//NumericClassification/RankingScheme/ExceptionClass")
    for exceptionXML in exceptionXMLArray
      exception = Hash.new
      exception[:rank] = 0
			exception[:identifier] = exceptionXML.[]("identifier")
      exception[:originalValue] = exceptionXML.[]("originalValue")
      exception[:title] = exceptionXML.[]("title")
      exception[:color] = exceptionXML.[]("color")
      exceptionsArray.push exception
    end
    return exceptionsArray
  end

  def self.numeric(value,classificationArray,exceptionsArray,exceptionValuesArray)
		# given a numeric value and a set of ordinal ranges, assign an ordinal identifier or an exception value 
    if exceptionValuesArray.include? value then
      rank = value
    elsif value == nil then
      rank = nil
    else
      rank = classificationArray[-1][:identifier]
			i = classificationArray.size-1
			while i > -1 do
        if classificationArray[i][:includeMinValue] == "true" then
          if value < classificationArray[i][:minValue].to_f then break end
        else
          if value <= classificationArray[i][:minValue].to_f then break end
        end
        rank = classificationArray[i][:identifier]
				i -= 1
      end
    end
    return rank
  end

end
