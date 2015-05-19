class Place < ActiveRecord::Base
  belongs_to :personal
  
  #attr_accessor :address, :latitude, :longitude
  #geocoded_by :address
  #after_validation :geocode
end
