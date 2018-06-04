class Layer

  def Layer.resample(fromRequested, toRequested, layerData, property)
		# resamples a set of layers
		fromUsed = layerData[0].udepth + fromRequested
		toUsed = layerData[0].udepth + toRequested
		rangeRequested = toRequested - fromRequested
		layers = []
		outputHash = {:fromUsed=>fromUsed, :toUsed=>toUsed, :rangeRequested=>rangeRequested, :layers=>layers}
		#loop through each layer, calc the weighting factor, and sum factor * property
		case property
		when "cofrag" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:cofrag_sum] = Layer.calc_linear(outputHash[:cofrag_sum].to_f,sourceLayer.cofrag,outputHash[:layers][-1][:layer_volume_factor])
			end
			outputHash[:estimate] = (outputHash[:cofrag_sum] / outputHash[:layers].map{|y| y[:layer_volume_factor]}.reduce(:+)).round.to_i
			
		when "vfsand" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:vfsand_sum] = Layer.calc_linear(outputHash[:vfsand_sum].to_f,sourceLayer.vfsand,outputHash[:layers][-1][:layer_mass_factor])
			end
			outputHash[:estimate] = (outputHash[:vfsand_sum] / outputHash[:layers].map{|y| y[:layer_mass_factor]}.reduce(:+)).round.to_i

		when "sand" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:sand_sum] = Layer.calc_linear(outputHash[:sand_sum].to_f,sourceLayer.tsand,outputHash[:layers][-1][:layer_mass_factor])
			end
			outputHash[:estimate] = (outputHash[:sand_sum] / outputHash[:layers].map{|y| y[:layer_mass_factor]}.reduce(:+)).round.to_i

		when "silt" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:silt_sum] = Layer.calc_linear(outputHash[:silt_sum].to_f,sourceLayer.tsilt,outputHash[:layers][-1][:layer_mass_factor])
			end
			outputHash[:estimate] = (outputHash[:silt_sum] / outputHash[:layers].map{|y| y[:layer_mass_factor]}.reduce(:+)).round.to_i

		when "clay" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:clay_sum] = Layer.calc_linear(outputHash[:clay_sum].to_f,sourceLayer.tclay,outputHash[:layers][-1][:layer_mass_factor])
			end
			outputHash[:estimate] = (outputHash[:clay_sum] / outputHash[:layers].map{|y| y[:layer_mass_factor]}.reduce(:+)).round.to_i

		when "texture" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:sand_sum] = Layer.calc_linear(outputHash[:sand_sum].to_f,sourceLayer.tsand,outputHash[:layers][-1][:layer_mass_factor])
				outputHash[:clay_sum] = Layer.calc_linear(outputHash[:clay_sum].to_f,sourceLayer.tclay,outputHash[:layers][-1][:layer_mass_factor])
			end
			outputHash[:sum_layer_mass_factor] = outputHash[:layers].map{|y| y[:layer_mass_factor]}.reduce(:+)
			outputHash[:sand] = (outputHash[:sand_sum] / outputHash[:sum_layer_mass_factor]).round.to_i
			outputHash[:clay] = (outputHash[:clay_sum] / outputHash[:sum_layer_mass_factor]).round.to_i
			outputHash[:estimate] = Texture.texture_class(outputHash[:sand], nil, outputHash[:clay])

		when "orgcarb" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:orgcarb_sum] = Layer.calc_linear(outputHash[:orgcarb_sum].to_f,sourceLayer.orgcarb,outputHash[:layers][-1][:layer_mass_factor])
			end
			outputHash[:estimate] = (outputHash[:orgcarb_sum] / outputHash[:layers].map{|y| y[:layer_mass_factor]}.reduce(:+)).round(2)

		when "phca" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:phca_sum] = Layer.calc_linear(outputHash[:phca_sum].to_f,sourceLayer.phca,outputHash[:layers][-1][:layer_mass_factor])
				# debugging statements
				outputHash[:layers][-1][:bd] = sourceLayer.bd # debugging statement
				outputHash[:layers][-1][:phca] = sourceLayer.phca # debugging statement
				outputHash[:layers][-1][:phca_calcd] = sourceLayer.phca *  outputHash[:layers][-1][:layer_mass_factor] # debugging statement
			end
			outputHash[:estimate] = (outputHash[:phca_sum] / outputHash[:layers].map{|y| y[:layer_mass_factor]}.reduce(:+)).round(2)

		when "bases" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:bases_sum] = Layer.calc_linear(outputHash[:bases_sum].to_f,sourceLayer.bases,outputHash[:layers][-1][:layer_mass_factor])
			end
			outputHash[:estimate] = (outputHash[:bases_sum] / outputHash[:layers].map{|y| y[:layer_mass_factor]}.reduce(:+)).round.to_i
			
		when "cec" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:cec_sum] = Layer.calc_linear(outputHash[:cec_sum].to_f,sourceLayer.cec,outputHash[:layers][-1][:layer_mass_factor])
			end
			outputHash[:estimate] = (outputHash[:cec_sum] / outputHash[:layers].map{|y| y[:layer_mass_factor]}.reduce(:+)).round.to_i
		
		when "ksat" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:ksat_sum] = Layer.calc_linear(outputHash[:ksat_sum].to_f,sourceLayer.ksat,outputHash[:layers][-1][:layer_mass_factor])
			end
			outputHash[:estimate] = (outputHash[:ksat_sum] / outputHash[:layers].map{|y| y[:layer_mass_factor]}.reduce(:+)).round.to_i
		
		when "kp0" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:kp0_sum] = Layer.calc_linear(outputHash[:kp0_sum].to_f,sourceLayer.kp0,outputHash[:layers][-1][:layer_volume_factor])
			end
			outputHash[:estimate] = (outputHash[:kp0_sum] / outputHash[:layers].map{|y| y[:layer_volume_factor]}.reduce(:+)).round.to_i

		when "kp10" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:kp10_sum] = Layer.calc_linear(outputHash[:kp10_sum].to_f,sourceLayer.kp10,outputHash[:layers][-1][:layer_volume_factor])
			end
			outputHash[:estimate] = (outputHash[:kp10_sum] / outputHash[:layers].map{|y| y[:layer_volume_factor]}.reduce(:+)).round.to_i

		when "kp33" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:kp33_sum] = Layer.calc_linear(outputHash[:kp33_sum].to_f,sourceLayer.kp33,outputHash[:layers][-1][:layer_volume_factor])
			end
			outputHash[:estimate] = (outputHash[:kp33_sum] / outputHash[:layers].map{|y| y[:layer_volume_factor]}.reduce(:+)).round.to_i

		when "kp1500" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:kp1500_sum] = Layer.calc_linear(outputHash[:kp1500_sum].to_f,sourceLayer.kp1500,outputHash[:layers][-1][:layer_volume_factor])
			end
			outputHash[:estimate] = (outputHash[:kp1500_sum] / outputHash[:layers].map{|y| y[:layer_volume_factor]}.reduce(:+)).round.to_i

		when "bd" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:bd_sum] = Layer.calc_linear(outputHash[:bd_sum].to_f,sourceLayer.bd,outputHash[:layers][-1][:layer_volume_factor])
			end
			outputHash[:estimate] = (outputHash[:bd_sum] / outputHash[:layers].map{|y| y[:layer_volume_factor]}.reduce(:+)).round(2)

		when "ec" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:ec_sum] = Layer.calc_linear(outputHash[:ec_sum].to_f,sourceLayer.ec,outputHash[:layers][-1][:layer_volume_factor])
			end
			outputHash[:estimate] = (outputHash[:ec_sum] / outputHash[:layers].map{|y| y[:layer_volume_factor]}.reduce(:+)).round.to_i

		when "caco3" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:caco3_sum] = Layer.calc_linear(outputHash[:caco3_sum].to_f,sourceLayer.caco3,outputHash[:layers][-1][:layer_mass_factor])
			end
			outputHash[:estimate] = (outputHash[:caco3_sum] / outputHash[:layers].map{|y| y[:layer_mass_factor]}.reduce(:+)).round.to_i

		when "awhc" then
			for sourceLayer in layerData do
				outputHash[:layers].push(Layer.factors(sourceLayer, outputHash, fromUsed, toUsed))
				outputHash[:awhc_sum] = Layer.awhc(outputHash[:awhc_sum].to_f,sourceLayer.vfsand,sourceLayer.tclay,sourceLayer.tsilt,sourceLayer.cofrag,outputHash[:layers][-1][:layer_volume_factor])
			end
			outputHash[:estimate] = (outputHash[:awhc_sum] / outputHash[:layers].map{|y| y[:layer_volume_factor]}.reduce(:+)).round(2)
			#outputHash[:estimate] = Layer.awhc(outputHash[:awhc_sum].to_f,sourceLayer.vfsand,sourceLayer.tclay,sourceLayer.tsilt,sourceLayer.cofrag,1)
			#outputHash[:estimate] = sourceLayer.cofrag

		end

    return outputHash
  end

	def Layer.factors(sourceLayer, outputHash, fromUsed, toUsed)
		# do calculations
		layer=sourceLayer.layer_no
		udepth=sourceLayer.udepth
		ldepth=sourceLayer.ldepth
		from = [fromUsed,sourceLayer.udepth].max
		to = [toUsed,sourceLayer.ldepth].min
		if from < to then
			within_range = to - from 
			layer_mass_factor = sourceLayer.bd * within_range / outputHash[:rangeRequested].to_f
			layer_volume_factor = within_range / outputHash[:rangeRequested].to_f
		else
			within_range = false
			layer_mass_factor = 0.0
			layer_volume_factor = 0.0
		end
		# now build up content for outputHash
		layerHash = {}
		layerHash[:layer_no]= layer
		layerHash[:source_udepth]= udepth
		layerHash[:source_ldepth]= ldepth
		layerHash[:within_range]= within_range
		layerHash[:layer_mass_factor]= layer_mass_factor
		layerHash[:layer_volume_factor]= layer_volume_factor
		return layerHash
	end

	def Layer.calc_linear(sum,value,layer_factor)
		if value >= 0 then
			sum = sum + (value * layer_factor)
		end
		return sum
	end

	def Layer.awhc(awhctot,vfsand,tclay,tsilt,cofrag,thicklay)
		#Here is the logic  we used to calculate AWHC for SLC 3.0, from our Inherent Soil Quality (ISQ) dBase program.  This was developed for Chapter of Health of Our Soils, entitled A Geographical Framework for Assessing Soil Quality.  Details of the ISQ logic are described in AAFC Research Branch Technical Bulletin 1998-3E, Broad Scale Assessment of Agricultural Soil Quality in Canada Using Existing Land Resurce Databases and GIS, by K.B. MacDonald, F. Wang, W.R. Fraser, and G.W. Lelyk..  Our AWHC calculation logic is described in Appendix 4, page 90.
		#Basically, for each soil, this AWHC procedure looks at each soil horizon in the SLF, and adds up the TSILT + TCLAY + 0.5 * VFSAND.  This number is divided into textural ranges, each of which is assigned a particular AWHC ratio (cm of water that can be stored per cm of soil).  For example, if TSILT + TCLAY + 0.5 * VFSAND is between 10 and 20, the soil is basically a loamy sand, and can hold 60mm of water per meter of soil (= 0.060 cm/cm).  If TSILT + TCLAY + 0.5 * VFSAND is >80, the soil is fine textured, and can hold 0.20 cm of water per cm of soil.  Organic soil layers have "-9 in these SLF fields, and are assigned a value of 0.5cm/cm.  The AWHC ratio for each horizon is multiplied by the horizon thickness (the absolute value of UDEPTH - LDEPTH) to calculate the cm of available water in each horizon.  This is similar to the logic used in the Land Suitability Rating System (LSRS), as described on page 13 of the LSRS Technical Report (AAFC Technical Bulletin 1995-6E).
		#The ISQ logic includes a correction factor for coarse fragments (CFRAG).  If a soil horizon has 15% Coarse fragments, then only 85% of the soil volume is available to hold water.  Separate logic is used to stop the calculation if a root restricting layer is encountered (SNF RESTR_TYPE = LI, CR, DU, etc.).  If the total soil thickness reaches 100cm within a horizon , then only the portion of the horizon <100cm of the soil surface is evaluated.
    finetexture = (0.5 * vfsand) + tclay + tsilt
    if cofrag > 0 then thicklay = ((100 - cofrag.to_f) / 100) * thicklay end
		case
		when finetexture == 0 then awhctot = awhctot + thicklay * 0.500
		when (finetexture >  0 and finetexture <= 10) then awhctot = awhctot + thicklay * 0.040
		when (finetexture > 10 and finetexture <= 20) then awhctot = awhctot + thicklay * 0.060
		when (finetexture > 20 and finetexture <= 40) then awhctot = awhctot + thicklay * 0.100
		when (finetexture > 40 and finetexture <= 60) then awhctot = awhctot + thicklay * 0.150
		when (finetexture > 60 and finetexture <= 70) then awhctot = awhctot + thicklay * 0.170
		when (finetexture > 70 and finetexture <= 75) then awhctot = awhctot + thicklay * 0.180
		when (finetexture > 75 and finetexture <= 80) then awhctot = awhctot + thicklay * 0.190
		when (finetexture > 80 and finetexture <= 85) then awhctot = awhctot + thicklay * 0.200
		when (finetexture > 85) then awhctot = awhctot + thicklay * 0.225
		end
		return awhctot
	end

end
