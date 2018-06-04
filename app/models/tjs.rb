class Tjs

	def self.framework(framework, version)
		return Dataframeworkversion.where(:framework_name=>framework).where(:framework_version=>version).first
	end

	def self.dataset(frameworkuri, region, datasetname)
		dataset = Datadataset.where(:frameworkuri=>frameworkuri).where(:dataseturi=>"#{frameworkuri}/#{datasetname}").first
		if dataset.dataset_name.include?("REGION") then dataset.dataset_name.gsub!("REGION", region) end
		return dataset
	end

	def self.attributes(dataseturi, attributeNamesArray)
		if attributeNamesArray.empty? # if no attributes were specified then all are required
			attributeNamesArray = Dataattribute.where(:dataseturi=>datasetURI).where("purpose <> 'PrimarySpatialIdentifier'").map{|a|a.attribute_name}
		end
		allAttributesHash = Hash.new
		for attributeName in attributeNamesArray
			allAttributesHash[attributeName] = Hash.new
			allAttributesHash[attributeName][:Description] = Dataattribute.where(:dataseturi=>dataseturi).where(:attribute_name=>attributeName).first
			allAttributesHash[attributeName][:Class] = Dataclass.where(:classesuri=>allAttributesHash[attributeName][:Description].attributedescription.classesuri).first
			allAttributesHash[attributeName][:Values] = Datavalue.where(:classesuri=>allAttributesHash[attributeName][:Description].attributedescription.classesuri).where(:nullvalue=>"false").order(:rank)
			allAttributesHash[attributeName][:Nulls] = Datavalue.where(:classesuri=>allAttributesHash[attributeName][:Description].attributedescription.classesuri).where(:nullvalue=>"true").order(:rank)
			allAttributesHash[attributeName][:NullIdentifiers] = allAttributesHash[attributeName][:Nulls].map{|v|v.identifier}
		end
		return allAttributesHash
	end
	
	def self.data(dataset, subset, poly_ids)
		case subset
			when true then
				return eval("#{dataset.dataset_name.capitalize}").where("#{dataset.frameworkkey} IN (?)",poly_ids)
			when false then
				return eval("#{dataset.dataset_name.capitalize}").all
		end
	end

end
