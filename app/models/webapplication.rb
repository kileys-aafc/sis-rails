class Webapplication < ActiveRecord::Base
  self.table_name="metadata.webapplications"

	has_many :webappresources, -> { order 'sortation' }

  def self.find_by_name(name)
    where(:name=>name).first
  end

end
