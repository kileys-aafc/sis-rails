class Webappmethod < ActiveRecord::Base
	self.table_name="metadata.webappmethods"
	
	belongs_to :webappresource
	
	has_many :webappexamples, -> {order 'sortation'}
	has_many :webapptemplateparams, -> {order 'sortation' }
	has_many :webappqueryparams, -> {order 'sortation'}
	has_many :webappresponses, -> {order 'sortation'}
	
end
