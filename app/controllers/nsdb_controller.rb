class NsdbController < ApplicationController

	before_filter :web_page, :only => [ :showtable, :showfield ]
  
  def web_page
		if params[:rootdir] == "cansis" then @lang = "en" else @lang = "fr" end
    @breadcrumbsArray = Array.new
    @breadcrumbsArray.push Breadcrumb.where(:dir=>"nsdb").first
    @breadcrumbsArray.push Breadcrumb.where(:dir=>"nsdb/"+params[:framework]).first
		@breadcrumbsArray.push Breadcrumb.where(:dir=>"nsdb/"+params[:framework]+"/"+params[:version]).first
  end

	def showtable
    @columns = 1
		@dataset = Datadataset.find_by_params(params[:framework],params[:version],params[:dataset])
		@attributes = Dataattribute.find_by_dataseturi(@dataset.dataseturi)
    render :action => "showtable_#{@lang}", :layout=>"web_#{@lang}"
	end

	def showfield
    @columns = 1
		@attribute = Dataattribute.find_by_params(params[:framework],params[:version],params[:dataset],params[:attribute])
		@attributedescription=Dataattributedescription.find_by_attributeuri(@attribute.attributeuri)
		@classes = Dataclass.find_by_classesuri(@attributedescription.classesuri)
		@valuegroups = Datavaluegroup.find_by_classesuri(@attributedescription.classesuri)
		@values = Datavalue.find_by_classesuri(@attributedescription.classesuri)
		@breadcrumbsArray.push Breadcrumb.where(:dir=>"nsdb/"+params[:framework]+"/"+params[:version]+"/"+params[:dataset]).first
    render :action => "showfield_#{@lang}", :layout=>"web_#{@lang}"
	end


	def legend
		@attribute = Dataattribute.find_by_params(params[:framework],params[:version],params[:dataset],params[:attribute])
		@attributedescription=Dataattributedescription.find_by_attributeuri(@attribute.attributeuri)
		@classes = Dataclass.find_by_classesuri(@attributedescription.classesuri)
		@valuegroups = Datavaluegroup.find_by_classesuri(@attributedescription.classesuri)
		@values = Datavalue.find_by_classesuri(@attributedescription.classesuri)
		render :action => 'legend.xml', :content_type => "text/xml", :layout => false
	end

end
