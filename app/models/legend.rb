class Legend

	def Legend.activerecord2png(legendClasses,rootname)
		filenum = 0
		for classx in legendClasses do
			#width = 80 + (title.size*10)
			filenum += 1
			`convert -size 50x30  xc:"##{classx.color}" -bordercolor white -border 10 #{rootname}#{filenum}a.gif`
			`convert  -fill black -size 300x50 -pointsize 20 -gravity west label:"#{classx.title_en}"  #{rootname}#{filenum}b.gif`
			`montage #{rootname}#{filenum}a.gif #{rootname}#{filenum}b.gif -tile 2x1 -geometry +0+0 #{rootname}#{filenum}c.gif`
		end
		# create combined image
		self.combineImages(rootname, filenum)
	end
	
	def Legend.legendHash2png(legendHash, rootname)
		filenum = 0
#		`convert -size 50x30  xc:"##{legendHash["NumericClassification"]["RankingScheme"]["HighestClass"]["color"]}" -bordercolor white -border 10 #{rootname}#{filenum}a.gif`
#		`convert  -fill black -size 300x50 -pointsize 20 -gravity west label:"#{legendHash["NumericClassification"]["RankingScheme"]["HighestClass"]["title"]}"  #{rootname}#{filenum}b.gif`
#		`montage #{rootname}#{filenum}a.gif #{rootname}#{filenum}b.gif -tile 2x1 -geometry +0+0 #{rootname}#{filenum}c.gif`
		for dataClass in legendHash["NumericClassification"]["RankingScheme"]["DataClasses"] do
			filenum +=1
			`convert -size 50x30  xc:"##{dataClass["Color"]}" -bordercolor white -border 10 #{rootname}#{filenum}a.gif`
			`convert  -fill black -size 300x50 -pointsize 20 -gravity west label:"#{dataClass["Title"]}"  #{rootname}#{filenum}b.gif`
			`montage #{rootname}#{filenum}a.gif #{rootname}#{filenum}b.gif -tile 2x1 -geometry +0+0 #{rootname}#{filenum}c.gif`
		end
#		filenum +=1
#		`convert -size 50x30  xc:"##{legendHash["NumericClassification"]["RankingScheme"]["LowestClass"]["color"]}" -bordercolor white -border 10 #{rootname}#{filenum}a.gif`
#		`convert  -fill black -size 300x50 -pointsize 20 -gravity west label:"#{legendHash["NumericClassification"]["RankingScheme"]["LowestClass"]["title"]}"  #{rootname}#{filenum}b.gif`
#		`montage #{rootname}#{filenum}a.gif #{rootname}#{filenum}b.gif -tile 2x1 -geometry +0+0 #{rootname}#{filenum}c.gif`
		for missingClass in legendHash["NumericClassification"]["RankingScheme"]["MissingClasses"] do
			filenum +=1
			`convert -size 50x30  xc:"##{missingClass["Color"]}" -bordercolor white -border 10 #{rootname}#{filenum}a.gif`
			`convert  -fill black -size 300x50 -pointsize 20 -gravity west label:"#{missingClass["Title"]}"  #{rootname}#{filenum}b.gif`
			`montage #{rootname}#{filenum}a.gif #{rootname}#{filenum}b.gif -tile 2x1 -geometry +0+0 #{rootname}#{filenum}c.gif`
		end
		for exceptionClass in legendHash["NumericClassification"]["RankingScheme"]["ExceptionClasses"] do
			filenum +=1
			`convert -size 50x30  xc:"##{exceptionClass["Color"]}" -bordercolor white -border 10 #{rootname}#{filenum}a.gif`
			`convert  -fill black -size 300x50 -pointsize 20 -gravity west label:"#{exceptionClass["Title"]}"  #{rootname}#{filenum}b.gif`
			`montage #{rootname}#{filenum}a.gif #{rootname}#{filenum}b.gif -tile 2x1 -geometry +0+0 #{rootname}#{filenum}c.gif`
		end
		self.combineImages(rootname, filenum)
	end

	def Legend.combineImages(rootname, filenum)
		# create combined image
		`rm #{rootname}*a.gif #{rootname}*b.gif`
		`montage #{rootname}*c.gif -tile 1x#{filenum} -geometry +0+0 #{rootname}joined.gif`
		`convert #{rootname}joined.gif -trim +repage -bordercolor white -border 10 #{rootname}.png`
	end

	def Legend.dataclasses_from_json_legendHash(legendHash)
		classificationArray = Array.new
		for classx in legendHash["NumericClassification"]["RankingScheme"]["DataClasses"] do
			classificationArray.push({:identifier=>classx["Identifier"], :color => classx["Color"], :minValue=>classx["MinValue"], :includeMinValue=>classx["IncludeMinValue"]})
		end
		return classificationArray
	end

	def Legend.exceptions_from_json_legendHash(legendHash)
		exceptionsArray = Array.new
		for classx in legendHash["NumericClassification"]["RankingScheme"]["MissingClasses"] + legendHash["NumericClassification"]["RankingScheme"]["ExceptionClasses"]  do
			exceptionsArray.push({:identifier=>classx["Identifier"], :color => classx["Color"]})
		end
		return exceptionsArray
	end


  def Legend.from_xml(filename) # OBSOLETE?
		require "#{Rails.root}/app/helpers/libxml-helper"
		legendXml = open(filename).read().to_libxml_doc.root
		rankingScheme = legendXml.search("//NumericClassification/RankingScheme").first
		# populate legend classes
		legendClasses = Array.new
		# highest class
		classx = Legend_class.new
		highestClass = rankingScheme.search("HighestClass").first
		classx.title_en = highestClass.search("@title").first.value
		classx.color = highestClass.search("@color").first.value
		legendClasses.push(classx)
		# mid classes
		midClassArray = rankingScheme.search("MidClass")
		for midClass in midClassArray do
			classx = Legend_class.new
			classx.title_en = midClass.search("@title").first.value
			classx.color = midClass.search("@color").first.value
			legendClasses.push(classx)
		end
		# lowest class
		classx = Legend_class.new
		lowestClass = rankingScheme.search("LowestClass").first
		classx.title_en = lowestClass.search("@title").first.value
		classx.color = lowestClass.search("@color").first.value
		legendClasses.push(classx)
		return legendClasses
  end

end