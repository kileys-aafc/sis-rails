class Texture

  def Texture.texture_class(sand_in, silt_in, clay_in)
    # This routine will transform sand silt clay percentage distribution into soil textura class
    #  Soil textural classes algorithms for the Canadian System .
    #  There are 13 textural classes in the Canadian System of Soil Classification. 
    #  Find the right condition and return the textural name or null ('')
		
		# convert to integer
		sand = sand_in.to_i
		silt = silt_in.to_i
		clay = clay_in.to_i

		# All SAND, SILT and CLAY values must be between 0 and 100 
		if sand < 0 or sand > 100 then error = "Error: sand (#{sand_in}%) must be between 0 and 100%" end
		if silt < 0 or silt > 100 then error = "Error: silt (#{silt_in}%) must be between 0 and 100%" end
		if clay < 0 or clay > 100 then error = "Error: clay (#{clay_in}%) must be between 0 and 100%" end

    # Input validation
		if error == nil then
			case [sand_in,silt_in,clay_in].count{|p| p == "" or p == nil}
			when 0 then
				#	SAND, SILT and CLAY must total 100%  
				if sand + silt + clay != 100 then error = "Error: sand (#{sand_in}%) + silt (#{silt_in}%) + clay (#{clay_in}%) must equal 100" end
			when 1 then
				# calculate sand or silt or clay
				if sand != '' and silt != '' then clay = 100 - sand - silt
				elsif sand != '' and clay != '' then silt = 100 - sand - clay
				elsif silt != '' and clay != '' then sand = 100 - silt - clay
				end
			else error = "Error: multiple missing values"
			end
		end

    if error == nil then
      # 1) Sand: (85% or more sand) AND (The percentage of silt plus 1.5 times the percentage of clay does not exceed 15)
      if sand >= 85 and silt + clay * 1.5 <=15 then texture = "SAND"
      # 2) Loamy sand: Upper limit ( (85-90% sand) AND (percentage of silt + 1.5 time the percentage of clay >= 15) )
      #       		  OR Lower limit ( (70-85% sand) AND (percentage of silt + 2 time the percentage of clay < 30) )
      elsif ( (sand >= 85 and sand <= 90) and ((silt + (clay * 1.5)).to_i >=15) ) then texture = "LOAMY SAND"
      elsif ( (sand>=70 and sand<=85) and ((silt + (clay * 2)).to_i <= 30) ) then texture = "LOAMY SAND"
      # 3) Sandy loam ( (20% clay or less) AND (The percentage of silt plus twice the percentage of clay is 30 or more) AND (More than 52% sand) )
      #				OR ((7% clay or less) AND (50% silt or less) AND (between 43%-52% sand) )
      elsif ( (clay <= 20 and (silt + (clay * 2)).to_i > 30) and (sand >= 52) ) then texture = "SANDY LOAM"
      elsif ( (clay < 7) and ( silt < 50) and (sand >= 43) and (sand <= 52) ) then texture = "SANDY LOAM"
      # 4)Silt (Soil material that contains 80% or more silt) AND (Less than 12% clay)
      elsif (silt >= 80) and (clay < 12)  then texture = "SILT"
      # 5) Silt loam ( (50% or more silt) AND (12% to 27% clay) ) OR ( (50% to 80% silt) AND (Less than 12% clay) )
      elsif ((silt>=50) and (clay>=12 and clay<=27)) or ((silt>=50 and silt<=80) and (clay<12)) then texture = "SILT LOAM"
      # 6) Loam (7% to 27% clay) AND (28 to 50% silt) AND (Less than 52% sand)
      elsif (clay >= 7) and (clay <= 27) and (silt >= 28) and (silt <= 50) and (sand < 52) then texture = "LOAM"
      # 7) Heavy clay (more than 60% clay)
      elsif (clay > 60) then texture = "HEAVY CLAY"
      # 8) Clay (40% or more clay) AND (Less than 45% sand) AND (Less than 40% silt)
      elsif (clay >= 40) and (sand < 45) and (silt < 40) then texture = "CLAY"
      # 9) Sandy clay (35% or more clay)  AND (45% or more sand)
      elsif (clay >= 35) and (sand >= 45) then texture = "SANDY CLAY"
      # 10) Sandy clay loam (20% to 35% clay) AND (Less than 28% silt) AND (45% or more sand)
      elsif (clay >= 20 and clay <= 35) and (silt < 28) and (sand >= 45) then texture = "SANDY CLAY LOAM"
      # 11) Silty clay (40% or more clay) AND (40% or more silt)
      elsif (clay >= 40) and (silt >= 40) then texture = "SILTY CLAY"
      # 12) Clay loam (27% to 40% clay) AND (20% to 45% sand)
      elsif (clay >= 27 and clay <= 40) and (sand >= 20 and sand <= 45) then texture = "CLAY LOAM"
      # 13) Silty clay loam (27% to 40% clay) AND (Less than 20% sand)
      elsif (clay >= 27 and clay <= 40) and (sand < 20) then texture = "SILTY CLAY LOAM"
      end
			return texture
    else 
      return error
    end
  end
  
  def Texture.ReadCSV(csvfile) # obsolete!!!!!!!!
    textureArray = Array.new
    require 'csv'
    CSV.open(csvfile, 'r', ',') do |row|
      textureArray.push row
    end
		return textureArray
  end

end