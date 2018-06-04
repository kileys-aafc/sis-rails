class MapsController < ApplicationController

	before_filter :web_page, :only => [:maps, :mapset]
  
  def web_page
    @columns = 1
    if params[:rootdir] == "cansis" then @lang = "en" else @lang = "fr" end
    @breadcrumbsArray = Array.new
    @breadcrumbsArray.push Breadcrumb.where(:dir=>"publications").first
  end
  
	def maps
		@mapGroups = Mapgroup.where(:publish=>"Y").order('sortation')
		@mapSets = Mapset.where(:publish=>"Y").order(:sortation)
    render :action => "index_#{@lang}", :layout=>"web_#{@lang}"
	end

	def mapset
    @mapGroup = Mapgroup.where(:publish=>"Y", :subdirectory=>params[:mapgroup] + "/" + params[:mapscale] ).order(:sortation).first
		@mapSet = Mapset.where(:publish=>"Y", :subdirectory=>params[:mapgroup] + "/" + params[:mapscale] + "/" + params[:mapset]).first
    @mapSheets = Mapsheet.where(:mapgroup=>@mapSet.mapgroup, :mapset=>@mapSet.mapset).order(:sortation, :mapsheet)
    @breadcrumbsArray.push Breadcrumb.where(:dir=>"publications/maps").first
    render :action => "mapset_#{@lang}", :layout=>"web_#{@lang}"
	end
	
	def mapsetkml
		timestamp = Time.now.strftime("%Y%m%d%H%M%S%L")
		rootdir = "/tmp/rails/website"
		rootname = rootdir + "/index" + timestamp
		@mapSet = Mapset.where(:subdirectory=>params[:mapgroup] + "/" + params[:mapscale] + "/" + params[:mapset]).first
		@mapSheets = Mapsheet.where(:mapgroup=>@mapSet.mapgroup, :mapset=>@mapSet.mapset).order(:sortation, :mapsheet)
		@dir = self.request.path[1..6]
		# create legend
		`touch #{rootname}.png`
		# create kml
		File.open("#{rootname}.kml", 'w') do |kml|
			kml.write(render_to_string(:partial => "maps/mapset.kml.builder"))
		end
		# create kmz
		`zip #{rootname}.kmz #{rootname}.kml #{rootname}.png`
		send_file  ("#{rootname}.kmz"), :type => 'application/vnd.google-earth.kmz', :disposition => 'inline'
		`rm #{rootname}.kml`
		`rm #{rootname}*a.gif #{rootname}*b.gif #{rootname}*c.gif #{rootname}joined.gif #{rootname}.png`
		# clean up obsolete files (older than 5 minutes)
		`find #{rootdir}/* -type f -mmin +5 -print | xargs /bin/rm -f`
	end
	
	def mapkml
		@mapSet = Mapset.where(:subdirectory=>params[:mapgroup] + "/" + params[:mapscale] + "/" + params[:mapset]).first
		@map = Mapsheet.where(:mapgroup=>@mapSet.mapgroup).where(:mapset=>@mapSet.mapset).where(:mapsheet=>params[:filename].split("_")[3..-1].join("_") ).first
		@dir = @mapSet.subdirectory
		render :action => "map.kml"
	end
	
end
