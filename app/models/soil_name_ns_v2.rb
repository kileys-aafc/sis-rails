class Soil_name_ns_v2 < ActiveRecord::Base
  self.table_name="soildata.soil_name_ns_v2"
	include Extensions::Soilnames
end
