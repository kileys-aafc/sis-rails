class SoilsController < ApplicationController

	before_filter :set_admin_variables # run this code before every Action
	after_filter :set_headers, :only => [ :list_provinces, :list_soilcodes, :list_modifiers, :list_profiles, :list_variants ]

	def set_admin_variables
		if params[:rootdir] == "cansis" then 
			@rootdir = "cansis"
			@lang = "en" 
		else 
			@rootdir = "siscan"
			@lang = "fr" 
		end
		if params[:format] == "html" then
			@breadcrumbsArray = Array.new
			@breadcrumbsArray.push Breadcrumb.where(:dir=>"soils").first
			if params[:province] and params[:action] != "list_soils" then 
				bread1 = Breadcrumbhash.new
				bread1.dir = "soils/#{params[:province]}"
				bread1.filename = "soils.html"
				bread1.title_en = params[:province].upcase
				bread1.title_fr = params[:province].upcase
				@breadcrumbsArray.push(bread1)
			end
			if params[:soilcode] then 
				bread2 = Breadcrumbhash.new
				bread2.dir = "soils/#{params[:province]}/#{params[:soilcode]}"
				bread2.filename = "modifiers.html"
				bread2.title_en = params[:soilcode]
				bread2.title_fr = params[:soilcode]
				@breadcrumbsArray.push(bread2)
			end
			if params[:modifier] then 
				bread3 = Breadcrumbhash.new
				bread3.dir = "soils/#{params[:province]}/#{params[:soilcode]}/#{params[:modifier]}"
				bread3.filename = "profiles.html"
				bread3.title_en = params[:modifier]
				bread3.title_fr = params[:modifier]
				@breadcrumbsArray.push(bread3)
			end
			@columns = 1
		end
	end

	def set_headers
		headers['Access-Control-Request-Method'] = '*' 
		headers['Access-Control-Allow-Origin'] = '*' 
	end
	
	# ACTIONS

	def list_provinces
		@provinces = Region.provinces
		case params[:format]
			when "json" then render "list_provinces.json"
			when "html" then render "list_provinces_#{@lang}.html", :layout=> "web_#{@lang}"
		end
	end

	def list_soils
		@soils = eval("Soil_name_#{params[:province]}_v2").all
		render "list_soils_#{@lang}.html", :layout=> "web_#{@lang}"
	end

	def list_soilcodes
		@soilcodes = eval("Soil_name_#{params[:province]}_v2").soilcodes
		case params[:format]
			when "json" then render "list_soilcodes.json"
			when "html" then render "list_soilcodes_#{@lang}.html", :layout=> "web_#{@lang}"
		end
	end

	def list_modifiers
		@modifiers = eval("Soil_name_#{params[:province]}_v2").modifiers(params[:soilcode])
		case params[:format]
			when "json" then render "list_modifiers.json"
			when "html" then render "list_modifiers_#{@lang}.html", :layout=> "web_#{@lang}"
		end
	end

	def list_profiles
		@profiles = eval("Soil_name_#{params[:province]}_v2").profiles(params[:soilcode], params[:modifier])
		case params[:format]
			when "json" then render "list_profiles.json"
			when "html" then render "list_profiles_#{@lang}.html", :layout=> "web_#{@lang}"
		end
	end

	def list_variants
		@variants = eval("Soil_name_#{params[:province]}_v2").variants(params[:soilcode])
		case params[:format]
			when "json" then render "list_variants.json"
			when "html" then render "list_variants_#{@lang}.html", :layout=> "web_#{@lang}"
		end
	end

	def show_data
		# soil name data
		@nameData = eval("Soil_name_#{params[:province]}_v2").where(:soil_id=>params[:province].upcase+params[:soilcode]+params[:modifier]+params[:profile]).first
		@nameColumns = Array.new
		eval("Soil_name_#{params[:province]}_v2.columns").each{|c| @nameColumns.push c.name}
		# soil layer data
		@layerData = eval("Soil_layer_#{params[:province]}_v2").where(:soil_id=>params[:province].upcase+params[:soilcode]+params[:modifier]+params[:profile]).order(:layer_no)
		@layerColumns = Array.new
		eval("Soil_layer_#{params[:province]}_v2.columns").each{|c| @layerColumns.push c.name}
		case params[:format]
			when "json" then render "show_data.json"
			when "html" then render "show_data_#{@lang}.html", :layout=> "web_#{@lang}"
		end
	end

	def show_property
		@layerData = eval("Soil_layer_#{params[:province]}_v2").where(:soil_id=>params[:province].upcase+params[:soilcode]+params[:modifier]+params[:profile]).order(:layer_no)
		depthsRequested = params[:depth].split("cm")[0].split("-").map{|n| n.to_i}
		@outputHash = Layer.resample(depthsRequested[0], depthsRequested[1], @layerData, params[:property])
		case params[:format]
			when "debug" then render "show_property.debug"
			when "html" then render "show_property.html"
			else render "show_property.txt"
		end
	end

	def find_soils_old
		if params[:provinces] then @provinceCodes = params[:provinces].split(",") & Region.provinces.collect{|p| p.code.downcase} else @provinceCodes = Region.provinces.collect{|p| p.code.downcase} end
		if params[:orders] then @orderCodes = params[:orders].split(",").collect{|e| e.upcase} end
		if params[:ggroups] then @ggroupCodes = params[:ggroups].split(",").collect{|e| e.upcase} end
		if params[:sgroups] then @sgroupCodes = params[:sgroups].split(",").collect{|e| e.upcase} end
		if @lang == "fr" then
			if params[:ggroups] then @ggroupCodes = @ggroupCodes.collect{|gg| Taxonomydetail.where(:solgrandgroupe=>gg).first.soilgreatgroup} end
			if params[:sgroups] then @sgroupCodes = @sgroupCodes.collect{|sg| Taxonomydetail.where(:solsousgroupe=>sg).first.soilsubgroup} end
		end
		@found = []
		for prov in @provinceCodes do
			@found += eval("Soil_name_#{prov}_v2").where("order3 in (?)",@orderCodes).collect{|s| s.soil_id}
			@found += eval("Soil_name_#{prov}_v2").where("g_group3 in (?)",@ggroupCodes).collect{|s| s.soil_id}
			@found += eval("Soil_name_#{prov}_v2").where("s_group3 in (?)",@sgroupCodes).collect{|s| s.soil_id}
		end
		completeMatch = (request.query_parameters.select {|k,v| v!=""}.keys & ["orders","ggroups", "sgroups"] ).size
		@soils = @found.each_with_object(Hash.new(0)){ |m,h| h[m] += 1 }.select {|k,v| v==completeMatch}.keys.sort
		case params[:format]
			when "json" then render "find_soils.json"
			when "html" then render "find_soils_#{@lang}.html", :layout=> "web_#{@lang}"
		end
	end

	def find_soils
		if params[:provinces] then @provinceCodes = params[:provinces].split(",") & Region.provinces.collect{|p| p.code.downcase} else @provinceCodes = Region.provinces.collect{|p| p.code.downcase} end
		#if just provinces requested then list all soils
		if (request.query_parameters.select {|k,v| v!=""}.keys & ["orders","ggroups", "sgroups", "names", "kinds"] ).size == 0 then
			@soils = []
			for prov in @provinceCodes do
				@soils += eval("Soil_name_#{prov}_v2").all.collect{|s| s.soil_id}
			end
		#otherwise, collect matches
		else
			@found = []
			if params[:orders] then @orderCodes = params[:orders].split(",").collect{|e| e.upcase} end
			if params[:ggroups] then @ggroupCodes = params[:ggroups].split(",").collect{|e| e.upcase} end
			if params[:sgroups] then @sgroupCodes = params[:sgroups].split(",").collect{|e| e.upcase} end
			if params[:names] then @names = params[:names].split(",").collect{|e| e} end
			if params[:kinds] then @kindCodes = params[:kinds].split(",").collect{|e| e.upcase} end
			if @lang == "fr" then
				if params[:ggroups] then @ggroupCodes = @ggroupCodes.collect{|gg| Taxonomydetail.where(:solgrandgroupe=>gg).first.soilgreatgroup} end
				if params[:sgroups] then @sgroupCodes = @sgroupCodes.collect{|sg| Taxonomydetail.where(:solsousgroupe=>sg).first.soilsubgroup} end
			end
			completeMatch = (request.query_parameters.select {|k,v| v!=""}.keys & ["orders","ggroups", "sgroups","names","kinds"] ).size
			for prov in @provinceCodes do
				if params[:orders] != "" then @found += eval("Soil_name_#{prov}_v2").where("order3 in (?)",@orderCodes).collect{|s| s.soil_id} end
				if params[:ggroups] != "" then @found += eval("Soil_name_#{prov}_v2").where("g_group3 in (?)",@ggroupCodes).collect{|s| s.soil_id} end
				if params[:sgroups] != "" then @found += eval("Soil_name_#{prov}_v2").where("s_group3 in (?)",@sgroupCodes).collect{|s| s.soil_id} end
				if !params[:names].blank? then
					@foundNames = []
					for name in @names do
						@foundNames += eval("Soil_name_#{prov}_v2").where("soilname like (?)","%#{name}%").collect{|s| s.soil_id}
					end
					@found += @foundNames.uniq
				end
				if params[:kinds] != "" then @found += eval("Soil_name_#{prov}_v2").where("kind in (?)",@kindCodes).collect{|s| s.soil_id} end
			end
			@soils = @found.each_with_object(Hash.new(0)){ |m,h| h[m] += 1 }.select {|k,v| v==completeMatch}.keys.sort
		end
		case params[:format]
			when "json" then render "find_soils.json"
			when "html" then render "find_soils_#{@lang}.html", :layout=> "web_#{@lang}"
		end
	end

	def download
		@filenames = Dir.glob("/production/soildata/*/*").collect{|f| f.split("/").last}
    @breadcrumbsArray = Array.new
    @breadcrumbsArray.push Breadcrumb.where(:dir=>"nsdb").first
    @breadcrumbsArray.push Breadcrumb.where(:dir=>"nsdb/soil").first
    @breadcrumbsArray.push Breadcrumb.where(:dir=>"nsdb/soil/v2").first
		render "download_#{@lang}.html" , :layout=> "web_#{@lang}"
	end

	def download_dbf
		send_file  ("/production/soildata/#{params[:region]}/#{params[:filename]}.dbf"), :type => 'application/dbf', :disposition => 'inline'
	end

end
