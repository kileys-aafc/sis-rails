class Webappqueryparam < ActiveRecord::Base
	self.table_name="metadata.webappqueryparams"
	
	belongs_to :webappmethod
	
end
