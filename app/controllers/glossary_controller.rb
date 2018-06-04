class GlossaryController < ApplicationController
# This service creates different views of the CanSIS glossary

  before_filter :set_admin
  def set_admin
    if params[:rootdir] == "cansis" then @lang = "en" else @lang = "fr" end
    @breadcrumbsArray = Array.new
    @breadcrumbsArray.push Breadcrumb.where(:dir=>"glossary").first
  end
	
	def page_char1
		@columns=1
		#set parameters
		@char1 = params[:char1]
		@SimpleCharArray = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','_']
		@CapitalCharArray = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','#']
		#when char1 equals "_"
		@char1_en = Glossaryterm.where("upper(substr(term_en,1,1)) NOT BETWEEN 'A' AND 'Z'").order('lower(term_en) ASC')
		@char1_fr = Glossaryterm.where("upper(substr(term_fr,1,1)) NOT BETWEEN 'A' AND 'Z'").order('lower(term_fr) ASC')	
		#when char1 not equals "_"
		@char1_all_en = Glossaryterm.where('lower(substr(term_en,1,1)) LIKE ?', @char1.downcase).order('lower(term_en) ASC')
		@char1_all_fr = Glossaryterm.where('lower(substr(term_fr,1,1)) LIKE ?', @char1.downcase).order('lower(term_fr) ASC')	
		render :action => "page_char1_#{@lang}", :layout=>"web_#{@lang}"
 	end

	def search
    # THIS IS NOT IMPLEMENTED ON SIS, AND THERE IS NO CLIENT PAGE.
		#set parameters
		#when term not equals to null
		@term = params[:term]
		@term_not_null_en = Glossaryterm.where('lower(term_en) LIKE ?', "%#{@term}%".downcase).order('lower(term_en) ASC')	
		@term_not_null_fr = Glossaryterm.where('lower(term_fr) LIKE ?', "%#{@term}%".downcase).order('lower(term_fr) ASC')			
    if params[:responseform] == 'html' then
      render :action => "search_page_" + @lang
    else
      render :action => "search_box_" + @lang
    end
 	end

end
