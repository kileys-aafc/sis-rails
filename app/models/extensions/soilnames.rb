# create an extensions directory in models
# app/models/extensions/popular.rb

module Extensions
  module Soilnames
    extend ActiveSupport::Concern

#    # you can include other things here
#    included do
#      include Extensions::OtherCoolStuff
#      # or if you're using Mongoid you can also add fields
#      field :points, :type => Integer, :default => 0
#    end
#
    # include class methods here
    # like User.most_popular
    module ClassMethods
      def soilcodes
        self.group(:soil_code).order(:soil_code)
      end
      def modifiers(soilcode)
        self.where(:soil_code=>soilcode).group(:modifier).order(:modifier)
      end
      def profiles(soilcode,modifier)
        self.where(:soil_code=>soilcode).where(:modifier=>modifier).order(:profile)
      end
      def variants(soilcode)
        self.where(:soil_code=>soilcode).order(:modifier, :profile)
      end
    end

#    # include Instance methods
#    # like @user.popularity
#    module InstanceMethods
#      def popularity
#        1+(self.points/100)
#      end
#    end
  end
end
#
# then you can include these is multiple models
# so you can have DRY code (Don't Repeat Yourself)
#
#class User
#  include Extensions::Popular
#end
#
#class Tags
#  include Extensions::Popular
#end
#
# now all of the following work:
#
#User.most_popular
#Tag.most_popular
#
#@user = User.find(1)
#@user.popularity #= 12
#
#@tag = Tag.find(1)
#@tag.popularity #=> 84
