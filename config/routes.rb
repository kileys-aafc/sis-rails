Website::Application.routes.draw do

	# /cansis/glossary/...
  get ':rootdir/glossary/' => 'glossary#page_char1', :char1 => 'a'
  get ':rootdir/glossary/index.html' => 'glossary#page_char1', :char1 => 'a'
  get ':rootdir/glossary/:char1/' => 'glossary#page_char1', :constraints => { :char1 => /[a-z]{1}/ }
  get ':rootdir/glossary/:char1/index.html' => 'glossary#page_char1'
  get ':rootdir/glossary/search.:responseform' => 'glossary#search'

	# /cansis/images/...
  get ':rootdir/images/' => 'images#index'
  get ':rootdir/images/index.html' => 'images#index'
	get ':rootdir/images/:region/' => 'images#region'
  get ':rootdir/images/:region/index.html' => 'images#region'
  get ':rootdir/images/:region/:factor/' => 'images#factor'
  get ':rootdir/images/:region/:factor/index.html' => 'images#factor'
		
	# /cansis/nsdb/...
	get ':rootdir/nsdb/soil/v2/download.:format' => 'soils#download'
  get ':rootdir/nsdb/:framework/:version/:filename.html' => 'webpages#showpage', :constraints => { :version => /[^\/]+/ }
  get ':rootdir/nsdb/:framework/:version/:dataset/' => 'nsdb#showtable', :constraints => { :version => /[^\/]+/ }
  get ':rootdir/nsdb/:framework/:version/:dataset/index.html' => 'nsdb#showtable', :constraints => { :version => /[^\/]+/ }
  get ':rootdir/nsdb/:framework/:version/:dataset/:attribute.html' => 'nsdb#showfield', :constraints => { :version => /[^\/]+/ }
	# legend files
	get ':rootdir/nsdb/:framework/:version/:dataset/:attribute/legend.xml' => 'nsdb#legend', :constraints => { :version => /[^\/]+/ }
	
	# /cansis/publications/maps/...
  get ':rootdir/publications/maps/' => 'maps#maps'
  get ':rootdir/publications/maps/index.html' => 'maps#maps'
  get ':rootdir/publications/maps/:mapgroup/:mapscale/:mapset/' => 'maps#mapset'
  get ':rootdir/publications/maps/:mapgroup/:mapscale/:mapset/index.html' => 'maps#mapset'
	get ':rootdir/publications/maps/:mapgroup/:mapscale/:mapset/index.kml' => 'maps#mapsetkml'
	get ':rootdir/publications/maps/:mapgroup/:mapscale/:mapset/:filename.kml' => 'maps#mapkml'

	# /cansis/soils/...   
	# human readable SNT / SLT information
	get ':rootdir/soils/wadl.xml' => 'wadl#show', :service => 'soils'
	get ':rootdir/soils/provinces.:format' => 'soils#list_provinces'
	get ':rootdir/soils/find.:format' => 'soils#find_soils'
	get ':rootdir/soils/findtest.:format' => 'soils#find_soilstest'
	get ':rootdir/soils/:province/soils.:format' => 'soils#list_soils'
	get ':rootdir/soils/:province/soilcodes.:format' => 'soils#list_soilcodes'
	get ':rootdir/soils/:province/:soilcode/modifiers.:format' => 'soils#list_modifiers'
	get ':rootdir/soils/:province/:soilcode/variants.:format' => 'soils#list_variants'
	get ':rootdir/soils/:province/:soilcode/:modifier/profiles.:format' => 'soils#list_profiles'
	get ':rootdir/soils/:province/:soilcode/:modifier/:profile/description.:format' => 'soils#show_data'
	get 'soildata/:region/:filename.dbf' => 'soils#download_dbf'
	#soil properties
	get ':rootdir/soils/:province/:soilcode/:modifier/:profile/:property/:depth.:format' => 'soils#show_property'

	# /cansis/publications/surveys/...
	get ':rootdir/publications/surveys/:map.kmz' => 'websurveys#indexkml'
  get ':rootdir/publications/surveys/:province/index.:format' => 'websurveys#province'
  get ':rootdir/publications/surveys/:province/:report/index.html' => 'websurveys#report'

	# /cansis/taxa/cssc3/*
  get ':rootdir/taxa/cssc3/orders.json' => 'taxonomy#list_orders'
	get ':rootdir/taxa/cssc3/:order3/index.:format' => 'taxonomy#show_order'
  get ':rootdir/taxa/cssc3/:order3/greatgroups.json' => 'taxonomy#list_greatgroups'
  get ':rootdir/taxa/cssc3/:order3/:ggroup3/index.:format' => 'taxonomy#show_ggroup'
  get ':rootdir/taxa/cssc3/:order3/:ggroup3/subgroups.json' => 'taxonomy#list_subgroups'
  get ':rootdir/taxa/cssc3/:order3/:ggroup3/:sgroup3/index.:format' => 'taxonomy#show_sgroup'

	# TJS
  get ':rootdir/services/tjs' => 'tjs#service'

	# VECTOR
	get '/:rootdir/services/vector/clients/:client.html' => 'vector#clients'
	get '/:rootdir/services/vector/frameworks.:format' => 'vector#list_frameworks'
	get '/:rootdir/services/vector/:framework/versions.:format' => 'vector#list_framework_versions'
	get '/:rootdir/services/vector/:framework/:version/regions.:format' => 'vector#list_framework_regions'
	get '/:rootdir/services/vector/:framework/:version/:region/polygonsets.:format' => 'vector#list_polygonsets'
	get '/:rootdir/services/vector/:framework/:version/:region/polygonids.:format' => 'vector#list_polygon_ids'
	get '/:rootdir/services/vector/:framework/:version/:region/show.:format' => 'vector#show_data'
	get '/:rootdir/services/vector/:framework/:version/:region/datasets.:format' => 'vector#list_datasets'
	get '/:rootdir/services/vector/:framework/:version/:region/:dataset/attributes.:format' => 'vector#list_attributes'
	get '/:rootdir/services/vector/:framework/:version/:region/:dataset/:attribute/description.:format' => 'vector#describe_attribute'
	get '/:rootdir/services/vector/:framework/:version/:region/:dataset/:attribute/values.:format' => 'vector#list_values'
	get '/:rootdir/services/vector/:framework/:version/:region/:dataset/:poly_id.:format' => 'vector#describe_polygon'
#	get '/:rootdir/services/vector/:framework/:version/:region/polygons/map.kml' => 'vector#map_polygons'
	get '/:rootdir/services/vector/:framework/:version/:region/identify_polygon.:format' => 'vector#identify_polygon'
	get '/:rootdir/services/vector/:framework/:version/:region/:poly_id.kml' => 'vector#show_polygon'

	# WADL files
	get ':rootdir/data/:service/wadl.xml' => 'wadl#show'
	get ':rootdir/services/:service/wadl.xml' => 'wadl#show'

	# miscellaneous services
	get ':rootdir/services/:controller/:action'
	post ':rootdir/services/:controller/:action'
  
  # miscellaneous files (found in the MySQL webpages table)
  get ':rootdir/:filename.html' => 'webpages#showpage'
  get ':rootdir/:dir2/:filename.html' => 'webpages#showpage'
  get ':rootdir/:dir2/:dir3/:filename.html' => 'webpages#showpage'
  get ':rootdir/:dir2/:dir3/:dir4/:filename.html' => 'webpages#showpage', :constraints => { :dir4 => /[^\/]+/ }
  get ':rootdir/:dir2/:dir3/:dir4/:dir5/:filename.html' => 'webpages#showpage', :constraints => { :dir4 => /[^\/]+/ }
  get ':rootdir/:dir2/:dir3/:dir4/:dir5/:dir6/:filename.html' => 'webpages#showpage', :constraints => { :dir4 => /[^\/]+/ }

	# splash page
	get '/', :controller => 'home', :action => 'index'
	get '/index.html', :controller => 'home', :action => 'index'
	# home page
	get ':rootdir/' => 'webpages#showpage', :filename => 'index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   get 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   get 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # get ':controller(/:action(/:id(.:format)))'
end
