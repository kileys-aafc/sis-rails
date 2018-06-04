class Dataclass < ActiveRecord::Base
	self.table_name="metadata.data6classes"

	def self.find_by_classesuri(classesuri)
    self.where(:classesuri=>classesuri).first
  end

end
