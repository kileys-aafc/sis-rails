class Soil_layer_ab_v2 < ActiveRecord::Base
  self.table_name="soildata.soil_layer_ab_v2"
	include Extensions::Soilnames
end
