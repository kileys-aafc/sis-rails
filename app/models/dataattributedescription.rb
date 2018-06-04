class Dataattributedescription < ActiveRecord::Base
	self.table_name="metadata.data5attributedescriptions"

	def self.find_by_attributeuri(attributeuri)
    self.where(:attributeuri=>attributeuri).first
  end

end
