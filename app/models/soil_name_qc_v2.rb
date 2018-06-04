class Soil_name_qc_v2 < ActiveRecord::Base
  self.table_name="soildata.soil_name_qc_v2"
	include Extensions::Soilnames
end
