class Datavalue < ActiveRecord::Base
	self.table_name="metadata.data8values"

	def self.find_by_classesuri(classesuri)
    self.where(:classesuri=>classesuri).order(:rank)
  end

	def self.validvalues(classesuri)
		self.where(:classesuri=>classesuri).where(:nullvalue=>"false")
	end

	def self.exceptions(classesuri)
		self.where(:classesuri=>classesuri).where(:nullvalue=>"true")
	end

	def self.values_for_attribute(datasetName,attributeName)
		datasetURI = Datadataset.where(:dataset_name=>datasetName).first.dataseturi
		attributeURI = Dataattribute.where(:dataseturi=>datasetURI).where(:attribute_name=>attributeName).first.attributeuri
		classesURI = Dataattributedescription.where(:attributeuri=>attributeURI).first.classesuri
		valuesArray = Array.new
		self.where(:classesuri=>classesURI).select(:identifier).order("rank ASC").each{|val| valuesArray.push(val.identifier)}
		return valuesArray
  end

end
