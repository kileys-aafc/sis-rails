class Dataattribute < ActiveRecord::Base
	self.table_name="metadata.data4attributes"

	def self.find_by_dataseturi(dataseturi)
    self.where(:dataseturi=>dataseturi).order(:sortation)
  end

	def self.find_by_params(framework,version,dataset,attribute)
    self.where(:dataseturi=>"http://sis.agr.gc.ca/cansis/nsdb/"+framework+"/"+version+"/"+dataset).where(:attribute_name=>attribute).first
  end
	
	def attributedescription
		Dataattributedescription.where(:attributeuri=>self.attributeuri).first
	end
	
	def values
		classesuri = Dataattributedescription.where(:attributeuri=>self.attributeuri).first.classesuri
		Datavalue.where(:classesuri=>classesuri).order(:valuegroup, :rank)
	end

	def dataset
		Datadataset.where(:dataseturi=>self.dataseturi).first
	end
end
