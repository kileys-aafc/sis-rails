class Datadataset < ActiveRecord::Base
	self.table_name="metadata.data3datasets"

	def self.find_by_params(framework,version,dataset)
    self.where(:dataseturi=>"http://sis.agr.gc.ca/cansis/nsdb/"+framework+"/"+version+"/"+dataset).first
  end

	def self.find_by_framework_version(framework,version)
    self.where(:frameworkuri=>"http://sis.agr.gc.ca/cansis/nsdb/"+framework+"/"+version).order("sortation")
  end

end
