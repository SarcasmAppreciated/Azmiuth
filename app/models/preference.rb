class Preference < ActiveRecord::Base
	belongs_to :user
	validates :destination_latitude, :inclusion => -90..90, :allow_nil => true
  	validates :destination_longitude,:inclusion => -180..180, :allow_nil => true
end
