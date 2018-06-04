class Webappresponse < ActiveRecord::Base
	self.table_name="metadata.webappresponses"

	belongs_to :webappmethod
	
end
