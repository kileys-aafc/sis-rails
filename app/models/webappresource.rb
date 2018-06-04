class Webappresource < ActiveRecord::Base
  self.table_name="metadata.webappresources"

	belongs_to :webapplication
	
	has_many :webappmethods

  def self.find_by_name(name)
    where(:name=>name).first
  end

end
