class WebpagesController < ApplicationController
	
	def showpage
    if params[:rootdir] == "cansis" then @lang = "en" else @lang = "fr" end
    @breadcrumbsArray = Array.new
    dirArray = request.url.split('/')[4..-2]
    if dirArray[0] != nil then @breadcrumbsArray.push Breadcrumb.where(:dir=>dirArray[0]).first end
    if dirArray[1] != nil then @breadcrumbsArray.push Breadcrumb.where(:dir=>dirArray[0..1].join('/')).first end
    if dirArray[2] != nil then @breadcrumbsArray.push Breadcrumb.where(:dir=>dirArray[0..2].join('/')).first end
    if dirArray[3] != nil then @breadcrumbsArray.push Breadcrumb.where(:dir=>dirArray[0..3].join('/')).first end
    if dirArray[4] != nil then @breadcrumbsArray.push Breadcrumb.where(:dir=>dirArray[0..4].join('/')).first end
		if params[:filename] == "index" then @breadcrumbsArray.delete_at(-1) end
    if dirArray.size == 0 then 
      @webpage = Page.where(:dirname=>"").where(:filename=>params[:filename]).first
    else
      @webpage = Page.where(:dirname=>"/"+dirArray.join('/')).where(:filename=>params[:filename]).first
    end
		@columns=@webpage.columns
    render :action=>"showpage_#{@lang}", :layout=>"web_#{@lang}"
  end

end
