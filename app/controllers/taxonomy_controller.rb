class TaxonomyController < ApplicationController
# This service creates different views of the Canadian System for Soil Classification taxonomy

	before_filter :web_page, :only => [ :show_order, :show_ggroup, :show_sgroup ]
  
  	def web_page
      if params[:rootdir] == "cansis" then 
        @rootdir = "cansis"
        @lang = "en" 
      else 
        @rootdir = "siscan"
        @lang = "fr" 
      end
			# set parameters
			@order3 = params[:order3]
			#content for breadcrumb
      @breadcrumbsArray = Array.new
      @breadcrumbsArray.push Breadcrumb.where(:dir=>"taxa").first
      @breadcrumbsArray.push Breadcrumb.where(:dir=>"taxa/cssc3").first
			if params[:ggroup3] then 
				@ggroup3 = params[:ggroup3]
				crumb = Breadcrumbhash.new
				crumb.dir = "taxa/cssc3/#{params[:order3]}"
				crumb.filename = "index.html"
				crumb.title_en = params[:order3]
				crumb.title_fr = params[:order3]
				@breadcrumbsArray.push(crumb)
			end
			if params[:sgroup3] then 
				@sgroup3 = params[:sgroup3]
				crumb = Breadcrumbhash.new
				crumb.dir = "taxa/cssc3/#{params[:order3]}/#{params[:ggroup3]}"
				crumb.filename = "index.html"
				crumb.title_en = params[:ggroup3]
				crumb.title_fr = params[:ggroup3]
				@breadcrumbsArray.push(crumb)
			end
      @columns = 1
  	end

	def list_orders
		@orders = Taxonomydetail.where('soilgreatgroup is null').order(:sortation)
		render "list_orders.json", :content_type => "application/json"
	end

	def list_greatgroups
		@greatgroups = Taxonomydetail.where("soilorder = ? AND soilgreatgroup IS NOT NULL AND soilsubgroup IS NULL", params[:order3]).order(:sortation)
		render "list_greatgroups.json", :content_type => "application/json"
	end

	def list_subgroups
		@subgroups = Taxonomydetail.where('soilorder = ?', params[:order3]).where('soilgreatgroup = ? OR solgrandgroupe = ?', params[:ggroup3], params[:ggroup3]).where('soilsubgroup IS NOT NULL').order(:sortation)
		#@subgroups = Taxonomydetail.where("soilorder = ? AND soilgreatgroup = ? AND soilsubgroup IS NOT NULL", params[:order3], params[:ggroup3]).order(:sortation)
		render "list_subgroups.json", :content_type => "application/json"
	end

	def show_order
		@order3details = Taxonomydetail.where(:soilgreatgroup=> "-" ).where(:soilorder=>params[:order3]).first
		@ggroup3_null_gg = Taxonomydetail.where('soilorder = ? and soilgreatgroup is not null and soilsubgroup is null', @order3).order(:sortation)
		case params[:format]
			when "html" then render "show_order_page_#{@lang}.html", :layout=> "web_#{@lang}"
			when "box" then render "show_order_box_#{@lang}.html"
		end
 	end

	def show_ggroup
		@sgroup3_null_gg = Taxonomydetail.where('soilorder = ?', @order3).where('soilgreatgroup = ? OR solgrandgroupe = ?', @ggroup3, @ggroup3).where('soilsubgroup IS NULL').order(:sortation)
		case params[:format]
			when "html" then render "show_ggroup_page_#{@lang}.html", :layout=> "web_#{@lang}"
			when "box" then render "show_ggroup_box_#{@lang}.html"
		end
	end

 	def show_sgroup
		#instance variable to be used when subgroup is null
		@sgroup3_null_gg = Taxonomydetail.where('soilorder = ?', @order3).where('soilgreatgroup = ? OR solgrandgroupe = ?', @ggroup3, @ggroup3).where('soilsubgroup IS NULL').order(:sortation)
		#@sgroup3_null_gg = Taxonomydetail.where('soilorder = ? and soilgreatgroup = ? and soilsubgroup is null', @order3, @ggroup3).order(:sortation)
		#instance variable to be used when listing out the the requested subgroup
		@requested_sg = Taxonomydetail.where('soilorder = ?', @order3).where('soilgreatgroup = ? OR solgrandgroupe = ?', @ggroup3, @ggroup3).where('soilsubgroup = ? OR solsousgroupe = ?', @sgroup3, @sgroup3)
		#@requested_sg = Taxonomydetail.where('soilorder = ? and soilgreatgroup = ? and soilsubgroup = ?', @order3, @ggroup3, @sgroup3).order(:sortation)
		case params[:format]
			when "html" then render "show_sgroup_page_#{@lang}.html", :layout=> "web_#{@lang}"
			when "box" then render "show_sgroup_box_#{@lang}.html"
		end
	end
  
end
