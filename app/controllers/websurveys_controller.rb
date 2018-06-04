class WebsurveysController < ApplicationController
  # this application creates all of the web pages in /publications/surveys

  before_filter :web_page, :only => [:canada, :province, :report]
	
  def web_page
    if params[:rootdir] == "cansis" then @lang = "en" else @lang = "fr" end
    if params[:province] != nil then # must be requesting something for a province
      @prov = params[:province]
      @province = Region.where(:nsdb_code=>@prov.upcase).first
    end
    @breadcrumbsArray = Array.new
    @breadcrumbsArray.push Breadcrumb.where(:dir=>"publications").first
    @breadcrumbsArray.push Breadcrumb.where(:dir=>"publications/surveys").first
  end

	def province
    @columns = 1
    @ssclasses = Soilsurveyclass.where(:province=>params[:province].upcase).order(:sortation)
    if @ssclasses.size == 0 then
      @ssclasses = Soilsurveyclass.where(:province=>"XX").order(:sortation)
    end
    @reports = Soilsurveyreport.where(:province=>@prov).order(:sort_number)
		if params[:format] == "txt" then
			render :action => "province_#{@lang}.txt.erb"
		else
			render :action => "province_#{@lang}", :layout=>"web_#{@lang}"
		end
	end
	
	def report
    @columns = 1
    @report = Soilsurveyreport.where(:report_id=>params[:report]).first
    @maps = Soilsurveymap.where(:report_id=>params[:report]).order(:sortation)
		@breadcrumbsArray.push Breadcrumb.where(:dir=>"publications/surveys/"+@prov).first
    render :action => "report_#{@lang}", :layout=>"web_#{@lang}"
	end

	def indexkml
		# prep
		timestamp = Time.now.strftime("%Y%m%d%H%M%S%L")
		rootdir = "/tmp/rails/website"
		rootname = rootdir + "/index" + timestamp
		@legendname = "index" + timestamp + ".png"
		@surveys = Surveyindex_v2_canada_pat.all
		@dir = self.request.path[1..6]
		# create legend
		require "/production/systems/lsrs/app/helpers/libxml-helper"
		case params[:map]
			when "scanned" then @legend = open("/production/schemas/legend/2.0/examples/soil_survey_scanned_01.xml").read().to_libxml_doc.root
			when "scale" then @legend = open("/production/schemas/legend/2.0/examples/soil_survey_scale_01.xml").read().to_libxml_doc.root
			when "vintage" then @legend = open("/production/schemas/legend/2.0/examples/soil_survey_vintage_01.xml").read().to_libxml_doc.root
		end
		if @dir == "cansis" then @mapsetTitle = @legend.search("//Legend/Classes/@title_en").first.value else @mapsetTitle = @legend.search("//Legend/Classes/@title_fr").first.value end
		classesXmlArray = @legend.search("//Legend/Classes/Class")
		filenum = 0
		for classx in classesXmlArray do
			if @dir == "cansis" then title = classx.search("@title_en").first.value else title = classx.search("@title_fr").first.value end
			color = classx.search("@color").first.value
			width = 80+(title.size*10)
			filenum += 1
			`convert -size 50x30  xc:"##{color}" -bordercolor white -border 10 #{rootname}#{filenum}a.gif`
			`convert  -fill black -size 300x50 -pointsize 20 -gravity west label:"#{title}"  #{rootname}#{filenum}b.gif`
			`montage #{rootname}#{filenum}a.gif #{rootname}#{filenum}b.gif -tile 2x1 -geometry +0+0 #{rootname}#{filenum}c.gif`
		end
		`montage #{rootname}[1-#{filenum}]c.gif -tile 1x#{filenum} -geometry +0+0 #{rootname}joined.gif`
		`convert #{rootname}joined.gif -trim +repage -bordercolor white -border 10 #{rootname}.png`
		# create kml
		File.open("#{rootname}.kml", 'w') do |kml|
			kml.write(render_to_string(:partial =>"index.kml.builder"))
		end
		# create kmz
		`zip -j #{rootname}.kmz #{rootname}.kml #{rootname}.png`
		send_file  ("#{rootname}.kmz"), :type => 'application/vnd.google-earth.kmz', :disposition => 'inline'
		`rm #{rootname}.kml #{rootname}.png`
		# clean up obsolete files (older than 5 minutes)
		`find #{rootdir}/* -type f -mmin +5 -print | xargs /bin/rm -f`
#render :action=>"testkml"
	end

end
