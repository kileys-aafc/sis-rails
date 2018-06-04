class TextureController < ApplicationController

  before_filter :set_admin
  def set_admin
    if params[:rootdir] == "cansis" then @lang = "en" else @lang = "fr" end
  end

  def calculate
    # based on WPS 2.0 including the "simplify KVP encoding" CR
    # initialize request parameters to prevent errors during subsequent testing
    @responseForm = "RawDataOutput"
    # standardize request parameters
    params.each do |key, value|
      case key.upcase        # clean up letter case in request parameters - TODO - this should be done with metaprogramming
        when "SAND"  then @sand = value
        when "SILT" then @silt = value
        when "CLAY" then @clay = value
        when "RESPONSEFORM" then @responseForm = value
      end # case
    end # params
    # validate request parameters
		@texture = Texture.texture_class(@sand, @silt, @clay)
    case @responseForm
			when "ResponseDocument" then
				# not relevant for this service
			when "XML" then
				render "calculate.xml", :content_type => 'text/xml'
			else
				# return response directly (RawDataOutput)
				render "calculate.txt"
    end
  end

	def client
		@breadcrumbsArray = Array.new
		@breadcrumbsArray.push Breadcrumb.where(:dir=>"services").first
		@columns=1
		render "client_#{@lang}.html.erb" , :layout => "web_#{@lang}.html.erb"
	end

  def batch
    # based on WPS-simple
    # determine if request is for a process description
    if params.size == 2 then
      # request is for a process description document
      @processHash = YAML.load_file("#{Rails.root.to_s}/config/services/wps/processes/TextureClassBatch.yml")
      @lang="en"
      render 'batch_DescribeProcess_response.xml', :content_type => "text/xml" and return and exit 1
    end
    # standardize request parameters
    @responseForm = "CSV"
    params.each do |key, value|
      case key.upcase        # clean up letter case in request parameters - TODO - this should be done with metaprogramming
        when "RESPONSEFORM" then @responseForm = value
      end # case
    end # params
    # parse posted csv file
    require 'csv'
    @textureArray = CSV.parse(params[:csv].read)
    # calculate texture values
    for row in @textureArray do
      row.push(Texture.texture_class(row[1].to_i, row[2].to_i, row[3].to_i))
    end
    # output
		case @responseForm
			when "XML" then 
				render "batch.xml", :content_type => "text/xml"
			else
				# csv
				csv_string = CSV.generate do |csv|
					csv << ["identifier","sand","silt","clay","texture"]
					@textureArray.each { |row| csv << row }
				end
				send_data csv_string, :type => "text/csv", :filename=>"soil_texture_#{Time.now.strftime("%Y-%m-%d_%H-%M")}.csv", :disposition => 'attachment'
		end
  end

end