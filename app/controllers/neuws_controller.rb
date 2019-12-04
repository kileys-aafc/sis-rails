class NeuwsController < ApplicationController
  
  def publish
    @neuws = Neuw.where('created_at > "2010-01-01"').order('created_at DESC')
    @oldNeuws = Neuw.where('created_at < "2010-01-01"').order('created_at ASC')
    @breadcrumbsArray = Array.new
    if params[:rootdir] == "cansis" then @lang = "en" else @lang = "fr" end
    respond_to do |format|
      format.html { render :action => "neuw_#{@lang}", :layout=>"web_#{@lang}" }
      format.xml { render :action => "neuw_#{@lang}" }
    end
  end

end
