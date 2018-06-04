module Negotiate

  def Negotiate.Version(acceptVersions, supportedVersions)
		# acceptVersions is a comma delimited list of versions (one-, two-, or three-part) requested by the client, in order of preference
		#   e.g. "1.2,1.1.0,0.8.2"
		# supportedVersions is a comma delimited list of all the versions (three-part) supported by the service
		#   e.g. "1.1.1,1.1.0,1.0.0"
		# TODO: ensure sorting works properly for version numbering > 9
		supportedVersionsArray = supportedVersions.split(/,/).to_a.sort.reverse
		if acceptVersions == "" then
			version = supportedVersionsArray.sort[-1]
		else
			#prepare arrays to support matching
			#add trailing periods to elements in both arrays to prevent erroneous partial matches
			acceptVersionsArray = acceptVersions.split(/,/).map{|v| v=v+"."}
			supportedVersionsArray = supportedVersions.split(/,/).to_a.sort.reverse.map{|v| v=v+"."}
			matchingVersions = acceptVersionsArray & supportedVersionsArray
			if matchingVersions.size > 0 then version = matchingVersions[0].chop else version = "" end
			return version
		end
  end

  def Negotiate.Language(acceptLanguages, capabilitiesHash)
		# acceptLanguages is a comma delimited list of languages requested by the client, in order of preference
		#   e.g. "en,fr"
		# supportedLanguages is a comma delimited list of all the languages supported by the service
		#   e.g. "en,fr"
		if acceptLanguages == "" then
			language = capabilitiesHash['DefaultLanguage']
    elsif acceptLanguages == "MUL" then 
			language = capabilitiesHash['DefaultLanguage'] #take the easy way out
		else
			#create arrays to support matching
			acceptLanguagesArray = acceptLanguages.split(/,/)
			#shorten all requested language codes to two characters (i.e this doesn't support language by country)
			for i in 0..(acceptLanguagesArray.size-1) do
				acceptLanguagesArray[i] = acceptLanguagesArray[i][0..1]
			end
			supportedLanguagesArray = capabilitiesHash['Languages'].keys
      matchingLanguagesArray = acceptLanguagesArray & supportedLanguagesArray # FIX THIS SOMETIME - doesn't completely deal with 2 character language codes
      language = case matchingLanguagesArray.size 
        when 0 then capabilitiesHash['DefaultLanguage'] # matching array is empty so assign default
        else    matchingLanguagesArray[0]  # CHECK THIS - may not work perfectly depending on how the array gets populated
      end
    end
		return language
  end

end
