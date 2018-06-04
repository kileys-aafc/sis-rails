class ImagesController < ApplicationController
# This service creates different views of the CanSIS photographs

	before_filter :set_admin # run this code before every Action
  
  	def set_admin
			@columns=1
      if params[:rootdir] == "cansis" then @lang = "en" else @lang = "fr" end
      @breadcrumbsArray = Array.new
      @breadcrumbsArray.push Breadcrumb.where(:dir=>"images").first
  	end
	
	def index
    @images=Gallery_image.all
    # identify all factors by region
    raw_regionfactor_ids = Array.new
    for image in @images do
      raw_regionfactor_ids.push([image.region_id,image.factor_id]) if image.factor_id != nil
    end
    @regionfactor_ids = raw_regionfactor_ids.uniq
    # create array of factors for each region
    @regionHash = Hash.new
    @allregions = Gallery_region.all
    @allfactors = Gallery_factor.all
    for region in @allregions do
      @regionHash[region.region_id] = Array.new
      for factor in @allfactors do
        if [[region.region_id,factor.factor_id]] & @regionfactor_ids != [] then 
            @regionHash[region.region_id].push(factor)
        end
      end
    end
		render :action=>"index_#{@lang}", :layout=>"web_#{@lang}"
  end

	def region
    @region = Gallery_region.where(:region_id=>params[:region]).first
    @allregions = Gallery_region.all
		#get data about images to be displayed
		@images = Gallery_landscape_profile.where(:region_id=>params[:region]).order(:sortation)
		#display the images									
		render :action=>"region_#{@lang}", :layout=>"web_#{@lang}"
  	end

	def factor 
    @region = Gallery_region.where(:region_id=>params[:region]).first
    @allregions = Gallery_region.all
		@factor = Gallery_factor.where(:factor_id=>params[:factor]).first
		@displayHash=Hash.new
    for region in @allregions do
      if Gallery_image.where(:region_id=>region.region_id).where(:factor_id => params[:factor]).size > 0 then 
        @displayHash[region.region_id] = true 
        @last_region_id = region.region_id
      else 
        @displayHash[region.region_id] = false 
      end
    end
		#get data about images to be displayed
		@images = Gallery_image.where(:region_id=> params[:region]).where(:factor_id => params[:factor]).order(:class_sort)
		#display the images									
		render :action=>"factor_#{@lang}", :layout=>"web_#{@lang}"
	end

 end
 