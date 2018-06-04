class HomeController < ApplicationController

  def index
		case request.env["SERVER_NAME"]
			when "website.gis.agr.gc.ca" then render "index-development"
			when "sistest.agr.gc.ca" then render "index-development"
			else render "index-production"
		end
  end

end
