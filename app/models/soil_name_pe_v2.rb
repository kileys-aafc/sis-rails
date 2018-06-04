class Soil_name_pe_v2 < ActiveRecord::Base
  self.table_name="soildata.soil_name_pe_v2"
	include Extensions::Soilnames
end
