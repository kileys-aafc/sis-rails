class Webappexample < ActiveRecord::Base
	self.table_name="metadata.webappexamples"

	belongs_to :webappmethod
	
  def self.wadlexamples
    where(:wadl=>true).order(:sortation)
  end

end
