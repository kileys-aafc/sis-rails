class TjsController < ApplicationController
# an implentation of OJC's Table Joining Service version 1.0

	after_filter :set_headers, :only => [ :service ]
	def set_headers
		headers['Access-Control-Request-Method'] = '*' 
		headers['Access-Control-Allow-Origin'] = '*' 
	end


	def test
params = Hash.new
params[:dataseturi]="http://sis.agr.gc.ca/cansis/nsdb/ecozones/v1/landform"
	end


  def service
    # initialize request parameters to prevent errors during subsequent testing
    @acceptVersions = @version = @language = @xsl = @frameworkURI = @datasetURI = @exceptionCode = @exceptionParameter = @filterfield = @filtervalue = String.new
		@attributeNamesRequestedArray = Array.new
		@versionsArray = Array.new
		@languagesArray = Array.new

    # load configuration info
    @capabilitiesHash = YAML.load_file("#{Rails.root}/config/services/tjs/tjs.yml")
		@activeRecord = true # true for most, but not joindata

    # standardize request parameters
    params.each do |key, value|
      case key.upcase        # clean up letter case in request parameters
        when "SERVICE"  then @service = value
        when "REQUEST"  then @request = value
        when "VERSION"  then @version = value
				when "ACCEPTVERSIONS" then @acceptVersions = value
        when "LANGUAGE" then @language = value
        when "FRAMEWORKURI" then @frameworkURI = value
        when "DATASETURI" then @datasetURI = value
        when "ATTRIBUTES" then @attributeNamesRequestedArray = value.split(/,/)  # split attribute names into an array
        when "LINKAGEKEYS" then @linkageKeys = value
        when "XSL"      then @xsl = value
        when "AID"      then @aid= value
        when "GETDATAURL" then @getDataURL = value
        when "STYLINGIDENTIFIER" then @stylingIdentifier = value
        when "STYLINGURL" then @stylingURL = value
				when "CLASSIFICATIONURL" then @classificationURL = value
				when "FILTERFIELD" then @filterfield = value
				when "FILTERVALUE" then @filtervalue = value
      end # case
    end # params
		@rootURL = "http://" + request.host + @capabilitiesHash['OperationsMetadata']['HTTP']['Get']

    # perform basic error checking
    if !(defined? @service) then @exceptionCode = "MissingParameterValue"; @exceptionParameter = "SERVICE"; render :action => '1.0/Error_response', :content_type => 'text/xml', :layout => false and return and exit 1 end
    if !(defined? @request) then @exceptionCode = "MissingParameterValue"; @exceptionParameter = "REQUEST"; render :action => '1.0/Error_response', :content_type => 'text/xml', :layout => false and return and exit 1 end
		
    case @service 
      when "TJS"
				# negotiate language of response
				require 'negotiate'
				@lang = Negotiate.Language(@language, @capabilitiesHash)
				@lang_extension = "_" + (@lang.downcase.gsub "-", "_")

				if @request.upcase == "GETCAPABILITIES" then
					# negotiate version of response and
					if defined? @acceptVersions then 
						@version = Negotiate.Version(@acceptVersions, @capabilitiesHash['OperationsMetadata']['Versions'].to_s) 
					end
					# return response
					render '/tjs/1.0/GetCapabilities_response', :content_type => 'text/xml', :layout => false and return and exit 1
				end

        case @version  # determine which response should be returned
          when "1.0"
            if @request.upcase == "DESCRIBEFRAMEWORKS" then
              @frameworksArray = Dataframework.where(:publish=>"true") # get appropriate records 
              render '/tjs/1.0/DescribeFrameworks_response.xml', :content_type => 'text/xml', :layout => false and return and exit 1

            elsif @request.upcase == "DESCRIBEDATASETS" then
              @frameworksArray = Dataframework.where(:frameworkuri=>@frameworkURI).where(:publish=>"true") # get appropriate records 
              @datasetsArray = Datadataset.where(:frameworkuri=>@frameworkURI).where(:publish=>"true")
              render '/tjs/1.0/DescribeDatasets_response.xml', :content_type => 'text/xml', :layout => false and return and exit 1

            elsif @request.upcase == "DESCRIBEDATA" or @request.upcase == "GETDATA" then 
							# error checking
              if @datasetURI.empty? then @exceptionCode = "MissingParameterValue"; @exceptionParameter = "DatasetURI"; render :action => '1.0/Error_response', :content_type => 'text/xml', :layout => false and return and exit 1 end
							if @request.upcase == "GETDATA" then
								if @frameworkURI.empty? then @exceptionCode = "MissingParameterValue"; @exceptionParameter = "FrameworkURI"; render :action => '1.0/Error_response', :content_type => 'text/xml', :layout => false and return and exit 1 end
							end
							# get info from database
							@frameworksArray = Dataframework.where(:frameworkuri=>@frameworkURI) # get appropriate records 
              @datasetsArray = Datadataset.where(:frameworkuri=>@frameworkURI).where(:dataseturi=>@datasetURI)
              @attributesArray = Dataattribute.where(:dataseturi=>@datasetURI)
							@attributeNamesArray = Array.new
              if @attributeNamesRequestedArray.empty? # if no attributes were specified then all are required, so populate @attributeNamesArray if empty
                for attribute in @attributesArray
									if attribute.purpose != "PrimarySpatialIdentifier" then
										@attributeNamesArray << attribute.attribute_name
									end
                end
							else # component attributes plus requested attributes are required
                for attribute in @attributesArray
									if attribute.purpose == "SpatialComponentIdentifier" then @attributeNamesArray << attribute.attribute_name end
									if attribute.purpose == "SpatialComponentPercentage" then @attributeNamesArray << attribute.attribute_name end
									if @attributeNamesRequestedArray.include?(attribute.attribute_name) then @attributeNamesArray << attribute.attribute_name end
                end
              end
							@allAttributesHash = Tjs.attributes(@datasetsArray[0].dataseturi, @attributeNamesArray)
							if @request.upcase == "DESCRIBEDATA" then 
								render '/tjs/1.0/DescribeData_response.xml', :content_type => 'text/xml', :layout => false and return and exit 1
							elsif @request.upcase == "GETDATA" then
								# TODO:  SORT ROWs BY K
								# load data from the database into an array
								for dataset in @datasetsArray do # if data tables are correct there should only be one name....should check for this above.
									@warehouseName = dataset.dataset_name.capitalize
								end
								if @filterfield != "" and @filtervalue != "" then
									@rowsetArray = eval("#{@warehouseName}.where(@filterfield=>@filtervalue)") 
								else
									@rowsetArray = eval("#{@warehouseName}.all")
								end
								render '/tjs/1.0/GetData_response.xml', :content_type => 'text/xml; subtype=gdas/1.0', :layout => false and return and exit 1
							end

            elsif @request.upcase == "DESCRIBEJOINABILITIES" then
              @frameworksArray = Dataframework.where(:joindata=>"true").where(:publish=>"true") # get appropriate records
              render :action => '1.0/DescribeJoinAbilities_response', :content_type => 'text/xml', :layout => false and return and exit 1

            elsif @request.upcase == "DESCRIBEKEY" then
              @frameworksArray = Dataframework.where(:joindata=>"true") # get appropriate records 
              if @frameworksArray.size != 1 then @exceptionCode = "DataframeworkKeyNotUnique"; @exceptionParameter = "gframeworkHash"; @exceptionParameterValue = @gframeworkHash; render :action => '1.0/Error_response', :content_type => 'text/xml', :layout => false and return and exit 1 end
              @datasetsArray = Datadataset.where(:frameworkkeydescription=>"true")
              case @datasetsArray.size # check to see that zero or one dataset is identified as describing the framework keys.
                when 0 # use the PAT
                  warehouseName=@frameworksArray[0].WarehouseName.capitalize
                when 1 # use the custom file
                  warehouseName=@datasetsArray[0].WarehouseName.capitalize
                else
                  @exceptionCode = "InvalidParameterValue"; @exceptionParameter = "gdatasetHash"; @exceptionParameterValue = @gdatasetHash; render :action => '1.0/Error_response', :content_type => 'text/xml', :layout => false and return and exit 1
              end
              @dataArray = eval("#{warehouseName}.all")
              render :action => '1.0/DescribeKey_response', :content_type => 'text/xml', :layout => false and return and exit 1

            elsif @request.upcase == "JOINDATA" then
              if @gframeworkHash.empty? then @exceptionCode = "MissingParameterValue"; @exceptionParameter = "FRAMEWORKURI"; @exceptionParameterValue = @frameworkURI; render :action => '1.0/Error_response', :content_type => 'text/xml', :layout => false and return and exit 1 end
              @all_frameworks = Dataframework.where(:conditions=>@gframeworkHash) # get appropriate records 
              if @all_frameworks.size != 1 then @exceptionCode = "DataframeworkKeyNotUnique"; @exceptionParameter = "gframeworkHash"; @exceptionParameterValue = @gframeworkHash; render :action => '1.0/Error_response', :content_type => 'text/xml', :layout => false and return and exit 1 end
              @warehouseName=@all_frameworks[0].ShapeName.capitalize
              @originalPAT = eval("#{@warehouseName}.all")
							if !(defined? @getDataURL) then @exceptionCode = "MissingParameterValue"; @exceptionParameter = "GETDATAURL"; render :action => '1.0/Error_response', :content_type => 'text/xml', :layout => false and return and exit 1 end
              require "#{Rails.root}/app/helpers/libxml-helper"
              require "open-uri"
              @gdas = open(@getDataURL).read().to_libxml_doc.root
              @gdas.register_default_namespace("tjs")
							require "gdas_read"
							@dataset = GDAS_read.dataset(@gdas)[0] 
							#check to ensure that relationship is N:One, not Many 
#              keyRelationship = @gdas.search("//tjs:GDAS/tjs:Framework/tjs:Dataset/tjs:KeyRelationship").first.content
              if @dataset.KeyRelationship == "many" then @exceptionCode = "InvalidParameterValue"; @exceptionParameter = "GDAS relationship must be 'one', not 'many'"; render :action => '1.0/Error_response', :content_type => 'text/xml', :layout => false and return and exit 1 end
							# subset GDAS content to faciliate further processing
					    rowsXmlArray = @gdas.search("//tjs:GDAS/tjs:Framework/tjs:Dataset/tjs:Rowset/tjs:Row")
							
							@allAttributesHash = GDAS_read.attributes(@gdas, "some")
							# populate attributeHash with the contents of the first attribute whose purpose == data
							for attribute in @allAttributesHash.keys
								if @allAttributesHash[attribute]['Description'].Purpose == "Attribute"  then @requestedAttribute = attribute and break end 
							end
							@attributeNamesArray = @requestedAttribute 
							#@allAttributesHash[attribute]['Description'].TitlePrefix = ""
# TODO: check to see if styling file exists 
              if @stylingURL != nil then @styling = open(@stylingURL).read().to_libxml_doc.root else @styling = "n/a" end
							# deal with classification
							if @classificationURL != nil 
								require "classify"
								classificationXML = open(@classificationURL).read().to_libxml_doc.root
								@classificationArray = Classify.read_ordinal(classificationXML)
								@exceptionsArray = Classify.read_exceptions(classificationXML)
							else 
								@rangesArray = @exceptionsArray = "n/a" 
							end
							# build output product
							@directory = Wms_create.Directories
							Wms_create.Shapefile(@allAttributesHash[@requestedAttribute], rowsXmlArray, @warehouseName, @originalPAT, @all_frameworks, @directory.tmpMapDir, @classificationArray, @exceptionsArray)
							Wms_create.MapFile(@directory.tmpMapDir, @directory.tmpHtmDir, @directory.tmpDirName, @all_frameworks, @allAttributesHash[@requestedAttribute], @styling, @classificationArray, @exceptionsArray)
							Wms_create.MapservScript(@directory.tmpCgiDir, @directory.tmpMapDir)
							#require "socket"
							#if Socket.gethostname == "zephyr" then @domainName = "metamapper.com" else @domainName = "zonbu"end
							@domainName = YAML.load_file("#{Rails.root}/config/server.yml")["DomainName"]
							@activeRecord = false
              render :action => '1.0/JoinData_response', :content_type => 'text/xml', :layout => false and return and exit 1

            else # request is not supported
              @exceptionCode = "InvalidParameterValue"
              @exceptionParameter = "REQUEST"
              @exceptionParameterValue = @request
              render :action => '1.0/Error_response', :content_type => 'text/xml', :layout => false and return and exit 1
            end
          when "0.10.2"
            if @request.upcase == "DESCRIBEFRAMEWORKS" then
              if @gframeworkHash.empty? 
                @all_frameworks = Dataframework.all # no selection specified, so get all
              else
                @all_frameworks = Dataframework.where(:conditions=>@gframeworkHash) # get appropriate records 
              end
              render :action => 'tjs/0.10.2/DescribeFrameworks_response', :content_type => 'text/xml', :layout => false and return and exit 1
            end
          else 
            # requested version is not supported    
            @exceptionCode = "InvalidParameterValue"; @exceptionParameter = "VERSION"; @exceptionParameterValue = @version
            render :action => '1.0/Error_response', :content_type => 'text/xml', :layout => false and return and exit 1
          end # of possible versions
        else # not a supported request
        @exceptionCode = "InvalidParameterValue"; @exceptionParameter = "SERVICE"; @exceptionParameterValue = @service
        render :action => '1.0/Error_response', :content_type => 'text/xml', :layout => false and return and exit 1
    end # of possible SERVICE types
  end

end

