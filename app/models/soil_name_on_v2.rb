class Soil_name_on_v2 < ActiveRecord::Base
  self.table_name="soildata.soil_name_on_v2"
	include Extensions::Soilnames
	has_many :soil_layer_on_v2s, :order=>'layer_no'
end
