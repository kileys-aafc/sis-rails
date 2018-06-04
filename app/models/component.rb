class Component

  def Component.uniq_hash(inputArray)
		# takes as input an array whose elements consist of [ Value, Percent ]
		# returns a hash where Percent is summarized for Value
    outputHash = Hash.new
    for x in inputArray
      if outputHash[x[0]] == nil
        outputHash.store(x[0], x[1])
      else
        outputHash.store(x[0], ( outputHash[x[0]] + x[1] ) )
      end
    end
    return outputHash
  end
  
  def Component.uniq_array(inputArray)
		# takes as input an array whose elements consist of [ Value, Percent ]
		# returns an array where Percent is summarized for Value, and highest percentages appear first
    inputArrayUniq = Component.uniq_hash(inputArray).to_a
    outputArray = inputArrayUniq.sort_by { |x| -x[1] }
    return outputArray
  end

  def Component.dominant(key, inputArray)
		# takes as input 
		#   key:  identifier (passed through untouched)
		#   inputArray:  an array whose elements consist of [ Value, Percent ]
		# returns an array with the dominant component as an array of form [ Key, Value, Percent ]
		#TODO: deal with co-dominants?
    inputArrayUniq = Component.uniq_hash(inputArray).to_a
    outputArray = inputArrayUniq.sort_by { |x| -x[1] }
    return [key, outputArray[0][0], outputArray[0][1]]
  end

  def Component.percent(key, inputArray, value)
		# takes as input 
		#   key: a framework key (which is passed through unaltered)
		#   inputArray:  an array whose elements consist of [Value, Percent], and 
		#   value:  a Value for whch the percentage will to be summarized
		# returns an array with the percentage of Value as an array of form [Key, Percent]
    percent = Component.uniq_hash(inputArray)[value]
		if percent == nil then percent = 0 end
    outputArray = [key, percent]
    return outputArray
  end
  
end
