class WadlController < ApplicationController

	def show
		if params[:rootdir] == "cansis" then 
			@rootdir = "cansis"
			@lang = "en" 
		else 
			@rootdir = "siscan"
			@lang = "fr" 
		end
		@application = Webapplication.where(:name=>params[:service]).first
		render :action => "WADL_#{@lang}.xml.builder"
	end

end
