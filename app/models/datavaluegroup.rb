class Datavaluegroup < ActiveRecord::Base
	self.table_name="metadata.data7valuegroups"
	
	def self.find_by_classesuri(classesuri)
    self.where(:classesuri=>classesuri).order(:rank)
  end
	
end
