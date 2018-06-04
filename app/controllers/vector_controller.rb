class VectorController < ApplicationController
# FILTERS
  before_filter :set_admin, :only => [ :clients, :describe_polygon, :show_data_many, :show_data, :identify_polygon]
	after_filter :set_headers, :except => [ :locate_polygon,  :show_polygon]

  def set_admin
    if params[:rootdir] == "cansis" then @lang = "en" else @lang = "fr" end
  end

	def set_headers
		headers['Access-Control-Request-Method'] = '*' 
		headers['Access-Control-Allow-Origin'] = '*' 
	end

# ACTIONS

	def test
params = Hash.new
params[:framework]="ecozones"
params[:version]="v1"
params[:region]="canada"
params[:dataset]="landform"
params[:attribute]="landform"
params[:value]="M"
params[:csv]="http://data.gis.agr.gc.ca/vector/ecozones/v1/canada/data/landform/landform/summary.csv?value=M"
params[:gdas]="http://data.gis.agr.gc.ca/vector/ecozones/v1/canada/data/landform/landform/summary.xml?value=M"
params[:style]="http://data.gis.agr.gc.ca/schemas/classify/1.0/examples/percent3red001.xml"
	end

	def clients
		@breadcrumbsArray = Array.new
		render params[:client], :layout=>"web_#{@lang}"
	end

	def describe_attribute
		@attribute = Dataattribute.where(:dataseturi=>"http://sis.agr.gc.ca/cansis/nsdb/#{params[:framework]}/#{params[:version].gsub('r','.')}/#{params[:dataset]}").where(:attribute_name=>params[:attribute]).first
		if params[:debug] == "on" then render "describe_attribute.debug.erb" else render "describe_attribute.#{params[:format]}.erb" end
	end

	def describe_polygon
		@framework = Dataframework.where(:framework_name=>params[:framework]).first
		@version = Dataframeworkversion.where(:framework_name=>params[:framework]).where(:framework_version=>params[:version]).first
		if params[:framework] == "dss" then
			@dataset = Datadataset.where( :dataset_name=>"#{params[:framework]}_#{params[:version]}_REGION_#{params[:dataset]}").first
		else
			@dataset = Datadataset.where(:dataset_name=>"#{params[:framework]}_#{params[:version]}_#{params[:region]}_#{params[:dataset]}").first
		end
		@attributes = Dataattribute.where(:dataseturi=>"http://sis.agr.gc.ca/cansis/nsdb/#{params[:framework]}/#{params[:version].gsub("r",".")}/#{params[:dataset]}")
		sqlfile = "#{params[:framework].capitalize}_#{params[:version]}_#{params[:region]}_#{params[:dataset]}"
		@dataArray=eval(sqlfile).where(@dataset.frameworkkey=>params[:poly_id])
		if params[:debug] == "on" then render "describe_polygon.debug.erb" 
			elsif params[:format] == "json" then render "describe_polygon.json.erb" 
			else 
				@breadcrumbsArray = Array.new
				@breadcrumbsArray.push Breadcrumb.where(:dir=>@dataset.dataseturi.split("/")[4]).first
				@breadcrumbsArray.push Breadcrumb.where(:dir=>@dataset.dataseturi.split("/")[4..5].join('/')).first
				@breadcrumbsArray.push Breadcrumb.where(:dir=>@dataset.dataseturi.split("/")[4..6].join('/')).first
				@breadcrumbsArray.push Breadcrumb.where(:dir=>@dataset.dataseturi.split("/")[4..7].join('/')).first
				@breadcrumbsArray.compact!
				@columns=1
				render "describe_polygon_#{@lang}.html.erb" , :layout => "web_#{@lang}.html.erb"
		end
	end

	def show_polygon
		@framework = Dataframework.where(:framework_name=>params[:framework]).first
		@poly_ids = [params[:poly_id]]
		render "generate_plain.kml.builder",  :type => :kml
	end

	def list_attributes
		@attributes = Dataattribute.where(:dataseturi=>"http://sis.agr.gc.ca/cansis/nsdb/#{params[:framework]}/#{params[:version].gsub('r','.')}/#{params[:dataset]}")
		if params[:debug] == "on" then render "list_attributes.debug.erb" else render "list_attributes.#{params[:format]}.erb" end
	end

	def list_datasets
		@datasets = Datadataset.where(:frameworkuri=>"http://sis.agr.gc.ca/cansis/nsdb/#{params[:framework]}/#{params[:version].gsub('r','.')}")
		render "list_datasets.#{params[:format]}.erb"
	end

	def list_frameworks
		@frameworks =Dataframework.order("sortation")
		render "list_frameworks.#{params[:format]}.erb"
	end

	def list_framework_versions
		@framework = Dataframework.where(:framework_name=>params[:framework]).first
		@versions = Dataframeworkversion.where(:framework_name=>params[:framework]).where(:publish=>"true").order("framework_version")
		render "list_versions.#{params[:format]}.erb"
	end

	def list_framework_regions
		@framework = Dataframework.where(:framework_name=>params[:framework]).first
		@version = Dataframeworkversion.where(:framework_name=>params[:framework]).where(:framework_version=>params[:version]).order("framework_version").first
		Dir.chdir("/production/geodata/#{params[:framework]}/#{params[:version]}")
		@regions = Dir["*"].sort
		render "list_regions.#{params[:format]}.erb"
	end

	def list_polygon_ids
		if params[:polygonset] then
			@polygonids = File.read(self.polygonset_name).split("\n")
			render "list_polygons.#{params[:format]}.erb" 
		else
			Dir.chdir("/production/geodata/#{params[:framework]}/#{params[:version]}/#{params[:region]}/kml")
			@polygonids = Dir.glob("*").sort
			render "list_polygons.#{params[:format]}.erb" 
		end
	end

	def list_polygonsets
		@framework = Dataframework.where(:framework_name=>params[:framework]).first
		@version = Dataframeworkversion.where(:framework_name=>params[:framework]).where(:framework_version=>params[:version]).order("framework_version").first
		Dir.chdir("/production/geodata/#{params[:framework]}/#{params[:version]}/#{params[:region]}/polygonsets")
		@polygonsets = Dir["*"].sort.each{|f| f.gsub!(".txt","")}
		render "list_polygonsets.#{params[:format]}.erb"
	end

	def polygonset_name
		return "/production/geodata/#{params[:framework]}/#{params[:version]}/#{params[:region]}/polygonsets/#{params[:polygonset]}.txt"
	end

	def identify_polygon
		require "open-uri"
		@bbox = "#{params[:longitude].to_f - 0.5},#{params[:latitude].to_f - 0.5},#{params[:longitude].to_f + 0.5},#{params[:latitude].to_f + 0.5}"
		open("http://website.gis.agr.gc.ca/cgi-bin/ecozones_v1?SERVICE=WMS&VERSION=1.1.1&REQUEST=GetFeatureInfo&BBOX=#{@bbox}&SRS=EPSG:4326&LAYERS=#{params[:framework]}&STYLES=&FORMAT=image/png&TRANSPARENT=true&QUERY_LAYERS=ecozones&INFO_FORMAT=text/html&WIDTH=400&HEIGHT=300&X=200&Y=150") {|f|
			@polygon = f.readlines.first
			@status = f.status 
		}
		if params[:format] == "html" then lang = "_#{@lang}" else lang = nil end
		render "identify_polygon#{lang}.#{params[:format]}.erb"
	end

	def show_data
		@frameworksArray = [Tjs.framework(params[:framework], params[:version])]
		@framework = @frameworksArray[0]
		# subset polygons
		@poly_ids_as_strings = Array.new
		if params[:polygons] then 
			@poly_ids_as_strings = params[:polygons].split(",").map{|p| p.to_s} 
		end
		if params[:polygonset] then
			@poly_ids_as_strings = File.read(self.polygonset_name).split("\n") 
		end
		if params[:polygonrange] then
			range = params[:polygonrange].split("..")
			@poly_ids_as_strings = eval("#{params[:framework].capitalize}_#{params[:version]}_#{params[:region]}_pat").where(:poly_id=>range[0]..range[1]).map{|r| r.poly_id.to_s}.sort
		end
		if @poly_ids_as_strings.size > 0 then
			subset = true
		else
			subset = false
			Dir.chdir("/production/geodata/#{params[:framework]}/#{params[:version]}/#{params[:region]}/kml")
			@poly_ids_as_strings = Dir.glob("*").sort
		end
		# correct the form of the @poly_ids - added July 20th to try to fix not rated problem for all polygons
		if @framework.frameworkkeytype == "integer" then 
			@poly_ids = @poly_ids_as_strings.map{|key| key.to_i}
		else
			@poly_ids = @poly_ids_as_strings
		end

		if params[:dataset] then # determine values to show
			case params[:value]
				when nil then @output = "raw"
				when "dominant" then @output = "dominant"
				else @output = "percent"
			end
			@datasetsArray = [Tjs.dataset(@frameworksArray[0].frameworkuri, params[:region], params[:dataset])]
			@dataset = @datasetsArray[0]
			# prepare content
			if @output == "raw" then
				if @datasetsArray[0].keyrelationship == "one" then
					@attributeNamesArray = [params[:attribute]]
				else
					@attributeNamesArray = [params[:attribute], "percent"]
				end
				@rowsetArray = Tjs.data(@dataset, subset, @poly_ids)
			else # percent or dominant
				@attributeNamesArray = [params[:attribute], "percent"]
				#require 'cmp_calculate'
				@rawRowsetArray = Tjs.data(@dataset, subset, @poly_ids)
				keyHash=Hash.new
				for row in @rawRowsetArray do
					if keyHash[row[@dataset.frameworkkey]] == nil then keyHash[row[@dataset.frameworkkey]] = [] end
					keyHash[row[@dataset.frameworkkey]] << [ row[params[:attribute]], row["percent"] ]
				end
				@rowsetArray = Array.new
				for key in keyHash.keys do
					row = Hash.new
					row[:key] = key
					if @output == "percent" then
						row[:value] = params[:value]
						row[:percent] = Component.percent(key, keyHash[key], params[:value])[1]
					elsif @output == "dominant" then
						domArray = Component.dominant(key, keyHash[key])
						row[:value] = domArray[1]
						row[:percent] = domArray[2]
					end
					@rowsetArray.push row
				end
				@rowsetNamesArray = [:value, :percent]
				@attname = params[:attribute]
				@dataset.keyrelationship = "one"
			end
		end

		# respond with thematic data
		case params[:format]
		when "csv" then
			require "csv"
			csv_string = CSV.generate do |csv|
				if params[:value] then # hash
					csv << [@dataset.frameworkkey, params[:attribute], "percent" ]
					@rowsetArray.map{ |r| [:key, :value, :percent].map { |m| r[m] }  }.each { |row| csv << row }
				else # activerecord array
					@fieldnames = [@dataset.frameworkkey] + @attributeNamesArray
					csv << @fieldnames
					@rowsetArray.map{ |r| @fieldnames.map { |m| r.send m }  }.each { |row| csv << row }
				end
			end
			send_data csv_string, :type => "text/csv", :filename=>"data_#{params[:province]}_v2_dev_#{Time.now.strftime("%Y-%m-%d_%H-%M")}.csv", :disposition => 'attachment'
		when "xml" then
			@allAttributesHash = Tjs.attributes(@dataset.dataseturi, @attributeNamesArray)
			@capabilitiesHash = YAML.load_file("#{Rails.root}/config/services/tjs/tjs.yml")
			@rootURL = "http://" + request.host + @capabilitiesHash['OperationsMetadata']['HTTP']['Get']
			@lang_extension = "_en"
			@xsl = ""
			render '/tjs/1.0/GetData_response.xml', :content_type => 'text/xml; subtype=gdas/1.0', :layout => false and return and exit 1
		when "html" then
			@allAttributesHash = Tjs.attributes(@dataset.dataseturi, @attributeNamesArray)
			@lang_extension = "_en"
			render '/tjs/1.0/GetData_response.html'
		when "kml" then
			if params[:dataset] then
				timestamp = Time.now.strftime("%Y%m%d%H%M%S%L")
				rootdir = "/tmp/rails/website"
				rootname = rootdir + "/index" + timestamp
				# get the classification information
				@attribute = Dataattribute.where(:dataseturi=>@dataset.dataseturi).where(:attribute_name=>params[:attribute]).first
				@legendname = "index" + timestamp + ".png"
				case @attribute.attributedescription.kind
				when "Nominal", "Ordinal" then
					if @output == "dominant" then
						@classificationArray = Datavalue.validvalues(@attribute.attributedescription.classesuri)
						@exceptionsArray = Datavalue.exceptions(@attribute.attributedescription.classesuri)
						@exceptionValuesArray = Array.new
						@exceptionsArray.each {|exceptionHash| @exceptionValuesArray.push(exceptionHash[:identifier])}
						@legendHash = Hash.new
						@classificationArray.each {|categoryHash| @legendHash[categoryHash[:identifier]] = categoryHash[:title]}
						@exceptionsArray.each {|exceptionHash| @legendHash[exceptionHash[:identifier]] = exceptionHash[:title]}
					elsif @output == "percent" then
						@value = Datavalue.where(:classesuri=>@attribute.attributedescription.classesuri).where(:identifier=>params[:value]).first
						legendFilename = "/production/systems/website/public/schemas/classify/1.0/examples/percent6warm001.json" # FIX THIS HARDCODING
						@legendHash =  JSON(open(legendFilename).read())
						@classificationArray = Legend.dataclasses_from_json_legendHash(@legendHash)
						@exceptionsArray = Legend.exceptions_from_json_legendHash(@legendHash)
						@exceptionValuesArray = Array.new
						@exceptionsArray.each {|exceptionHash| @exceptionValuesArray.push(exceptionHash[:identifier])}
					end
					# create the legend image
					case @output 
					when "dominant" then
						Legend.activerecord2png(@classificationArray + @exceptionsArray, rootname) 
					when "percent" then
						Legend.legendHash2png(@legendHash, rootname)
					end
					# classify the values
					@polygonsHash = Hash.new
					@rowsetArray.each do |row| 
						@polygonsHash[row[:key]] = Hash.new
						@polygonsHash[row[:key]][:value] = row[:value]
						case @output
						when "dominant" then
							@polygonsHash[row[:key]][:rating] = row[:value]
						when "percent" then
							@polygonsHash[row[:key]][:rating] = Classify.numeric(row[:percent], @classificationArray, @exceptionsArray, @exceptionValuesArray)
						end
						@polygonsHash[row[:key]][:percent] = row[:percent]
					end
					# create kml
					File.open("#{rootname}.kml", 'w') do |kml|
						kml.write(render_to_string(:partial => "generate_classified.kml.builder"))
					end
					# zip kml and legend image to create kmz
					`zip -j #{rootname}.kmz #{rootname}.kml #{rootname}.png`
					send_file  ("#{rootname}.kmz"), :type => 'application/vnd.google-earth.kmz', :disposition => 'inline'
					`rm #{rootname}.kml #{rootname}.png #{rootname}*.gif`
					# clean up obsolete files (older than 5 minutes)
					`find #{rootdir}/* -type f -mmin +5 -print | xargs /bin/rm -f`
				when "Measure", "Count" then
				
legendFilename = "/production/systems/website/public/schemas/classify/1.0/examples/precipitation001.json" # FIX THIS HARDCODING
@legendHash =  JSON(open(legendFilename).read())
@polygonsHash = Hash.new
@classificationArray = Legend.dataclasses_from_json_legendHash(@legendHash)
@exceptionsArray = Legend.exceptions_from_json_legendHash(@legendHash)
@exceptionValuesArray = Array.new
@exceptionsArray.each {|exceptionHash| @exceptionValuesArray.push(exceptionHash[:identifier])}
Legend.legendHash2png(@legendHash, rootname)
@polygonsHash = Hash.new
@rowsetArray.each do |row| 
	@polygonsHash[row[@dataset.frameworkkey.to_sym]] = Hash.new
	@polygonsHash[row[@dataset.frameworkkey.to_sym]][:value] = row[params[:attribute].to_sym]
	@polygonsHash[row[@dataset.frameworkkey.to_sym]][:rating] = Classify.numeric(row[params[:attribute].to_sym], @classificationArray, @exceptionsArray, @exceptionValuesArray)
end
					render "test.html"


				end

			else
				render "generate_plain.kml.builder",  :type => :kml
			end
		end
	end


# ADD GDAS  functionality some day - currently not supported
=begin
				if params[:gdas] then
					# TODO move this to a model, passing a large hash
					@themeHash = Hash.new
					#params=Hash.new
					#params[:gdas] = "http://data.gis.agr.gc.ca/vector/ecozones/v1/canada/data/precip1961x1990/rain_jan/gdas.xml"
					gdas = Gdas.read(params[:gdas])
					@frameworkHash = Gdas.framework(gdas)[0]
					@datasetHash = Gdas.dataset(gdas)[0]
					@attributesHash = Gdas.attributes(gdas, "all")
					@rowsetArray = Gdas.rowset(gdas, @datasetHash.KeyType, @attributesHash.keys.collect{|attribute| @attributesHash[attribute][:Description].Type })
					# get the classification to be applied
					#params[:classify] = "http://services.gis.agr.gc.ca/schemas/classify/1.0/examples/temperature002.xml"
					classifyXML = Classify.read(params[:style])
					@classificationArray = Classify.read_ordinal(classifyXML)
					@exceptionsArray = Classify.read_exceptions(classifyXML)
					@exceptionValuesArray = Array.new
					@exceptionsArray.each {|exceptionHash| @exceptionValuesArray.push(exceptionHash[:identifier])}
					@legendHash = Hash.new
					@classificationArray.each {|categoryHash| @legendHash[categoryHash[:identifier]] = categoryHash[:title]}
					@exceptionsArray.each {|exceptionHash| @legendHash[exceptionHash[:identifier]] = exceptionHash[:title]}
					# loop through each member of the @rowsetArray and classify the value
					@polygonsHash = Hash.new
					@rowsetArray.each do |row| 
						@polygonsHash[row[0]] = Hash.new
						@polygonsHash[row[0]][:value] = row[1]
						@polygonsHash[row[0]][:rating] = Classify.numeric(row[1],@classificationArray,@exceptionsArray,@exceptionValuesArray)  # TODO:  eliminate the hard coding of the [1] in row[1] above and here
					end
					if @attributesHash then
						@themeHash["title"] = @attributesHash[@attributesHash.keys[0]][:Description].gattributedescription.Title
					else
						@themeHash["title"] = "Polygons boundaries"
					end
					render "generate_classified.kml.builder",  :type => :kml
=end

end
