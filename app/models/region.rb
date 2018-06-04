class Region < ActiveRecord::Base
  self.table_name="metadata.regions"

  def self.provinces
    self.where(:prov=>true).order(:sortation)
  end

  def self.provcodes
    self.where(:prov=>true).select(:code).order(:sortation).map(&:code)
  end

  def self.allcodes
    self.select(:code).order(:sortation).map(&:code)
  end

end
