class Soil_layer_on_v2 < ActiveRecord::Base
  self.table_name="soildata.soil_layer_on_v2"
	belongs_to :soil_name_on_v2
end
