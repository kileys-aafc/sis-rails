class Webapptemplateparam < ActiveRecord::Base
	self.table_name="metadata.webapptemplateparams"

	belongs_to :webappmethod
	
end
